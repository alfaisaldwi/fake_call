import 'dart:async';

import 'package:clock/clock.dart';
import 'package:dartz/dartz.dart';
import 'package:fake_async/fake_async.dart';
import 'package:fake_calling/core/error/exceptions.dart';
import 'package:fake_calling/features/fake_call/data/datasources/call_alarm_data_source.dart';
import 'package:fake_calling/features/fake_call/data/datasources/fake_call_native_data_source.dart';
import 'package:fake_calling/features/fake_call/data/datasources/missed_call_notification_data_source.dart';
import 'package:fake_calling/features/fake_call/data/datasources/ring_vibration_data_source.dart';
import 'package:fake_calling/features/fake_call/data/models/call_config_model.dart';
import 'package:fake_calling/features/fake_call/data/models/call_event_model.dart';
import 'package:fake_calling/features/fake_call/data/models/scheduled_call_model.dart';
import 'package:fake_calling/features/fake_call/data/repositories/fake_call_repository_impl.dart';
import 'package:fake_calling/features/fake_call/domain/entities/call_config.dart';
import 'package:fake_calling/features/fake_call/domain/entities/call_event.dart';
import 'package:fake_calling/features/fake_call/domain/entities/clock_time.dart';
import 'package:fake_calling/features/fake_call/domain/entities/pending_call.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

class _FakeNativeDataSource implements FakeCallNativeDataSource {
  final native = StreamController<CallEventModel>.broadcast(sync: true);
  final shown = <String>[];
  final ended = <String>[];
  bool denyPermission = false;
  CallEventModel? acceptedCall;

  String get lastCallId => shown.last;

  void send(CallEventType type) {
    native.add(CallEventModel(callId: lastCallId, type: type));
  }

  @override
  Future<void> ensurePermissions({required bool needsCamera}) async {
    if (denyPermission) {
      throw const PermissionException(FailureReason.permissionRequestFailed);
    }
  }

  @override
  Future<void> showIncomingCall(
    CallConfigModel config, {
    required String callId,
    required int attempt,
  }) async {
    shown.add(callId);
    native.add(CallEventModel(callId: callId, type: CallEventType.incoming));
  }

  @override
  Future<void> endCall(String callId) async => ended.add(callId);

  @override
  Future<CallEventModel?> findAcceptedCall() async => acceptedCall;

  @override
  Stream<CallEventModel> get callEvents => native.stream;
}

class _FakeAlarm implements CallAlarmDataSource {
  final firedController = StreamController<ScheduledCallModel>.broadcast(
    sync: true,
  );
  ScheduledCallModel? scheduled;
  ScheduledCallModel? due;
  final cancelled = <String>[];
  bool released = false;

  @override
  Future<void> schedule(ScheduledCallModel call) async => scheduled = call;

  @override
  Future<void> cancel(String id) async {
    cancelled.add(id);
    if (scheduled?.id == id) scheduled = null;
  }

  @override
  Future<ScheduledCallModel?> pending() async => scheduled;

  @override
  Future<ScheduledCallModel?> takeDue() async {
    final taken = due;
    due = null;
    return taken;
  }

  @override
  Future<void> release() async => released = true;

  @override
  Stream<ScheduledCallModel> get fired => firedController.stream;
}

class _FakeMissedCallNotifier implements MissedCallNotificationDataSource {
  final shown = <(String, int)>[];

  @override
  Future<void> showMissedCall(
    CallConfigModel config, {
    required int count,
  }) async {
    shown.add((config.callerName, count));
  }
}

class _FakeRingVibration implements RingVibrationDataSource {
  final log = <String>[];

  bool get isOn => log.isNotEmpty && log.last == 'start';

  @override
  Future<void> start() async => log.add('start');

  @override
  Future<void> stop() async => log.add('stop');
}

void main() {
  late _FakeNativeDataSource dataSource;
  late _FakeAlarm alarm;
  late _FakeMissedCallNotifier notifier;
  late _FakeRingVibration vibration;
  late FakeCallRepositoryImpl repository;
  late List<CallEvent> events;

  const config = CallConfig(delayInSeconds: 5, callerName: 'Mama');

  void start(FakeAsync async, CallConfig config) {
    repository.listenToCallEvents().then(
      (result) => result.fold((_) {}, (s) => s.listen(events.add)),
    );
    repository.scheduleCall(config);
    async.flushMicrotasks();
  }

  List<CallEventType> types() => events.map((e) => e.type).toList();

  setUp(() {
    dataSource = _FakeNativeDataSource();
    alarm = _FakeAlarm();
    notifier = _FakeMissedCallNotifier();
    vibration = _FakeRingVibration();
    repository = FakeCallRepositoryImpl(
      dataSource: dataSource,
      alarm: alarm,
      missedCallNotifier: notifier,
      ringVibration: vibration,
      uuid: const Uuid(),
    );
    events = [];
  });

  test('berdering setelah delay', () {
    fakeAsync((async) {
      start(async, config);
      async.elapse(const Duration(seconds: 4));
      expect(dataSource.shown, isEmpty);

      async.elapse(const Duration(seconds: 1));
      expect(dataSource.shown, hasLength(1));
      expect(types(), [CallEventType.incoming]);
    });
  });

  test('panggil ulang setelah ditolak sampai jatah habis', () {
    fakeAsync((async) {
      start(async, config.copyWith(autoRecallCount: 2, autoRecallInterval: 10));
      async.elapse(const Duration(seconds: 5));

      dataSource.send(CallEventType.declined);

      async.flushMicrotasks();
      expect(events.last.type, CallEventType.recallScheduled);
      expect(events.last.attempt, 2);

      async.elapse(const Duration(seconds: 9));
      expect(dataSource.shown, hasLength(1));
      async.elapse(const Duration(seconds: 1));
      expect(dataSource.shown, hasLength(2));

      dataSource.send(CallEventType.timeout);

      async.flushMicrotasks();
      async.elapse(const Duration(seconds: 10));
      expect(dataSource.shown, hasLength(3));

      dataSource.send(CallEventType.declined);

      async.flushMicrotasks();
      async.elapse(const Duration(seconds: 60));
      expect(dataSource.shown, hasLength(3));
      expect(events.last, isA<CallEvent>());
      expect(events.last.type, CallEventType.declined);
      expect(events.last.attempt, 3);
    });
  });

  test('menutup otomatis setelah diangkat', () {
    fakeAsync((async) {
      start(async, config.copyWith(autoHangupSeconds: 20));
      async.elapse(const Duration(seconds: 5));
      dataSource.send(CallEventType.accepted);
      async.flushMicrotasks();

      async.elapse(const Duration(seconds: 19));
      expect(dataSource.ended, isEmpty);
      async.elapse(const Duration(seconds: 1));
      async.flushMicrotasks();

      expect(dataSource.ended, [dataSource.lastCallId]);
      expect(types(), [
        CallEventType.incoming,
        CallEventType.accepted,
        CallEventType.ended,
      ]);
    });
  });

  test('tidak memanggil ulang panggilan yang sudah diangkat', () {
    fakeAsync((async) {
      start(async, config.copyWith(autoRecallCount: 3));
      async.elapse(const Duration(seconds: 5));
      dataSource.send(CallEventType.accepted);
      async.flushMicrotasks();
      dataSource.send(CallEventType.ended);
      async.flushMicrotasks();

      async.elapse(const Duration(minutes: 5));
      expect(dataSource.shown, hasLength(1));
      expect(types().last, CallEventType.ended);
    });
  });

  test('membatalkan sebelum berdering', () {
    fakeAsync((async) {
      start(async, config);
      repository.endCall();
      async.flushMicrotasks();
      async.elapse(const Duration(minutes: 1));

      expect(dataSource.shown, isEmpty);
      expect(types(), [CallEventType.cancelled]);
    });
  });

  test('mengabaikan event dari panggilan lain', () {
    fakeAsync((async) {
      start(async, config);
      async.elapse(const Duration(seconds: 5));
      dataSource.native.add(
        const CallEventModel(callId: 'lain', type: CallEventType.accepted),
      );
      async.flushMicrotasks();

      expect(types(), [CallEventType.incoming]);
    });
  });

  test('timeout yang datang setelah diangkat diabaikan', () {
    fakeAsync((async) {
      start(async, config.copyWith(autoRecallCount: 2));
      async.elapse(const Duration(seconds: 5));
      dataSource.send(CallEventType.accepted);
      async.flushMicrotasks();
      dataSource.send(CallEventType.timeout);
      async.flushMicrotasks();
      dataSource.send(CallEventType.declined);
      async.flushMicrotasks();

      async.elapse(const Duration(minutes: 1));
      expect(types(), [CallEventType.incoming, CallEventType.accepted]);
      expect(dataSource.shown, hasLength(1));
    });
  });

  test('sync menandai panggilan yang event accept-nya terlewat', () {
    fakeAsync((async) {
      start(async, config);
      async.elapse(const Duration(seconds: 5));
      dataSource.acceptedCall = CallEventModel(
        callId: dataSource.lastCallId,
        type: CallEventType.accepted,
      );

      repository.syncActiveCall();
      async.flushMicrotasks();

      expect(types(), [CallEventType.incoming, CallEventType.accepted]);
      expect(events.last.config?.props, config.props);
    });
  });

  test('sync memulihkan sesi dari data native saat sesi kosong', () {
    fakeAsync((async) {
      repository.listenToCallEvents().then(
        (result) => result.fold((_) {}, (s) => s.listen(events.add)),
      );
      dataSource.acceptedCall = CallEventModel(
        callId: 'dari-native',
        type: CallEventType.accepted,
        attempt: 2,
        config: CallConfigModel.fromEntity(
          config.copyWith(callerName: 'Pak Bos', autoHangupSeconds: 10),
        ),
      );

      repository.syncActiveCall();
      async.flushMicrotasks();
      expect(events.single.type, CallEventType.accepted);
      expect(events.single.attempt, 2);
      expect(events.single.config?.callerName, 'Pak Bos');

      async.elapse(const Duration(seconds: 10));
      async.flushMicrotasks();
      expect(dataSource.ended, ['dari-native']);
    });
  });

  test('tidak diangkat memunculkan notifikasi tak terjawab', () {
    fakeAsync((async) {
      start(async, config);
      async.elapse(const Duration(seconds: 5));
      dataSource.send(CallEventType.timeout);
      async.flushMicrotasks();

      expect(notifier.shown, [('Mama', 1)]);
    });
  });

  test('beberapa percobaan tak terjawab digabung jadi satu notifikasi', () {
    fakeAsync((async) {
      start(async, config.copyWith(autoRecallCount: 2, autoRecallInterval: 5));
      async.elapse(const Duration(seconds: 5));
      for (var i = 0; i < 3; i++) {
        dataSource.send(CallEventType.timeout);
        async.flushMicrotasks();
        async.elapse(const Duration(seconds: 5));
      }

      expect(notifier.shown, [('Mama', 3)]);
    });
  });

  test('ditolak tidak memunculkan notifikasi', () {
    fakeAsync((async) {
      start(async, config);
      async.elapse(const Duration(seconds: 5));
      dataSource.send(CallEventType.declined);
      async.flushMicrotasks();

      expect(notifier.shown, isEmpty);
    });
  });

  test('diangkat tidak memunculkan notifikasi', () {
    fakeAsync((async) {
      start(async, config.copyWith(autoHangupSeconds: 10));
      async.elapse(const Duration(seconds: 5));
      dataSource.send(CallEventType.accepted);
      async.flushMicrotasks();
      async.elapse(const Duration(seconds: 10));
      async.flushMicrotasks();

      expect(notifier.shown, isEmpty);
    });
  });

  test('getar mulai saat berdering dan berhenti saat diangkat', () {
    fakeAsync((async) {
      start(async, config);
      async.elapse(const Duration(seconds: 5));
      expect(vibration.isOn, isTrue);

      dataSource.send(CallEventType.accepted);
      async.flushMicrotasks();
      expect(vibration.isOn, isFalse);
    });
  });

  test('getar berhenti saat tidak diangkat', () {
    fakeAsync((async) {
      start(async, config.copyWith(autoRecallCount: 1, autoRecallInterval: 5));
      async.elapse(const Duration(seconds: 5));
      dataSource.send(CallEventType.timeout);
      async.flushMicrotasks();
      expect(vibration.isOn, isFalse);

      async.elapse(const Duration(seconds: 5));
      expect(vibration.isOn, isTrue);
    });
  });

  test('getar berhenti saat dibatalkan dari aplikasi', () {
    fakeAsync((async) {
      start(async, config);
      async.elapse(const Duration(seconds: 5));
      repository.endCall();
      async.flushMicrotasks();

      expect(vibration.isOn, isFalse);
    });
  });

  ScheduledCallModel scheduledAt(DateTime now, {String id = 'alarm-1'}) {
    return ScheduledCallModel(
      id: id,
      callConfig: CallConfigModel.fromEntity(config),
      scheduledAt: now,
      ringsAt: now.add(const Duration(seconds: 30)),
    );
  }

  group('alarm native', () {
    test('menjadwalkan alarm sesuai waktu dering', () {
      fakeAsync((async) {
        start(async, config);

        final scheduled = alarm.scheduled!;
        expect(
          scheduled.ringsAt.difference(scheduled.scheduledAt),
          const Duration(seconds: 5),
        );
        expect(scheduled.config.callerName, 'Mama');
      });
    });

    test('jam tertentu dipakai sebagai waktu dering', () {
      fakeAsync((async) {
        withClock(Clock.fixed(DateTime(2026, 10, 14, 9, 0)), () {
          start(async, config.copyWith(ringAt: const ClockTime(9, 30)));
        });

        expect(alarm.scheduled!.ringsAt, DateTime(2026, 10, 14, 9, 30));
      });
    });

    test('timer dalam app membatalkan alarm agar tidak dobel', () {
      fakeAsync((async) {
        start(async, config);
        final id = alarm.scheduled!.id;
        async.elapse(const Duration(seconds: 5));

        expect(dataSource.shown, hasLength(1));
        expect(alarm.cancelled, [id]);

        alarm.firedController.add(scheduledAt(clock.now(), id: id));
        async.flushMicrotasks();
        expect(dataSource.shown, hasLength(1));
      });
    });

    test('alarm yang datang duluan langsung membunyikan panggilan', () {
      fakeAsync((async) {
        start(async, config);
        final scheduled = alarm.scheduled!;
        async.elapse(const Duration(seconds: 2));

        alarm.firedController.add(scheduled);
        async.flushMicrotasks();
        expect(dataSource.shown, hasLength(1));

        async.elapse(const Duration(seconds: 10));
        expect(dataSource.shown, hasLength(1));
      });
    });

    test('membatalkan sebelum berdering ikut membatalkan alarm', () {
      fakeAsync((async) {
        start(async, config);
        final id = alarm.scheduled!.id;
        repository.endCall();
        async.flushMicrotasks();

        expect(alarm.cancelled, [id]);
      });
    });

    test('jadwal tertunda dipulihkan saat app dibuka lagi', () {
      fakeAsync((async) {
        alarm.scheduled = scheduledAt(clock.now());
        late PendingCall? restored;
        repository.restorePendingCall().then(
          (result) => restored = result.fold((_) => null, (p) => p),
        );
        async.flushMicrotasks();

        expect(restored?.ringsAt, alarm.scheduled!.ringsAt);
        async.elapse(const Duration(seconds: 29));
        expect(dataSource.shown, isEmpty);
        async.elapse(const Duration(seconds: 1));
        expect(dataSource.shown, hasLength(1));
      });
    });

    test('jadwal yang sudah lewat tidak dipulihkan', () {
      fakeAsync((async) {
        alarm.scheduled = scheduledAt(
          clock.now().subtract(const Duration(minutes: 1)),
        );
        late PendingCall? restored;
        repository.restorePendingCall().then(
          (result) => restored = result.fold((_) => null, (p) => p),
        );
        async.flushMicrotasks();

        expect(restored, isNull);
      });
    });

    test('alarm dari widget saat app terbuka tetap berdering', () {
      fakeAsync((async) {
        repository.listenToCallEvents().then(
          (result) => result.fold((_) {}, (s) => s.listen(events.add)),
        );
        async.flushMicrotasks();

        alarm.firedController.add(scheduledAt(clock.now(), id: 'widget'));
        async.flushMicrotasks();

        expect(dataSource.shown, hasLength(1));
        expect(events.single.type, CallEventType.incoming);
        expect(events.single.config?.callerName, 'Mama');
      });
    });

    test('engine background membunyikan panggilan yang jatuh tempo', () {
      fakeAsync((async) {
        alarm.due = scheduledAt(clock.now());
        bool? rang;
        repository.ringDueCall().then(
          (result) => rang = result.fold((_) => null, (r) => r),
        );
        async.flushMicrotasks();

        expect(rang, isTrue);
        expect(dataSource.shown, hasLength(1));
      });
    });

    test('tanpa panggilan jatuh tempo tidak ada yang berdering', () async {
      final result = await repository.ringDueCall();

      expect(result, const Right<Object, bool>(false));
      expect(dataSource.shown, isEmpty);
    });
  });

  test('izin ditolak menjadi PermissionFailure', () async {
    dataSource.denyPermission = true;

    final result = await repository.scheduleCall(config);

    expect(result.isLeft(), isTrue);
    expect(result, isNot(const Right<Object, Unit>(unit)));
  });
}
