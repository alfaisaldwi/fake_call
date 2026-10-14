import 'package:equatable/equatable.dart';

import 'call_config.dart';

class PendingCall extends Equatable {
  final CallConfig config;
  final DateTime scheduledAt;
  final DateTime ringsAt;

  const PendingCall({
    required this.config,
    required this.scheduledAt,
    required this.ringsAt,
  });

  int get totalSeconds => ringsAt.difference(scheduledAt).inSeconds;

  int remainingSecondsAt(DateTime now) {
    final millis = ringsAt.difference(now).inMilliseconds;
    return millis <= 0 ? 0 : (millis / 1000).ceil();
  }

  @override
  List<Object> get props => [config, scheduledAt, ringsAt];
}
