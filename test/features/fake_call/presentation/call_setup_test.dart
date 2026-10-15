import 'package:clock/clock.dart';
import 'package:dartz/dartz.dart';
import 'package:fake_calling/core/error/failures.dart';
import 'package:fake_calling/features/fake_call/domain/entities/call_config.dart';
import 'package:fake_calling/features/fake_call/domain/entities/call_config_issue.dart';
import 'package:fake_calling/features/fake_call/domain/entities/call_event.dart';
import 'package:fake_calling/features/fake_call/domain/entities/clock_time.dart';
import 'package:fake_calling/features/fake_call/domain/entities/pending_call.dart';
import 'package:fake_calling/features/fake_call/domain/usecases/restore_pending_call.dart';
import 'package:fake_calling/features/fake_call/domain/repositories/caller_avatar_repository.dart';
import 'package:fake_calling/features/fake_call/domain/repositories/fake_call_repository.dart';
import 'package:fake_calling/features/fake_call/domain/usecases/end_fake_call.dart';
import 'package:fake_calling/features/fake_call/domain/usecases/listen_to_call_events.dart';
import 'package:fake_calling/features/fake_call/domain/usecases/pick_caller_avatar.dart';
import 'package:fake_calling/features/fake_call/domain/usecases/schedule_fake_call.dart';
import 'package:fake_calling/features/fake_call/domain/usecases/sync_active_call.dart';
import 'package:fake_calling/features/fake_call/presentation/bloc/fake_call_bloc.dart';
import 'package:fake_calling/features/fake_call/presentation/pages/call_setup_page.dart';
import 'package:fake_calling/core/l10n/app_locale_holder.dart';
import 'package:fake_calling/core/l10n/failure_messages.dart';
import 'package:fake_calling/features/settings/domain/entities/app_language.dart';
import 'package:fake_calling/features/settings/domain/repositories/language_repository.dart';
import 'package:fake_calling/features/settings/domain/usecases/get_app_language.dart';
import 'package:fake_calling/features/settings/domain/usecases/save_app_language.dart';
import 'package:fake_calling/features/settings/presentation/bloc/language_bloc.dart';
import 'package:fake_calling/l10n/app_localizations.dart';
import 'package:fake_calling/features/fake_call/domain/entities/caller_name_history.dart';
import 'package:fake_calling/features/fake_call/domain/repositories/caller_name_history_repository.dart';
import 'package:fake_calling/features/fake_call/domain/usecases/forget_caller_name.dart';
import 'package:fake_calling/features/fake_call/domain/usecases/get_caller_name_history.dart';
import 'package:fake_calling/features/fake_call/domain/usecases/remember_caller_name.dart';
import 'package:fake_calling/features/fake_call/presentation/bloc/caller_suggestions_bloc.dart';
import 'package:fake_calling/features/fake_call/domain/repositories/caller_video_repository.dart';
import 'package:fake_calling/features/fake_call/domain/usecases/pick_caller_video.dart';
import 'package:fake_calling/features/fake_call/domain/entities/caller_preset.dart';
import 'package:fake_calling/features/fake_call/domain/repositories/caller_preset_repository.dart';
import 'package:fake_calling/features/fake_call/domain/usecases/delete_caller_preset.dart';
import 'package:fake_calling/features/fake_call/domain/usecases/get_caller_presets.dart';
import 'package:fake_calling/features/fake_call/domain/usecases/save_caller_preset.dart';
import 'package:fake_calling/features/fake_call/presentation/bloc/caller_presets_bloc.dart';

import 'dart:async';

import 'package:fake_calling/features/fake_call/domain/repositories/last_call_config_repository.dart';
import 'package:fake_calling/features/fake_call/domain/repositories/quick_trigger_repository.dart';
import 'package:fake_calling/features/fake_call/domain/usecases/get_last_call_config.dart';
import 'package:fake_calling/features/fake_call/domain/usecases/listen_to_quick_triggers.dart';
import 'package:fake_calling/features/fake_call/domain/usecases/save_last_call_config.dart';
import 'package:fake_calling/features/settings/domain/entities/app_theme_mode.dart';
import 'package:fake_calling/features/settings/domain/repositories/theme_mode_repository.dart';
import 'package:fake_calling/features/settings/domain/usecases/get_theme_mode.dart';
import 'package:fake_calling/features/settings/domain/usecases/save_theme_mode.dart';
import 'package:fake_calling/features/settings/presentation/bloc/theme_mode_bloc.dart';
import 'package:fake_calling/features/onboarding/domain/repositories/coach_marks_repository.dart';
import 'package:fake_calling/features/onboarding/domain/usecases/check_coach_marks_seen.dart';
import 'package:fake_calling/features/onboarding/domain/usecases/set_coach_marks_seen.dart';
import 'package:fake_calling/features/onboarding/presentation/bloc/coach_marks_bloc.dart';
import 'package:fake_calling/features/settings/domain/usecases/check_app_update.dart';
import 'package:fake_calling/features/settings/domain/usecases/start_app_update.dart';
import 'package:fake_calling/features/settings/presentation/bloc/app_update_bloc.dart';

import '../../settings/app_update_test.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeCallRepository implements FakeCallRepository {
  CallConfig? scheduled;
  PendingCall? pending;

  @override
  Future<Either<Failure, PendingCall>> scheduleCall(CallConfig config) async {
    scheduled = config;
    final now = clock.now();
    return Right(
      PendingCall(
        config: config,
        scheduledAt: now,
        ringsAt: config.ringsAtFrom(now),
      ),
    );
  }

  @override
  Future<Either<Failure, PendingCall?>> restorePendingCall() async =>
      Right(pending);

  @override
  Future<Either<Failure, bool>> ringDueCall() async => const Right(false);

  @override
  Future<Either<Failure, Unit>> finishDueCall() async => const Right(unit);

  @override
  Future<Either<Failure, Stream<CallEvent>>> listenToCallEvents() async =>
      const Right(Stream.empty());

  @override
  Future<Either<Failure, Unit>> endCall() async => const Right(unit);

  @override
  Future<Either<Failure, Unit>> syncActiveCall() async => const Right(unit);
}

class _FakeVideoRepository implements CallerVideoRepository {
  Either<Failure, String?> result = const Right('/tmp/bos.mp4');

  @override
  Future<Either<Failure, String?>> pickFromGallery() async => result;
}

class _FakeAvatarRepository implements CallerAvatarRepository {
  Either<Failure, String?> result = const Right('/tmp/foto.jpg');

  @override
  Future<Either<Failure, String?>> pickFromGallery() async => result;
}

class _FakeCoachRepository implements CoachMarksRepository {
  bool seen = true;

  @override
  Future<Either<Failure, bool>> isSeen() async => Right(seen);

  @override
  Future<Either<Failure, Unit>> setSeen(bool value) async {
    seen = value;
    return const Right(unit);
  }
}

final _coach = _FakeCoachRepository();

CoachMarksBloc _coachBloc() => CoachMarksBloc(
  checkCoachMarksSeen: CheckCoachMarksSeen(_coach),
  setCoachMarksSeen: SetCoachMarksSeen(_coach),
  failureMessages: _messages,
)..add(const CoachMarksRequested());

class _FakeThemeRepository implements ThemeModeRepository {
  AppThemeMode stored = AppThemeMode.system;

  @override
  Future<Either<Failure, AppThemeMode>> getThemeMode() async => Right(stored);

  @override
  Future<Either<Failure, Unit>> saveThemeMode(AppThemeMode mode) async {
    stored = mode;
    return const Right(unit);
  }
}

final _theme = _FakeThemeRepository();

ThemeModeBloc _themeBloc() => ThemeModeBloc(
  getThemeMode: GetThemeMode(_theme),
  saveThemeMode: SaveThemeMode(_theme),
  failureMessages: _messages,
);

class _FakeLastConfigRepository implements LastCallConfigRepository {
  CallConfig? stored;

  @override
  Future<Either<Failure, CallConfig?>> load() async => Right(stored);

  @override
  Future<Either<Failure, Unit>> save(CallConfig config) async {
    stored = config;
    return const Right(unit);
  }
}

class _FakeQuickTriggerRepository implements QuickTriggerRepository {
  final controller = StreamController<int>.broadcast();

  @override
  Future<Either<Failure, Stream<int>>> listen() async =>
      Right(controller.stream);
}

final _lastConfig = _FakeLastConfigRepository();
final _quickTriggers = _FakeQuickTriggerRepository();

class _FakePresetRepository implements CallerPresetRepository {
  List<CallerPreset> presets = [];

  @override
  Future<Either<Failure, List<CallerPreset>>> getPresets() async =>
      Right(presets);

  @override
  Future<Either<Failure, List<CallerPreset>>> savePreset(
    CallConfig config,
  ) async {
    presets = [
      CallerPreset(
        id: config.callerName,
        name: config.callerName,
        callType: config.callType,
        avatarPath: config.callerAvatarPath,
      ),
      ...presets.where((p) => !p.matches(config)),
    ];
    return Right(presets);
  }

  @override
  Future<Either<Failure, List<CallerPreset>>> deletePreset(String id) async {
    presets = presets.where((p) => p.id != id).toList();
    return Right(presets);
  }
}

final _presets = _FakePresetRepository();

CallerPresetsBloc _presetsBloc() => CallerPresetsBloc(
  getCallerPresets: GetCallerPresets(_presets),
  saveCallerPreset: SaveCallerPreset(_presets),
  deleteCallerPreset: DeleteCallerPreset(_presets),
  failureMessages: _messages,
)..add(const CallerPresetsRequested());

class _FakeHistoryRepository implements CallerNameHistoryRepository {
  CallerNameHistory stored = const CallerNameHistory.empty();

  @override
  Future<Either<Failure, CallerNameHistory>> load() async => Right(stored);

  @override
  Future<Either<Failure, Unit>> save(CallerNameHistory history) async {
    stored = history;
    return const Right(unit);
  }
}

final _history = _FakeHistoryRepository();

CallerSuggestionsBloc _suggestionsBloc() => CallerSuggestionsBloc(
  getCallerNameHistory: GetCallerNameHistory(_history),
  forgetCallerName: ForgetCallerName(_history),
  failureMessages: _messages,
);

class _FakeLanguageRepository implements LanguageRepository {
  @override
  Future<Either<Failure, AppLanguage>> getLanguage() async =>
      const Right(AppLanguage.indonesian);

  @override
  Future<Either<Failure, Unit>> saveLanguage(AppLanguage language) async =>
      const Right(unit);
}

const _locale = Locale('id');
final _l10n = lookupAppLocalizations(_locale);
final _messages = FailureMessages(AppLocaleHolder(_locale));

Widget _host(FakeCallBloc bloc) {
  final languageRepository = _FakeLanguageRepository();
  return MultiBlocProvider(
    providers: [
      BlocProvider.value(value: bloc),
      BlocProvider(create: (_) => _suggestionsBloc()),
      BlocProvider(create: (_) => _presetsBloc()),
      BlocProvider(create: (_) => _coachBloc()),
      BlocProvider(create: (_) => _themeBloc()),
      BlocProvider(
        create: (_) {
          final updates = FakeAppUpdateRepository();
          return AppUpdateBloc(
            checkAppUpdate: CheckAppUpdate(updates),
            startAppUpdate: StartAppUpdate(updates),
            failureMessages: _messages,
          );
        },
      ),
      BlocProvider(
        create: (_) => LanguageBloc(
          getAppLanguage: GetAppLanguage(languageRepository),
          saveAppLanguage: SaveAppLanguage(languageRepository),
          failureMessages: _messages,
        ),
      ),
    ],
    child: const MaterialApp(
      locale: _locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: CallSetupPage(),
    ),
  );
}

void main() {
  late _FakeCallRepository callRepository;
  late _FakeAvatarRepository avatarRepository;
  late _FakeVideoRepository videoRepository;

  FakeCallBloc buildBloc() => FakeCallBloc(
    scheduleFakeCall: ScheduleFakeCall(callRepository),
    listenToCallEvents: ListenToCallEvents(callRepository),
    endFakeCall: EndFakeCall(callRepository),
    pickCallerAvatar: PickCallerAvatar(avatarRepository),
    pickCallerVideo: PickCallerVideo(videoRepository),
    rememberCallerName: RememberCallerName(_history),
    syncActiveCall: SyncActiveCall(callRepository),
    getLastCallConfig: GetLastCallConfig(_lastConfig),
    saveLastCallConfig: SaveLastCallConfig(_lastConfig),
    listenToQuickTriggers: ListenToQuickTriggers(_quickTriggers),
    restorePendingCall: RestorePendingCall(callRepository),
    failureMessages: _messages,
  );

  Future<void> settle() => Future<void>.delayed(Duration.zero);

  setUp(() {
    _history.stored = const CallerNameHistory.empty();
    _presets.presets = [];
    _lastConfig.stored = null;
    _coach.seen = true;
    callRepository = _FakeCallRepository();
    avatarRepository = _FakeAvatarRepository();
    videoRepository = _FakeVideoRepository();
  });

  group('FakeCallBloc form', () {
    test('konfigurasi yang diubah dipakai saat menjadwalkan', () async {
      final bloc = buildBloc();
      final config = bloc.state.config.copyWith(
        callerName: 'Pak Bos',
        callType: CallType.voice,
        autoRecallCount: 2,
      );
      bloc
        ..add(FakeCallConfigChanged(config))
        ..add(const FakeCallScheduleRequested());
      await settle();

      expect(callRepository.scheduled, config);
      expect(bloc.state, isA<FakeCallCountingDown>());
      await bloc.close();
    });

    test('jadwal tertunda dipulihkan jadi hitung mundur', () async {
      final now = DateTime.now();
      callRepository.pending = PendingCall(
        config: const CallConfig(delayInSeconds: 600, callerName: 'Pak Bos'),
        scheduledAt: now.subtract(const Duration(minutes: 4)),
        ringsAt: now.add(const Duration(minutes: 6)),
      );
      final bloc = buildBloc()..add(const FakeCallRestoreRequested());
      await settle();

      final state = bloc.state as FakeCallCountingDown;
      expect(state.config.callerName, 'Pak Bos');
      expect(state.totalSeconds, 600);
      expect(state.remainingSeconds, inInclusiveRange(359, 360));
      await bloc.close();
    });

    test('memilih jeda menghapus jam dering', () async {
      final bloc = buildBloc();
      bloc.add(
        FakeCallConfigChanged(
          bloc.state.config.copyWith(ringAt: const ClockTime(7, 0)),
        ),
      );
      await settle();
      expect(bloc.state.config.ringsAtClockTime, isTrue);

      bloc.add(
        FakeCallConfigChanged(
          bloc.state.config.copyWith(delayInSeconds: 60, clearRingAt: true),
        ),
      );
      await settle();
      expect(bloc.state.config.ringAt, isNull);
      expect(bloc.state.config.delayInSeconds, 60);
      await bloc.close();
    });

    test('nama kosong ditolak dan menandai field nama', () async {
      final bloc = buildBloc()..add(const FakeCallScheduleRequested());
      await settle();

      final state = bloc.state as FakeCallError;
      expect(state.invalidField, CallConfigField.callerName);
      expect(callRepository.scheduled, isNull);
      await bloc.close();
    });

    test('pengaturan terakhir disimpan lalu dipulihkan', () async {
      final bloc = buildBloc();
      final config = bloc.state.config.copyWith(
        callerName: 'Pak Bos',
        autoRecallCount: 2,
      );
      bloc
        ..add(FakeCallConfigChanged(config))
        ..add(const FakeCallScheduleRequested());
      await settle();
      expect(_lastConfig.stored, config);
      await bloc.close();

      final next = buildBloc()..add(const FakeCallRestoreRequested());
      await settle();
      expect(next.state.config, config);
      await next.close();
    });

    test(
      'pemicu cepat menjadwalkan pengaturan terakhir dengan jeda baru',
      () async {
        _lastConfig.stored = const CallConfig(
          delayInSeconds: 300,
          callerName: 'Mama',
          callType: CallType.voice,
        );
        final bloc = buildBloc()..add(const FakeCallQuickTriggersStarted());
        await settle();
        _quickTriggers.controller.add(10);
        await settle();
        await settle();

        expect(callRepository.scheduled?.callerName, 'Mama');
        expect(callRepository.scheduled?.delayInSeconds, 10);
        expect(callRepository.scheduled?.callType, CallType.voice);
        expect(bloc.state, isA<FakeCallCountingDown>());
        await bloc.close();
      },
    );

    test('nama tersimpan ke riwayat setelah dijadwalkan', () async {
      final bloc = buildBloc();
      bloc
        ..add(
          FakeCallConfigChanged(
            bloc.state.config.copyWith(callerName: '  Pak Bos '),
          ),
        )
        ..add(const FakeCallScheduleRequested());
      await settle();

      expect(_history.stored.names, ['Pak Bos']);
      await bloc.close();
    });

    test('preview berdering sebentar lagi tanpa menyimpan apa pun', () async {
      final bloc = buildBloc();
      final config = bloc.state.config.copyWith(
        callerName: 'Pak Bos',
        delayInSeconds: 600,
        autoRecallCount: 3,
        ringAt: const ClockTime(14, 30),
      );
      bloc
        ..add(FakeCallConfigChanged(config))
        ..add(const FakeCallPreviewRequested());
      await settle();

      final scheduled = callRepository.scheduled!;
      expect(scheduled.delayInSeconds, FakeCallBloc.previewDelaySeconds);
      expect(scheduled.ringAt, isNull);
      expect(scheduled.autoRecallCount, 0);
      expect(scheduled.callerName, 'Pak Bos');
      expect(bloc.state, isA<FakeCallCountingDown>());
      expect(_history.stored.names, isEmpty);
      expect(_lastConfig.stored, isNull);

      bloc.add(const FakeCallReset());
      await settle();
      expect(bloc.state, FakeCallIdle(config));
      await bloc.close();
    });

    test('video dari galeri disimpan lalu bisa kembali ke bawaan', () async {
      final bloc = buildBloc()..add(const FakeCallVideoPickRequested());
      await settle();
      expect(bloc.state.config.callerVideoPath, '/tmp/bos.mp4');

      bloc.add(const FakeCallVideoRemoved());
      await settle();
      expect(bloc.state.config.callerVideoPath, isNull);
      await bloc.close();
    });

    test('batal memilih video tidak mengubah konfigurasi', () async {
      videoRepository.result = const Right(null);
      final bloc = buildBloc();
      final before = bloc.state;
      bloc.add(const FakeCallVideoPickRequested());
      await settle();

      expect(bloc.state, before);
      await bloc.close();
    });

    test('foto dari galeri disimpan lalu bisa dihapus', () async {
      final bloc = buildBloc()..add(const FakeCallAvatarPickRequested());
      await settle();
      expect(bloc.state.config.callerAvatarPath, '/tmp/foto.jpg');

      bloc.add(const FakeCallAvatarRemoved());
      await settle();
      expect(bloc.state.config.callerAvatarPath, isNull);
      await bloc.close();
    });

    test('batal memilih foto tidak mengubah konfigurasi', () async {
      avatarRepository.result = const Right(null);
      final bloc = buildBloc();
      final before = bloc.state;
      bloc.add(const FakeCallAvatarPickRequested());
      await settle();

      expect(bloc.state, before);
      await bloc.close();
    });

    test('izin galeri ditolak menjadi state error', () async {
      avatarRepository.result = const Left(
        PermissionFailure(FailureReason.galleryPermissionDenied),
      );
      final bloc = buildBloc()..add(const FakeCallAvatarPickRequested());
      await settle();

      expect(bloc.state, isA<FakeCallError>());
      await bloc.close();
    });
  });

  testWidgets('nama kosong memunculkan dialog dan menyorot field', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2520);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final bloc = buildBloc();
    await tester.pumpWidget(_host(bloc));
    expect(find.text(_l10n.callerNameHint), findsOneWidget);

    await tester.tap(find.text(_l10n.scheduleCall));
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text(_l10n.invalidConfigTitle), findsOneWidget);
    expect(find.text(_l10n.errorCallerNameRequired), findsOneWidget);

    await tester.tap(find.text(_l10n.ok));
    await tester.pump(const Duration(milliseconds: 300));
    await _reveal(tester, find.text(_l10n.callerNameRequiredShort));
    expect(find.text(_l10n.callerNameRequiredShort), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Pak Bos');
    await tester.pump();
    await tester.pump();
    expect(find.text(_l10n.callerNameRequiredShort), findsNothing);
    await tester.runAsync(bloc.close);
  });

  testWidgets('saran nama muncul saat field aktif dan bisa dipilih', (
    tester,
  ) async {
    _history.stored = const CallerNameHistory(['Mama', 'Pak Bos']);
    tester.view.physicalSize = const Size(1080, 2520);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final bloc = buildBloc();
    await tester.pumpWidget(_host(bloc));
    await tester.pumpAndSettle();
    expect(find.text(_l10n.recentNamesLabel), findsNothing);

    await _reveal(tester, find.byType(TextField));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();
    expect(find.text(_l10n.recentNamesLabel), findsOneWidget);
    expect(find.widgetWithText(InputChip, 'Pak Bos'), findsOneWidget);

    await tester.tap(find.widgetWithText(InputChip, 'Pak Bos'));
    await tester.pumpAndSettle();
    expect(bloc.state.config.callerName, 'Pak Bos');
    expect(find.text(_l10n.recentNamesLabel), findsNothing);
    await tester.runAsync(bloc.close);
  });

  testWidgets('tombol back diblokir selama hitung mundur', (tester) async {
    tester.view.physicalSize = const Size(1080, 2520);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final bloc = buildBloc();
    await tester.pumpWidget(_host(bloc));
    bloc
      ..add(
        FakeCallConfigChanged(bloc.state.config.copyWith(callerName: 'Mama')),
      )
      ..add(const FakeCallScheduleRequested());
    await tester.pump();
    await tester.pump();
    expect(find.text(_l10n.cancel), findsOneWidget);

    final handled = await tester.binding.handlePopRoute();
    await tester.pump();

    expect(handled, isTrue);
    expect(find.text(_l10n.cancel), findsOneWidget);
    expect(find.text(_l10n.backBlockedHint), findsOneWidget);
    await tester.runAsync(bloc.close);
  });

  testWidgets('pemilih video hanya muncul untuk video call', (tester) async {
    tester.view.physicalSize = const Size(1080, 2520);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final bloc = buildBloc();
    await tester.pumpWidget(_host(bloc));
    await tester.pumpAndSettle();
    expect(find.text(_l10n.callerVideoLabel), findsOneWidget);

    await _reveal(tester, find.text(_l10n.callTypeVoice));
    await tester.pumpAndSettle();
    await tester.tap(find.text(_l10n.callTypeVoice));
    await tester.pumpAndSettle();
    expect(find.text(_l10n.callerVideoLabel), findsNothing);
    await tester.runAsync(bloc.close);
  });

  testWidgets('menyimpan lalu memakai preset penelepon', (tester) async {
    tester.view.physicalSize = const Size(1080, 2520);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    _presets.presets = const [
      CallerPreset(id: 'bos', name: 'Pak Bos', callType: CallType.voice),
    ];
    final bloc = buildBloc();
    await tester.pumpWidget(_host(bloc));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Pak Bos').first);
    await tester.pumpAndSettle();
    expect(bloc.state.config.callerName, 'Pak Bos');
    expect(bloc.state.config.callType, CallType.voice);
    expect(find.widgetWithText(TextField, 'Pak Bos'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Mama');
    await tester.pump();
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    await _reveal(tester, find.byIcon(Icons.bookmark_add_outlined));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.bookmark_add_outlined));
    await tester.pumpAndSettle();
    expect(_presets.presets.map((p) => p.name), ['Mama', 'Pak Bos']);
    expect(find.text(_l10n.presetsSaved('Mama')), findsOneWidget);
    await tester.runAsync(bloc.close);
  });

  testWidgets('tur panduan muncul sekali lalu ditandai selesai', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2520);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    _coach.seen = false;
    final bloc = buildBloc();
    await tester.pumpWidget(_host(bloc));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(find.text(_l10n.coachPreviewTitle), findsOneWidget);
    await tester.tap(find.text(_l10n.coachSkip));
    await tester.pumpAndSettle();

    expect(find.text(_l10n.coachPreviewTitle), findsNothing);
    expect(_coach.seen, isTrue);
    await tester.runAsync(bloc.close);
  });

  testWidgets('form menampilkan jeda hanya saat panggil ulang aktif', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2520);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final bloc = buildBloc();
    await tester.pumpWidget(_host(bloc));

    await tester.scrollUntilVisible(
      find.byTooltip(_l10n.recallIncrease),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(find.text(_l10n.recallIntervalLabel), findsNothing);
    await tester.tap(find.byTooltip(_l10n.recallIncrease));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text(_l10n.recallIntervalLabel),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text(_l10n.recallIntervalLabel), findsOneWidget);
    expect(bloc.state.config.autoRecallCount, 1);
    await tester.runAsync(bloc.close);
  });
}

Future<void> _reveal(WidgetTester tester, Finder finder) async {
  await Scrollable.ensureVisible(tester.element(finder), alignment: 0.5);
  await tester.pumpAndSettle();
}
