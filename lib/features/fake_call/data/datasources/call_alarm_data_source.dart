import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';

import '../../../../core/error/exceptions.dart';
import '../models/scheduled_call_model.dart';

abstract class CallAlarmDataSource {
  Future<void> schedule(ScheduledCallModel call);

  Future<void> cancel(String id);

  Future<ScheduledCallModel?> pending();

  Future<ScheduledCallModel?> takeDue();

  Future<void> release();

  Stream<ScheduledCallModel> get fired;
}

class CallAlarmDataSourceImpl implements CallAlarmDataSource {
  static const _channel = MethodChannel('com.elumi.fakecalling/call_alarm');

  StreamController<ScheduledCallModel>? _fired;

  @override
  Future<void> schedule(ScheduledCallModel call) {
    return _invoke('schedule', jsonEncode(call.toJson()));
  }

  @override
  Future<void> cancel(String id) => _invoke('cancel', id);

  @override
  Future<ScheduledCallModel?> pending() => _read('pending');

  @override
  Future<ScheduledCallModel?> takeDue() => _read('takeDue');

  @override
  Future<void> release() => _invoke('release');

  @override
  Stream<ScheduledCallModel> get fired {
    final existing = _fired;
    if (existing != null) return existing.stream;
    final controller = StreamController<ScheduledCallModel>.broadcast();
    _fired = controller;
    if (Platform.isAndroid) {
      _channel.setMethodCallHandler((call) async {
        if (call.method != 'alarmFired' || call.arguments is! String) {
          throw MissingPluginException(call.method);
        }
        controller.add(_decode(call.arguments as String));
      });
    }
    return controller.stream;
  }

  Future<ScheduledCallModel?> _read(String method) async {
    if (!Platform.isAndroid) return null;
    try {
      final raw = await _channel.invokeMethod<String>(method);
      return raw == null ? null : _decode(raw);
    } on PlatformException catch (e) {
      throw CallKitException(FailureReason.callScheduleFailed, e.message);
    }
  }

  Future<void> _invoke(String method, [Object? arguments]) async {
    if (!Platform.isAndroid) return;
    try {
      await _channel.invokeMethod<void>(method, arguments);
    } on PlatformException catch (e) {
      throw CallKitException(FailureReason.callScheduleFailed, e.message);
    }
  }

  ScheduledCallModel _decode(String raw) {
    try {
      return ScheduledCallModel.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
    } on FormatException catch (e) {
      throw CallKitException(FailureReason.callScheduleFailed, e.message);
    } on TypeError catch (e) {
      throw CallKitException(FailureReason.callScheduleFailed, '$e');
    }
  }
}
