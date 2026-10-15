import 'dart:io';

import 'package:flutter/services.dart';

import '../../../../core/error/exceptions.dart';

abstract class CallScreenNativeDataSource {
  Future<void> setProximityLock(bool enabled);

  Future<bool> takeIncomingVideoOff();
}

class CallScreenNativeDataSourceImpl implements CallScreenNativeDataSource {
  static const _channel = MethodChannel('com.elumi.fakecalling/call_screen');

  @override
  Future<void> setProximityLock(bool enabled) async {
    if (!Platform.isAndroid) return;
    try {
      await _channel.invokeMethod<void>('setProximityLock', enabled);
    } on PlatformException catch (e) {
      throw MediaException(FailureReason.unknown, e.message);
    }
  }

  @override
  Future<bool> takeIncomingVideoOff() async {
    if (!Platform.isAndroid) return false;
    try {
      return await _channel.invokeMethod<bool>('takeIncomingVideoOff') ?? false;
    } on PlatformException {
      return false;
    }
  }
}
