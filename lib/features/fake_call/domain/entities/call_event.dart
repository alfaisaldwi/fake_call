import 'package:equatable/equatable.dart';

import 'call_config.dart';

enum CallEventType {
  incoming,
  accepted,
  recallScheduled,
  declined,
  timeout,
  ended,
  cancelled;

  bool get isTerminal => switch (this) {
    declined || timeout || ended || cancelled => true,
    incoming || accepted || recallScheduled => false,
  };
}

class CallEvent extends Equatable {
  final String callId;
  final CallEventType type;
  final int attempt;
  final CallConfig? config;

  const CallEvent({
    required this.callId,
    required this.type,
    this.attempt = 1,
    this.config,
  });

  @override
  List<Object?> get props => [callId, type, attempt, config];
}
