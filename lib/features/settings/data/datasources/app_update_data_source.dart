import 'dart:io';

import 'package:flutter/services.dart';
import 'package:in_app_update_flutter/in_app_update_flutter.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/entities/app_update.dart';

abstract class AppUpdateDataSource {
  Future<AppUpdateAvailability> checkForUpdate();

  Future<bool> startUpdate();
}

class AppUpdateDataSourceImpl implements AppUpdateDataSource {
  final InAppUpdateFlutter plugin;

  AppUpdateDataSourceImpl({required this.plugin});

  @override
  Future<AppUpdateAvailability> checkForUpdate() async {
    if (!Platform.isAndroid) return AppUpdateAvailability.unsupported;
    try {
      final info = await plugin.checkUpdateAndroid();
      final available =
          info.updateAvailability ==
                  UpdateAvailabilityAndroid.updateAvailable &&
              info.isImmediateUpdateAllowed ||
          info.updateAvailability ==
              UpdateAvailabilityAndroid.developerTriggeredUpdateInProgress;
      return available
          ? AppUpdateAvailability.available
          : AppUpdateAvailability.upToDate;
    } on PlatformException catch (e) {
      throw UpdateException(FailureReason.updateCheckFailed, e.message);
    }
  }

  @override
  Future<bool> startUpdate() async {
    if (!Platform.isAndroid) return false;
    try {
      final result = await plugin.startImmediateUpdateAndroid();
      return switch (result) {
        UpdateResultAndroid.success => true,
        UpdateResultAndroid.userCanceled => false,
        UpdateResultAndroid.inAppUpdateFailed => throw const UpdateException(
          FailureReason.updateFailed,
        ),
      };
    } on PlatformException catch (e) {
      throw UpdateException(FailureReason.updateFailed, e.message);
    }
  }
}
