import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

import '../../../../core/error/exceptions.dart';

abstract class QuickTriggerDataSource {
  Stream<int> get triggers;
}

class QuickTriggerDataSourceImpl implements QuickTriggerDataSource {
  static const _channel = MethodChannel('com.elumi.prankcall/quick_call');

  StreamController<int>? _controller;

  @override
  Stream<int> get triggers {
    final existing = _controller;
    if (existing != null) return existing.stream;
    final controller = StreamController<int>.broadcast(onListen: _takePending);
    _controller = controller;
    if (Platform.isAndroid) {
      _channel.setMethodCallHandler((call) async {
        if (call.method == 'quickCall' && call.arguments is int) {
          controller.add(call.arguments as int);
        }
      });
    }
    return controller.stream;
  }

  Future<void> _takePending() async {
    if (!Platform.isAndroid) return;
    try {
      final delay = await _channel.invokeMethod<int>('takePending');
      if (delay != null) _controller?.add(delay);
    } on PlatformException catch (e) {
      _controller?.addError(CallKitException(FailureReason.unknown, e.message));
    }
  }
}
