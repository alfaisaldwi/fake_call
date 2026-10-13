import 'failure_reason.dart';

export 'failure_reason.dart';

abstract class AppException implements Exception {
  final FailureReason reason;
  final String? detail;

  const AppException(this.reason, [this.detail]);

  @override
  String toString() => '$runtimeType($reason, $detail)';
}

class CallKitException extends AppException {
  const CallKitException(super.reason, [super.detail]);
}

class PermissionException extends AppException {
  const PermissionException(super.reason, [super.detail]);
}

class MediaException extends AppException {
  const MediaException(super.reason, [super.detail]);
}

class CacheException extends AppException {
  const CacheException(super.reason, [super.detail]);
}
