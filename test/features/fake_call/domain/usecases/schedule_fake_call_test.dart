import 'package:dartz/dartz.dart';
import 'package:fake_whatsapp_call/core/error/failures.dart';
import 'package:fake_whatsapp_call/features/fake_call/domain/entities/call_config.dart';
import 'package:fake_whatsapp_call/features/fake_call/domain/entities/call_config_issue.dart';
import 'package:fake_whatsapp_call/features/fake_call/domain/entities/call_event.dart';
import 'package:fake_whatsapp_call/features/fake_call/domain/repositories/fake_call_repository.dart';
import 'package:fake_whatsapp_call/features/fake_call/domain/usecases/schedule_fake_call.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeRepository implements FakeCallRepository {
  CallConfig? scheduled;
  Either<Failure, Unit> result = const Right(unit);

  @override
  Future<Either<Failure, Unit>> scheduleCall(CallConfig config) async {
    scheduled = config;
    return result;
  }

  @override
  Future<Either<Failure, Stream<CallEvent>>> listenToCallEvents() async =>
      const Right(Stream.empty());

  @override
  Future<Either<Failure, Unit>> endCall() async => const Right(unit);

  @override
  Future<Either<Failure, Unit>> syncActiveCall() async => const Right(unit);
}

void main() {
  late _FakeRepository repository;
  late ScheduleFakeCall usecase;

  const config = CallConfig(delayInSeconds: 10, callerName: 'Mama');

  setUp(() {
    repository = _FakeRepository();
    usecase = ScheduleFakeCall(repository);
  });

  test('meneruskan config valid ke repository', () async {
    final result = await usecase(config);

    expect(result, const Right(unit));
    expect(repository.scheduled, config);
  });

  test('menolak delay negatif tanpa memanggil repository', () async {
    final result = await usecase(
      const CallConfig(delayInSeconds: -1, callerName: 'Mama'),
    );

    expect(result.isLeft(), isTrue);
    expect(repository.scheduled, isNull);
  });

  test('menolak nama penelepon kosong', () async {
    final result = await usecase(
      const CallConfig(delayInSeconds: 5, callerName: '  '),
    );

    expect(
      result,
      Left(
        InvalidCallConfigFailure(
          const CallConfigIssue(
            CallConfigField.callerName,
            FailureReason.callerNameRequired,
          ),
        ),
      ),
    );
  });

  test('menolak jeda panggil ulang yang terlalu pendek', () async {
    final result = await usecase(
      config.copyWith(autoRecallCount: 2, autoRecallInterval: 1),
    );

    expect(result.isLeft(), isTrue);
    expect(repository.scheduled, isNull);
  });

  test('meneruskan failure dari repository', () async {
    repository.result = const Left(
      PermissionFailure(FailureReason.permissionRequestFailed),
    );

    final result = await usecase(config);

    expect(
      result,
      const Left(PermissionFailure(FailureReason.permissionRequestFailed)),
    );
  });
}
