import 'package:equatable/equatable.dart';

import 'failure_reason.dart';

export 'failure_reason.dart';

abstract class Failure extends Equatable {
  final FailureReason reason;
  final String? detail;
  final int? limit;

  const Failure(this.reason, {this.detail, this.limit});

  @override
  List<Object?> get props => [reason, detail, limit];
}

class CallKitFailure extends Failure {
  const CallKitFailure(super.reason, {super.detail, super.limit});
}

class PermissionFailure extends Failure {
  const PermissionFailure(super.reason, {super.detail, super.limit});
}

class MediaFailure extends Failure {
  const MediaFailure(super.reason, {super.detail, super.limit});
}

class CacheFailure extends Failure {
  const CacheFailure(super.reason, {super.detail, super.limit});
}

class UpdateFailure extends Failure {
  const UpdateFailure(super.reason, {super.detail, super.limit});
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.reason, {super.detail, super.limit});
}
