import 'package:equatable/equatable.dart';

class ClockTime extends Equatable {
  final int hour;
  final int minute;

  const ClockTime(this.hour, this.minute)
    : assert(hour >= 0 && hour < 24),
      assert(minute >= 0 && minute < 60);

  DateTime nextAfter(DateTime now) {
    final today = DateTime(now.year, now.month, now.day, hour, minute);
    return today.isAfter(now) ? today : today.add(const Duration(days: 1));
  }

  @override
  List<Object> get props => [hour, minute];
}
