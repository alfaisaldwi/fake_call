import 'package:fake_calling/features/fake_call/data/models/call_config_model.dart';
import 'package:fake_calling/features/fake_call/data/models/scheduled_call_model.dart';
import 'package:fake_calling/features/fake_call/domain/entities/clock_time.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const config = CallConfigModel(
    delayInSeconds: 60,
    callerName: 'Pak Bos',
    ringAt: ClockTime(14, 30),
    initialDurationSeconds: 300,
  );

  test('jam dering dan durasi awal ikut tersimpan', () {
    final restored = CallConfigModel.fromJson(config.toJson());

    expect(restored.ringAt, const ClockTime(14, 30));
    expect(restored.initialDurationSeconds, 300);
    expect(restored.props, config.props);
  });

  test('data lama tanpa field baru tetap terbaca', () {
    final restored = CallConfigModel.fromJson({
      'delayInSeconds': 10,
      'callerName': 'Mama',
    });

    expect(restored.ringAt, isNull);
    expect(restored.initialDurationSeconds, 0);
  });

  test('jam dering yang tidak valid diabaikan', () {
    final restored = CallConfigModel.fromJson({
      ...config.toJson(),
      'ringAt': {'hour': 25, 'minute': 0},
    });

    expect(restored.ringAt, isNull);
  });

  test('jadwal panggilan bolak-balik lewat JSON', () {
    final scheduled = ScheduledCallModel(
      id: 'abc',
      callConfig: config,
      scheduledAt: DateTime.fromMillisecondsSinceEpoch(1000),
      ringsAt: DateTime.fromMillisecondsSinceEpoch(61000),
    );

    final restored = ScheduledCallModel.fromJson(scheduled.toJson());

    expect(restored, scheduled);
    expect(restored.totalSeconds, 60);
  });
}
