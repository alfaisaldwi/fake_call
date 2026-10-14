import 'package:dartz/dartz.dart';
import 'package:fake_call/core/error/failures.dart';
import 'package:fake_call/core/l10n/app_locale_holder.dart';
import 'package:fake_call/core/l10n/failure_messages.dart';
import 'package:fake_call/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:fake_call/features/permissions/domain/entities/app_permission.dart';
import 'package:fake_call/features/permissions/domain/repositories/permission_repository.dart';
import 'package:fake_call/features/permissions/domain/usecases/check_permissions.dart';
import 'package:fake_call/features/permissions/domain/usecases/request_permission.dart';
import 'package:fake_call/features/permissions/presentation/bloc/permissions_bloc.dart';
import 'package:fake_call/injection_container.dart';
import 'package:fake_call/features/onboarding/domain/usecases/check_onboarding_completed.dart';
import 'package:fake_call/features/onboarding/domain/usecases/complete_onboarding.dart';
import 'package:fake_call/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:fake_call/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:fake_call/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeOnboardingRepository implements OnboardingRepository {
  bool completed = false;

  @override
  Future<Either<Failure, bool>> isCompleted() async => Right(completed);

  @override
  Future<Either<Failure, Unit>> markCompleted() async {
    completed = true;
    return const Right(unit);
  }
}

class _FakePermissionRepository implements PermissionRepository {
  final granted = <AppPermission, bool>{};

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
  final permissions = _FakePermissionRepository();
  final messages = FailureMessages(AppLocaleHolder(const Locale('id')));

  setUpAll(() {
    sl.registerFactory(
      () => PermissionsBloc(
        checkPermissions: CheckPermissions(permissions),
        requestPermission: RequestPermission(permissions),
        failureMessages: messages,
      ),
    );
  });

  tearDownAll(sl.reset);

  late _FakeOnboardingRepository repository;

  OnboardingBloc buildBloc() => OnboardingBloc(
    checkOnboardingCompleted: CheckOnboardingCompleted(repository),
    completeOnboarding: CompleteOnboarding(repository),
    failureMessages: FailureMessages(AppLocaleHolder(const Locale('id'))),
  );

  Future<void> settle() => Future<void>.delayed(Duration.zero);

  setUp(() => repository = _FakeOnboardingRepository());

  test('pengguna baru perlu onboarding', () async {
    final bloc = buildBloc()..add(const OnboardingStatusRequested());
    await settle();

    expect(bloc.state, const OnboardingRequired());
    await bloc.close();
  });

  test('onboarding tidak muncul lagi setelah selesai', () async {
    final bloc = buildBloc()..add(const OnboardingFinished());
    await settle();
    expect(repository.completed, isTrue);
    await bloc.close();

    final next = buildBloc()..add(const OnboardingStatusRequested());
    await settle();
    expect(next.state, const OnboardingDone());
    await next.close();
  });

  testWidgets('halaman izin di akhir onboarding bisa diizinkan satu per satu', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final l10n = lookupAppLocalizations(const Locale('id'));
    final bloc = buildBloc();
    await tester.pumpWidget(
      BlocProvider.value(
        value: bloc,
        child: const MaterialApp(
          locale: Locale('id'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: OnboardingPage(),
        ),
      ),
    );
    await tester.pump();
    expect(find.text(l10n.onboarding1Title), findsOneWidget);
    expect(find.text(l10n.onboardingNext), findsOneWidget);

    for (var i = 0; i < 3; i++) {
      await tester.tap(find.text(l10n.onboardingNext));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));
    }

    expect(find.text(l10n.onboarding4Title), findsOneWidget);
    expect(find.text(l10n.onboardingStart), findsOneWidget);

    await tester.tap(find.text(l10n.permissionAllow).first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(
      find.text(l10n.permissionAllow),
      findsNWidgets(AppPermission.values.length - 1),
    );
    expect(permissions.granted[AppPermission.notification], isTrue);
    await tester.runAsync(bloc.close);
  });
}
