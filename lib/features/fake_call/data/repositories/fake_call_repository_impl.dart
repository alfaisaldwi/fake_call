import 'dart:async';
import 'dart:developer';

import 'package:clock/clock.dart';
import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/call_config.dart';
import '../../domain/entities/call_event.dart';
import '../../domain/entities/pending_call.dart';
import '../../domain/entities/call_preferences.dart';
import '../../domain/repositories/fake_call_repository.dart';
import '../datasources/call_alarm_data_source.dart';
import '../datasources/fake_call_native_data_source.dart';
import '../datasources/missed_call_notification_data_source.dart';
import '../datasources/call_preferences_local_data_source.dart';
import '../datasources/ring_vibration_data_source.dart';
import '../models/call_config_model.dart';
import '../models/call_event_model.dart';
import '../models/scheduled_call_model.dart';

class FakeCallRepositoryImpl implements FakeCallRepository {
  final FakeCallNativeDataSource dataSource;
  final CallAlarmDataSource alarm;
  final MissedCallNotificationDataSource missedCallNotifier;
  final RingVibrationDataSource ringVibration;
  final CallPreferencesLocalDataSource callPreferences;
  final Uuid uuid;

  final _events = StreamController<CallEvent>.broadcast();
  StreamSubscription<CallEventModel>? _nativeSubscription;
  StreamSubscription<ScheduledCallModel>? _alarmSubscription;
  _CallSession? _session;

  FakeCallRepositoryImpl({
    required this.dataSource,
    required this.alarm,
    required this.missedCallNotifier,
    required this.ringVibration,
    required this.callPreferences,
    required this.uuid,
  });

  @override
  Future<Either<Failure, PendingCall>> scheduleCall(CallConfig config) async {
    try {
      await dataSource.ensurePermissions(needsCamera: config.isVideoCall);
    } on PermissionException catch (e) {
      return Left(PermissionFailure(e.reason, detail: e.detail));
    }
    _listenToNativeEvents();
    _listenToAlarms();
    _closeSession();

    final now = clock.now();
    final scheduled = ScheduledCallModel(
      id: uuid.v4(),
      callConfig: CallConfigModel.fromEntity(config),
      scheduledAt: now,
      ringsAt: config.ringsAtFrom(now),
    );
    _arm(scheduled);
    try {
      await alarm.schedule(scheduled);
    } on CallKitException catch (e) {
      log('Alarm scheduling failed, using in-app timer', error: e);
    }
    return Right(scheduled);
  }

  @override
  Future<Either<Failure, PendingCall?>> restorePendingCall() async {
    _listenToNativeEvents();
    _listenToAlarms();
    final session = _session;
    if (session != null) return Right(session.isWaiting ? session.due : null);
    final ScheduledCallModel? pending;
    try {
      pending = await alarm.pending();
    } on CallKitException catch (e) {
      return Left(CallKitFailure(e.reason, detail: e.detail));
    }
    if (pending == null || !pending.ringsAt.isAfter(clock.now())) {
      return const Right(null);
    }
    if (_session != null) return const Right(null);
    _arm(pending);
    return Right(pending);
  }

  @override
  Future<Either<Failure, bool>> ringDueCall() async {
    _listenToNativeEvents();
    _listenToAlarms();
    final ScheduledCallModel? due;
    try {
      due = await alarm.takeDue();
    } on CallKitException catch (e) {
      return Left(CallKitFailure(e.reason, detail: e.detail));
    }
    if (due == null || _session != null) return const Right(false);
    final session = _CallSession(due.callConfig, due: due);
    _session = session;
    await _ring(session);
    return const Right(true);
  }

  @override
  Future<Either<Failure, Unit>> finishDueCall() async {
    try {
      await alarm.release();
      return const Right(unit);
    } on CallKitException catch (e) {
      return Left(CallKitFailure(e.reason, detail: e.detail));
    }
  }

  @override
  Future<Either<Failure, Stream<CallEvent>>> listenToCallEvents() async {
    _listenToNativeEvents();
    _listenToAlarms();
    return Right(_events.stream);
  }

  @override
  Future<Either<Failure, Unit>> endCall() async {
    final session = _session;
    if (session == null) return const Right(unit);
    _closeSession();
    if (session.isWaiting) _cancelAlarm(session);

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

  void _listenToAlarms() {
    _alarmSubscription ??= alarm.fired.listen(
      _onAlarmFired,
      onError: (Object e) => log('Alarm event failed', error: e),
    );
  }

  void _arm(ScheduledCallModel scheduled) {
    final session = _CallSession(scheduled.callConfig, due: scheduled);
    _session = session;
    final wait = scheduled.ringsAt.difference(clock.now());
    session.timer = Timer(
      wait.isNegative ? Duration.zero : wait,
      () => _ringDue(session),
    );
  }

  void _onAlarmFired(ScheduledCallModel fired) {
    final session = _session;
    if (session == null) {
      final adopted = _CallSession(fired.callConfig, due: fired);
      _session = adopted;
      _ring(adopted);
      return;
    }
    if (session.due?.id == fired.id) _ringDue(session);
  }

  void _ringDue(_CallSession session) {
    if (!identical(_session, session) || !session.isWaiting) return;
    session.timer?.cancel();
    _cancelAlarm(session);
    _ring(session);
  }

  void _cancelAlarm(_CallSession session) {
    final id = session.due?.id;
    if (id == null) return;
    alarm
        .cancel(id)
        .catchError((Object e) => log('Alarm cancel failed', error: e));
  }

  Future<void> _ring(_CallSession session) async {
    if (!identical(_session, session)) return;
    final callId = uuid.v4();
    session
      ..attempt += 1
      ..isAccepted = false
      ..callId = callId;
    try {
      final ring = await _callPreferences();
      await dataSource.showIncomingCall(
        session.config,
        callId: callId,
        attempt: session.attempt,
        ringtone: ring.ringtone,
      );
      if (identical(_session, session) && !session.isAccepted) {
        _setVibration(ring.vibrate);
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

  Future<CallPreferences> _callPreferences() async {
    try {
      return await callPreferences.getPreferences();
    } on CacheException catch (e) {
      log('Ring preferences unavailable, using defaults', error: e);
      return const CallPreferences();
    }
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
  final ScheduledCallModel? due;
  int attempt = 0;
  int missedCount = 0;
  String? callId;
  bool isAccepted = false;
  Timer? timer;

  _CallSession(this.config, {this.due});

  bool get isWaiting => attempt == 0;
}
