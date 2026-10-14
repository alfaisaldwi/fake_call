import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/entities/app_permission.dart';

abstract class PermissionDataSource {
  Future<bool> isGranted(AppPermission permission);

  Future<void> request(AppPermission permission);
}

class PermissionDataSourceImpl implements PermissionDataSource {
  static const _power = MethodChannel('com.elumi.prankcall/power');

  @override
  Future<bool> isGranted(AppPermission permission) async {
    try {
      return switch (permission) {
        AppPermission.notification => await Permission.notification.isGranted,
        AppPermission.camera => await Permission.camera.isGranted,
        AppPermission.fullScreen =>
          !Platform.isAndroid ||
              await FlutterCallkitIncoming.canUseFullScreenIntent(),
        AppPermission.exactAlarm => await _powerFlag('canScheduleExact'),
        AppPermission.battery => await _powerFlag('isBatteryUnrestricted'),
      };
    } on PlatformException catch (e) {
      throw PermissionException(
        FailureReason.permissionRequestFailed,
        e.message,
      );
    }
  }

  @override
  Future<void> request(AppPermission permission) async {
    try {
      switch (permission) {
        case AppPermission.notification:
          final status = await Permission.notification.request();
          if (status.isPermanentlyDenied) await openAppSettings();
        case AppPermission.camera:
          final status = await Permission.camera.request();
          if (status.isPermanentlyDenied) await openAppSettings();
        case AppPermission.fullScreen:
          if (Platform.isAndroid) {
            await FlutterCallkitIncoming.requestFullIntentPermission();
          }
        case AppPermission.exactAlarm:
          await _openPowerSettings('openExactAlarmSettings');
        case AppPermission.battery:
          await _openPowerSettings('openBatterySettings');
      }
    } on PlatformException catch (e) {
      throw PermissionException(
        FailureReason.permissionRequestFailed,
        e.message,
      );
    }
  }

  Future<bool> _powerFlag(String method) async {
    if (!Platform.isAndroid) return true;
    return await _power.invokeMethod<bool>(method) ?? true;
  }

  Future<void> _openPowerSettings(String method) async {
    if (Platform.isAndroid) await _power.invokeMethod<void>(method);
  }
}
