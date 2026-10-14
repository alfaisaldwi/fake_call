import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/entities/app_info.dart';

abstract class AppInfoDataSource {
  Future<AppInfo> getAppInfo();
}

class AppInfoDataSourceImpl implements AppInfoDataSource {
  @override
  Future<AppInfo> getAppInfo() async {
    try {
      final info = await PackageInfo.fromPlatform();
      return AppInfo(version: info.version, buildNumber: info.buildNumber);
    } on PlatformException catch (e) {
      throw CacheException(FailureReason.unknown, e.message);
    }
  }
}
