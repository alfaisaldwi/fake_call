import 'package:dartz/dartz.dart';
import 'package:fake_whatsapp_call/core/error/failures.dart';
import 'package:fake_whatsapp_call/core/l10n/app_locale_holder.dart';
import 'package:fake_whatsapp_call/core/l10n/failure_messages.dart';
import 'package:fake_whatsapp_call/features/settings/domain/entities/app_language.dart';
import 'package:fake_whatsapp_call/features/settings/domain/repositories/language_repository.dart';
import 'package:fake_whatsapp_call/features/settings/domain/usecases/get_app_language.dart';
import 'package:fake_whatsapp_call/features/settings/domain/usecases/save_app_language.dart';
import 'package:fake_whatsapp_call/features/settings/presentation/bloc/language_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeLanguageRepository implements LanguageRepository {
  AppLanguage stored = AppLanguage.system;
  bool failSave = false;

  @override
  Future<Either<Failure, AppLanguage>> getLanguage() async => Right(stored);

  @override
  Future<Either<Failure, Unit>> saveLanguage(AppLanguage language) async {
    if (failSave) return const Left(CacheFailure(FailureReason.settingsFailed));
    stored = language;
    return const Right(unit);
  }
}

void main() {
  late _FakeLanguageRepository repository;

  LanguageBloc buildBloc() => LanguageBloc(
    getAppLanguage: GetAppLanguage(repository),
    saveAppLanguage: SaveAppLanguage(repository),
    failureMessages: FailureMessages(AppLocaleHolder(const Locale('id'))),
  );

  Future<void> settle() => Future<void>.delayed(Duration.zero);

  setUp(() => repository = _FakeLanguageRepository());

  test('default mengikuti bahasa HP', () async {
    final bloc = buildBloc()..add(const LanguageStarted());
    await settle();

    expect(bloc.state.language, AppLanguage.system);
    expect(bloc.state.locale, isNull);
    await bloc.close();
  });

  test('pilihan tersimpan dimuat saat start', () async {
    repository.stored = AppLanguage.english;
    final bloc = buildBloc()..add(const LanguageStarted());
    await settle();

    expect(bloc.state.locale, const Locale('en'));
    await bloc.close();
  });

  test('memilih bahasa menyimpannya', () async {
    final bloc = buildBloc()
      ..add(const LanguageSelected(AppLanguage.indonesian));
    await settle();

    expect(repository.stored, AppLanguage.indonesian);
    expect(bloc.state, const LanguageReady(AppLanguage.indonesian));
    await bloc.close();
  });

  test('gagal menyimpan kembali ke bahasa sebelumnya', () async {
    repository.failSave = true;
    final bloc = buildBloc()..add(const LanguageSelected(AppLanguage.english));
    await settle();

    final state = bloc.state as LanguageError;
    expect(state.language, AppLanguage.system);
    expect(state.message, 'Pengaturan gagal disimpan.');
    await bloc.close();
  });

  test('bahasa HP yang tidak didukung jatuh ke Inggris', () {
    expect(AppLocaleHolder.resolve(const Locale('ja')), const Locale('en'));
    expect(
      AppLocaleHolder.resolve(const Locale('id', 'ID')),
      const Locale('id'),
    );
  });
}
