import 'dart:async';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/call_config.dart';
import '../../domain/entities/call_event.dart';
import '../../domain/repositories/fake_call_repository.dart';
import '../datasources/fake_call_native_data_source.dart';
import '../datasources/missed_call_notification_data_source.dart';
import '../datasources/ring_vibration_data_source.dart';
import '../models/call_config_model.dart';
import '../models/call_event_model.dart';

class FakeCallRepositoryImpl implements FakeCallRepository {
  final FakeCallNativeDataSource dataSource;
  final MissedCallNotificationDataSource missedCallNotifier;
  final RingVibrationDataSource ringVibration;
  final Uuid uuid;

  final _events = StreamController<CallEvent>.broadcast();
  StreamSubscription<CallEventModel>? _nativeSubscription;
  _CallSession? _session;

  FakeCallRepositoryImpl({
    required this.dataSource,
    required this.missedCallNotifier,
    required this.ringVibration,
    required this.uuid,
  });

  @override
  Future<Either<Failure, Unit>> scheduleCall(CallConfig config) async {
    try {
      await dataSource.ensurePermissions(needsCamera: config.isVideoCall);
    } on PermissionException catch (e) {
      return Left(PermissionFailure(e.reason, detail: e.detail));
    }
    _listenToNativeEvents();
    _closeSession();

    final session = _CallSession(CallConfigModel.fromEntity(config));
    _session = session;
    session.timer = Timer(
      Duration(seconds: config.delayInSeconds),
      () => _ring(session),
    );
    return const Right(unit);
  }

  @override
  Future<Either<Failure, Stream<CallEvent>>> listenToCallEvents() async {
    _listenToNativeEvents();
    return Right(_events.stream);
  }

  @override
  Future<Either<Failure, Unit>> endCall() async {
    final session = _session;
    if (session == null) return const Right(unit);
    _closeSession();

    final callId = session.callId;
    _emit(
      session,
      session.isAccepted ? CallEventType.ended : CallEventType.cancelled,
    );
    if (callId == null) return const Right(unit);
    try {
      await dataSource.endCall(callId);
      return const Right(unit);
    } on CallKitException catch (e) {
      return Left(CallKitFailure(e.reason, detail: e.detail));
    }
  }

  @override
  Future<Either<Failure, Unit>> syncActiveCall() async {
    final CallEventModel? accepted;
    try {
      accepted = await dataSource.findAcceptedCall();
    } on CallKitException catch (e) {
      return Left(CallKitFailure(e.reason, detail: e.detail));
    }
    if (accepted == null) return const Right(unit);
    _listenToNativeEvents();

    final session = _session;
    if (session != null && session.callId == accepted.callId) {
      if (!session.isAccepted) _markAccepted(session);
      return const Right(unit);
    }
    final config = accepted.config;
    if (session == null && config != null) {
      final restored = _CallSession(config)
        ..attempt = accepted.attempt
        ..callId = accepted.callId;
      _session = restored;
      _markAccepted(restored);
    }
    return const Right(unit);
  }

  void _listenToNativeEvents() {
    _nativeSubscription ??= dataSource.callEvents.listen(
      _onNativeEvent,
      onError: (Object e) => _events.addError(
        e is CallKitException
            ? CallKitFailure(e.reason, detail: e.detail)
            : CallKitFailure(FailureReason.callEventsFailed, detail: '$e'),
      ),
    );
  }

  Future<void> _ring(_CallSession session) async {
    if (!identical(_session, session)) return;
    final callId = uuid.v4();
    session
      ..attempt += 1
      ..isAccepted = false
      ..callId = callId;
    try {
      await dataSource.showIncomingCall(
        session.config,
        callId: callId,
        attempt: session.attempt,
      );
      if (identical(_session, session) && !session.isAccepted) {
        _setVibration(true);
      }
    } on CallKitException catch (e) {
      if (!identical(_session, session)) return;
      _closeSession();
      _events.addError(CallKitFailure(e.reason, detail: e.detail));
    }
  }

  void _onNativeEvent(CallEventModel event) {
    final session = _session;
    if (session == null || event.callId != session.callId) return;
    if (session.isAccepted && event.type != CallEventType.ended) return;

    switch (event.type) {
      case CallEventType.incoming:
        _emit(session, CallEventType.incoming);
      case CallEventType.accepted:
        _markAccepted(session);
      case CallEventType.declined:
      case CallEventType.timeout:
        _handleMissedCall(session, event.type);
      case CallEventType.ended:
        if (!session.isAccepted) {
          _handleMissedCall(session, CallEventType.declined);
          return;
        }
        _closeSession();
        _emit(session, CallEventType.ended);
      case CallEventType.recallScheduled:
      case CallEventType.cancelled:
        break;
    }
  }

  void _handleMissedCall(_CallSession session, CallEventType reason) {
    _setVibration(false);
    if (reason == CallEventType.timeout) session.missedCount++;
    if (!session.config.canRecallAfter(session.attempt)) {
      _closeSession();
      _emit(session, reason);
      _notifyMissedCalls(session);
      return;
    }
    session.callId = null;
    session.timer = Timer(
      Duration(seconds: session.config.autoRecallInterval),
      () => _ring(session),
    );
    _events.add(
      CallEventModel(
        callId: '',
        type: CallEventType.recallScheduled,
        attempt: session.attempt + 1,
      ),
    );
  }

  void _markAccepted(_CallSession session) {
    _setVibration(false);
    session.isAccepted = true;
    _scheduleAutoHangup(session);
    _emit(session, CallEventType.accepted);
  }

  Future<void> _notifyMissedCalls(_CallSession session) async {
    if (session.missedCount == 0) return;
    try {
      await missedCallNotifier.showMissedCall(
        session.config,
        count: session.missedCount,
      );
    } on Exception catch (e) {
      log('Missed call notification failed', error: e);
    }
  }

  void _scheduleAutoHangup(_CallSession session) {
    if (!session.config.hasAutoHangup) return;
    session.timer?.cancel();
    session.timer = Timer(
      Duration(seconds: session.config.autoHangupSeconds),
      () {
        if (identical(_session, session)) endCall();
      },
    );
  }

  void _emit(_CallSession session, CallEventType type) {
    _events.add(
      CallEventModel(
        callId: session.callId ?? '',
        type: type,
        attempt: session.attempt,
        config: session.config,
      ),
    );
  }

  void _setVibration(bool on) {
    final action = on ? ringVibration.start() : ringVibration.stop();
    action.catchError((Object e) => log('Ring vibration failed', error: e));
  }

  void _closeSession() {
    if (_session != null) _setVibration(false);
    _session?.timer?.cancel();
    _session = null;
  }
}

class _CallSession {
  final CallConfigModel config;
  int attempt = 0;
  int missedCount = 0;
  String? callId;
  bool isAccepted = false;
  Timer? timer;

  _CallSession(this.config);
}
