import 'package:dartz/dartz.dart';
import 'package:fake_calling/core/error/failures.dart';
import 'package:fake_calling/core/l10n/app_locale_holder.dart';
import 'package:fake_calling/core/l10n/failure_messages.dart';
import 'package:fake_calling/core/theme/app_theme.dart';
import 'package:fake_calling/features/permissions/domain/entities/app_permission.dart';
import 'package:fake_calling/features/permissions/domain/repositories/permission_repository.dart';
import 'package:fake_calling/features/permissions/domain/usecases/check_permissions.dart';
import 'package:fake_calling/features/permissions/domain/usecases/request_permission.dart';
import 'package:fake_calling/features/permissions/presentation/bloc/permissions_bloc.dart';
import 'package:fake_calling/features/settings/domain/entities/app_info.dart';
import 'package:fake_calling/features/settings/domain/entities/app_language.dart';
import 'package:fake_calling/features/settings/domain/entities/app_theme_mode.dart';
import 'package:fake_calling/features/settings/domain/repositories/app_info_repository.dart';
import 'package:fake_calling/features/settings/domain/repositories/language_repository.dart';
import 'package:fake_calling/features/settings/domain/repositories/theme_mode_repository.dart';
import 'package:fake_calling/features/settings/domain/usecases/get_app_info.dart';
import 'package:fake_calling/features/settings/domain/usecases/get_app_language.dart';
import 'package:fake_calling/features/settings/domain/usecases/get_theme_mode.dart';
import 'package:fake_calling/features/settings/domain/usecases/save_app_language.dart';
import 'package:fake_calling/features/settings/domain/usecases/save_theme_mode.dart';
import 'package:fake_calling/features/settings/presentation/bloc/app_info_bloc.dart';
import 'package:fake_calling/features/settings/presentation/bloc/language_bloc.dart';
import 'package:fake_calling/features/settings/presentation/bloc/theme_mode_bloc.dart';
import 'package:fake_calling/features/settings/presentation/pages/settings_page.dart';
import 'package:fake_calling/injection_container.dart';
import 'package:fake_calling/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class _Settings
    implements LanguageRepository, ThemeModeRepository, AppInfoRepository {
  AppLanguage language = AppLanguage.indonesian;
  AppThemeMode theme = AppThemeMode.system;

  @override
  Future<Either<Failure, AppLanguage>> getLanguage() async => Right(language);

  @override
  Future<Either<Failure, Unit>> saveLanguage(AppLanguage value) async {
    language = value;
    return const Right(unit);
  }

  @override
  Future<Either<Failure, AppThemeMode>> getThemeMode() async => Right(theme);

  @override
  Future<Either<Failure, Unit>> saveThemeMode(AppThemeMode value) async {
    theme = value;
    return const Right(unit);
  }

  @override
  Future<Either<Failure, AppInfo>> getAppInfo() async =>
      const Right(AppInfo(version: '1.2.3', buildNumber: '7'));
}

class _Permissions implements PermissionRepository {
  final granted = <AppPermission, bool>{AppPermission.notification: true};

  PermissionSnapshot get _snapshot => PermissionSnapshot({...granted});

  @override
  Future<Either<Failure, PermissionSnapshot>> check() async => Right(_snapshot);

  @override
  Future<Either<Failure, PermissionSnapshot>> request(
    AppPermission permission,
  ) async {
    granted[permission] = true;
    return Right(_snapshot);
  }
}

void main() {
  final repo = _Settings();
  final permissions = _Permissions();
  final messages = FailureMessages(AppLocaleHolder(const Locale('id')));

  setUpAll(() {
    sl.registerFactory(
      () =>
          AppInfoBloc(getAppInfo: GetAppInfo(repo), failureMessages: messages),
    );
    sl.registerFactory(
      () => PermissionsBloc(
        checkPermissions: CheckPermissions(permissions),
        requestPermission: RequestPermission(permissions),
        failureMessages: messages,
      ),
    );
  });

  tearDownAll(sl.reset);

  Widget host() => MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (_) => ThemeModeBloc(
          getThemeMode: GetThemeMode(repo),
          saveThemeMode: SaveThemeMode(repo),
          failureMessages: messages,
        )..add(const ThemeModeStarted()),
      ),
      BlocProvider(
        create: (_) => LanguageBloc(
          getAppLanguage: GetAppLanguage(repo),
          saveAppLanguage: SaveAppLanguage(repo),
          failureMessages: messages,
        )..add(const LanguageStarted()),
      ),
    ],
    child: BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, state) => MaterialApp(
        theme: AppTheme.light,
        locale: state.locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const SettingsPage(),
      ),
    ),
  );

  testWidgets('menampilkan versi aplikasi', (tester) async {
    await tester.pumpWidget(host());
    await tester.pumpAndSettle();

    final l10n = lookupAppLocalizations(const Locale('id'));
    expect(find.text(l10n.aboutVersion('1.2.3 (7)')), findsOneWidget);
  });

  testWidgets('memilih tema gelap menyimpan pilihan', (tester) async {
    repo.theme = AppThemeMode.system;
    await tester.pumpWidget(host());
    await tester.pumpAndSettle();

    final l10n = lookupAppLocalizations(const Locale('id'));
    await tester.tap(find.text(l10n.settingsTheme));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.themeDark));
    await tester.pumpAndSettle();

    expect(repo.theme, AppThemeMode.dark);
    expect(find.text(l10n.themeDark), findsOneWidget);
  });

  testWidgets('memilih bahasa Inggris langsung mengubah teks', (tester) async {
    repo.language = AppLanguage.indonesian;
    await tester.pumpWidget(host());
    await tester.pumpAndSettle();

    final id = lookupAppLocalizations(const Locale('id'));
    final en = lookupAppLocalizations(const Locale('en'));
    expect(find.text(id.settingsTitle), findsOneWidget);

    await tester.tap(find.text(id.settingsLanguage));
    await tester.pumpAndSettle();
    await tester.tap(find.text(id.languageEnglish).last);
    await tester.pumpAndSettle();

    expect(repo.language, AppLanguage.english);
    expect(find.text(en.settingsTitle), findsOneWidget);
  });

  testWidgets('izin aplikasi tampil di bottom sheet dan bisa diizinkan', (
    tester,
  ) async {
    repo.language = AppLanguage.indonesian;
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(host());
    await tester.pumpAndSettle();

    final l10n = lookupAppLocalizations(const Locale('id'));
    await tester.tap(find.text(l10n.settingsPermissions));
    await tester.pumpAndSettle();

    expect(find.text(l10n.settingsPermissionsBody), findsOneWidget);
    expect(find.text(l10n.permissionExactAlarmTitle), findsOneWidget);
    expect(
      find.text(l10n.permissionAllow),
      findsNWidgets(AppPermission.values.length - 1),
    );

    await tester.tap(find.text(l10n.permissionAllow).first);
    await tester.pumpAndSettle();
    expect(permissions.granted[AppPermission.fullScreen], isTrue);
    expect(
      find.text(l10n.permissionAllow),
      findsNWidgets(AppPermission.values.length - 2),
    );
  });
}
