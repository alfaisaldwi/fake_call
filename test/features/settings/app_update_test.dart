import 'package:dartz/dartz.dart';
import 'package:fake_calling/core/error/failures.dart';
import 'package:fake_calling/core/l10n/app_locale_holder.dart';
import 'package:fake_calling/core/l10n/failure_messages.dart';
import 'package:fake_calling/features/settings/domain/entities/app_update.dart';
import 'package:fake_calling/features/settings/domain/repositories/app_update_repository.dart';
import 'package:fake_calling/features/settings/domain/usecases/check_app_update.dart';
import 'package:fake_calling/features/settings/domain/usecases/start_app_update.dart';
import 'package:fake_calling/features/settings/presentation/bloc/app_update_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeAppUpdateRepository implements AppUpdateRepository {
  Either<Failure, AppUpdateAvailability> checkResult = const Right(
    AppUpdateAvailability.upToDate,
  );
  Either<Failure, bool> startResult = const Right(true);
  int started = 0;

  @override
  Future<Either<Failure, AppUpdateAvailability>> checkForUpdate() async =>
      checkResult;

  @override
  Future<Either<Failure, bool>> startUpdate() async {
    started++;
    return startResult;
  }
}

void main() {
  late FakeAppUpdateRepository repository;
  final messages = FailureMessages(AppLocaleHolder(const Locale('id')));

  AppUpdateBloc buildBloc() => AppUpdateBloc(
    checkAppUpdate: CheckAppUpdate(repository),
    startAppUpdate: StartAppUpdate(repository),
    failureMessages: messages,
  );

  Future<void> settle() => Future<void>.delayed(Duration.zero);

  setUp(() => repository = FakeAppUpdateRepository());

  test('cek diam-diam menandai versi baru tanpa pesan', () async {
    repository.checkResult = const Right(AppUpdateAvailability.available);
    final bloc = buildBloc()..add(const AppUpdateCheckRequested(silent: true));
    await settle();

    expect(bloc.state.isAvailable, isTrue);
    expect(bloc.state.message, isNull);
    expect(bloc.state.isUpToDateNotice, isFalse);
    await bloc.close();
  });

  test('cek manual memberi tahu kalau sudah versi terbaru', () async {
    final bloc = buildBloc()..add(const AppUpdateCheckRequested());
    await settle();

    expect(bloc.state.isUpToDateNotice, isTrue);
    await bloc.close();
  });

  test('gagal cek diam-diam tidak memunculkan pesan', () async {
    repository.checkResult = const Left(
      UpdateFailure(FailureReason.updateCheckFailed),
    );
    final bloc = buildBloc()..add(const AppUpdateCheckRequested(silent: true));
    await settle();
    expect(bloc.state.message, isNull);

    bloc.add(const AppUpdateCheckRequested());
    await settle();
    expect(bloc.state.message, isNotNull);
    await bloc.close();
  });

  test('memulai update meneruskan ke repository', () async {
    final bloc = buildBloc()..add(const AppUpdateStartRequested());
    await settle();

    expect(repository.started, 1);
    expect(bloc.state.isBusy, isFalse);
    await bloc.close();
  });
}
