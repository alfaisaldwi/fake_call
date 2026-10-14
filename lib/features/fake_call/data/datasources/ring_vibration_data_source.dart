import 'dart:io';

import 'package:flutter/services.dart';

abstract class RingVibrationDataSource {
  Future<void> start();

  Future<void> stop();
}

class RingVibrationDataSourceImpl implements RingVibrationDataSource {
  static const _channel = MethodChannel('com.elumi.prankcall/ring_vibration');

  @override
  Future<void> start() => _invoke('start');

  @override
  Future<void> stop() => _invoke('stop');

  Future<void> _invoke(String method) async {
    if (!Platform.isAndroid) return;
    await _channel.invokeMethod<void>(method);
  }
}
