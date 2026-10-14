import 'package:fake_call/features/fake_call/domain/entities/call_config.dart';
import 'package:fake_call/features/fake_call/domain/entities/clock_time.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime(2026, 10, 14, 9, 15);

  test('jam yang belum lewat berdering hari ini', () {
    expect(
      const ClockTime(9, 30).nextAfter(now),
      DateTime(2026, 10, 14, 9, 30),
    );
  });

  test('jam yang sudah lewat berdering besok', () {
    expect(
      const ClockTime(9, 15).nextAfter(now),
      DateTime(2026, 10, 15, 9, 15),
    );
    expect(const ClockTime(7, 0).nextAfter(now), DateTime(2026, 10, 15, 7, 0));
  });

  test('config memakai jeda bila jam dering kosong', () {
    const config = CallConfig(delayInSeconds: 60, callerName: 'Mama');

    expect(config.ringsAtFrom(now), now.add(const Duration(minutes: 1)));
    expect(
      config.copyWith(ringAt: const ClockTime(10, 0)).ringsAtFrom(now),
      DateTime(2026, 10, 14, 10, 0),
    );
  });
}
