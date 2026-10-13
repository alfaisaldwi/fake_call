import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';

enum CallConfigField { callerName, delay, autoHangup, autoRecall }

class CallConfigIssue extends Equatable {
  final CallConfigField field;
  final FailureReason reason;
  final int? limit;

  const CallConfigIssue(this.field, this.reason, {this.limit});

  @override
  List<Object?> get props => [field, reason, limit];
}

class InvalidCallConfigFailure extends ValidationFailure {
  final CallConfigField field;

  InvalidCallConfigFailure(CallConfigIssue issue)
    : field = issue.field,
      super(issue.reason, limit: issue.limit);

  @override
  List<Object?> get props => [reason, limit, field];
}
