import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart' as callkit;
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/l10n/app_locale_holder.dart';
import '../../domain/entities/call_event.dart';
import '../models/call_config_model.dart';
import '../models/call_event_model.dart';
import 'avatar_host_data_source.dart';

abstract class FakeCallNativeDataSource {
  Future<void> ensurePermissions({required bool needsCamera});

  Future<void> showIncomingCall(
    CallConfigModel config, {
    required String callId,
    required int attempt,
  });

  Future<void> endCall(String callId);

  Future<CallEventModel?> findAcceptedCall();

  Stream<CallEventModel> get callEvents;
}

class FakeCallNativeDataSourceImpl implements FakeCallNativeDataSource {
  static const _power = MethodChannel('com.elumi.prankcall/power');

  final AvatarHostDataSource avatarHost;
  final AppLocaleHolder localeHolder;

  FakeCallNativeDataSourceImpl({
    required this.avatarHost,
    required this.localeHolder,
  });

  @override
  Future<void> ensurePermissions({required bool needsCamera}) async {
    final strings = localeHolder.strings;
    try {
      await FlutterCallkitIncoming.requestNotificationPermission({
        'title': strings.notificationPermissionTitle,
        'rationaleMessagePermission': strings.notificationPermissionRationale,
        'postNotificationMessageRequired':
            strings.notificationPermissionSettings,
      });
      if (Platform.isAndroid &&
          !await FlutterCallkitIncoming.canUseFullScreenIntent()) {
        await FlutterCallkitIncoming.requestFullIntentPermission();
        throw const PermissionException(
          FailureReason.fullScreenPermissionRequired,
        );
      }
      if (Platform.isAndroid &&
          await _power.invokeMethod<bool>('canScheduleExact') == false) {
        await _power.invokeMethod<void>('openExactAlarmSettings');
        throw const PermissionException(
          FailureReason.exactAlarmPermissionRequired,
        );
      }
      if (needsCamera && Platform.isAndroid) {
        await Permission.camera.request();
      }
    } on PlatformException catch (e) {
      throw PermissionException(
        FailureReason.permissionRequestFailed,
        e.message,
      );
    }
  }

  @override
  Future<void> showIncomingCall(
    CallConfigModel config, {
    required String callId,
    required int attempt,
  }) async {
    try {
      final avatarUrl = await avatarHost.resolveNativeAvatarUrl(
        config.callerAvatarPath,
      );
      await FlutterCallkitIncoming.showCallkitIncoming(
        config.toCallKitParams(
          callId: callId,
          attempt: attempt,
          nativeAvatarUrl: avatarUrl,
          strings: localeHolder.strings,
        ),
      );
    } on PlatformException catch (e) {
      throw CallKitException(FailureReason.callStartFailed, e.message);
    } on SocketException {
      throw const CallKitException(FailureReason.avatarPreparationFailed);
    }
  }

  @override
  Future<void> endCall(String callId) async {
    try {
      await FlutterCallkitIncoming.endCall(callId);
    } on PlatformException catch (e) {
      throw CallKitException(FailureReason.callEndFailed, e.message);
    }
  }

  @override
  Future<CallEventModel?> findAcceptedCall() async {
    try {
      final calls = await FlutterCallkitIncoming.activeCalls();
      final accepted = calls.where((call) => call.isAccepted).firstOrNull;
      if (accepted == null) return null;
      final extra = accepted.extra;
      return CallEventModel(
        callId: accepted.id,
        type: CallEventType.accepted,
        attempt: extra?['attempt'] as int? ?? 1,
        config: _configFromExtra(extra),
      );
    } on PlatformException catch (e) {
      throw CallKitException(FailureReason.callEventsFailed, e.message);
    }
  }

  CallConfigModel? _configFromExtra(Map<String, dynamic>? extra) {
    if (extra == null || extra['callerName'] is! String) return null;
    try {
      return CallConfigModel.fromJson(extra);
    } on Object {
      return null;
    }
  }

  @override
  Stream<CallEventModel> get callEvents {
    return FlutterCallkitIncoming.onEvent
        .map(_mapEvent)
        .where((event) => event != null)
        .cast<CallEventModel>()
        .handleError(
          (Object e) => throw CallKitException(
            FailureReason.callEventsFailed,
            e is PlatformException ? e.message : e.toString(),
          ),
        );
  }

  CallEventModel? _mapEvent(callkit.CallEvent? event) {
    return switch (event) {
      callkit.CallEventActionCallIncoming(:final callKitParams) =>
        CallEventModel(callId: callKitParams.id, type: CallEventType.incoming),
      callkit.CallEventActionCallAccept(:final callKitParams) => CallEventModel(
        callId: callKitParams.id,
        type: CallEventType.accepted,
      ),
      callkit.CallEventActionCallDecline(:final callKitParams) =>
        CallEventModel(callId: callKitParams.id, type: CallEventType.declined),
      callkit.CallEventActionCallEnded(:final callKitParams) => CallEventModel(
        callId: callKitParams.id,
        type: CallEventType.ended,
      ),
      callkit.CallEventActionCallTimeout(:final id) => CallEventModel(
        callId: id,
        type: CallEventType.timeout,
      ),
      _ => null,
    };
  }
}
