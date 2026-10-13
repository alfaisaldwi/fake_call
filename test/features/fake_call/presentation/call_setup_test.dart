import 'package:dartz/dartz.dart';
import 'package:fake_whatsapp_call/core/error/failures.dart';
import 'package:fake_whatsapp_call/features/fake_call/domain/entities/call_config.dart';
import 'package:fake_whatsapp_call/features/fake_call/domain/entities/call_config_issue.dart';
import 'package:fake_whatsapp_call/features/fake_call/domain/entities/call_event.dart';
import 'package:fake_whatsapp_call/features/fake_call/domain/repositories/caller_avatar_repository.dart';
import 'package:fake_whatsapp_call/features/fake_call/domain/repositories/fake_call_repository.dart';
import 'package:fake_whatsapp_call/features/fake_call/domain/usecases/end_fake_call.dart';
import 'package:fake_whatsapp_call/features/fake_call/domain/usecases/listen_to_call_events.dart';
import 'package:fake_whatsapp_call/features/fake_call/domain/usecases/pick_caller_avatar.dart';
import 'package:fake_whatsapp_call/features/fake_call/domain/usecases/schedule_fake_call.dart';
import 'package:fake_whatsapp_call/features/fake_call/domain/usecases/sync_active_call.dart';
import 'package:fake_whatsapp_call/features/fake_call/presentation/bloc/fake_call_bloc.dart';
import 'package:fake_whatsapp_call/features/fake_call/presentation/pages/call_setup_page.dart';
import 'package:fake_whatsapp_call/core/l10n/app_locale_holder.dart';
import 'package:fake_whatsapp_call/core/l10n/failure_messages.dart';
import 'package:fake_whatsapp_call/features/settings/domain/entities/app_language.dart';
import 'package:fake_whatsapp_call/features/settings/domain/repositories/language_repository.dart';
import 'package:fake_whatsapp_call/features/settings/domain/usecases/get_app_language.dart';
import 'package:fake_whatsapp_call/features/settings/domain/usecases/save_app_language.dart';
import 'package:fake_whatsapp_call/features/settings/presentation/bloc/language_bloc.dart';
import 'package:fake_whatsapp_call/l10n/app_localizations.dart';
import 'package:fake_whatsapp_call/features/fake_call/domain/entities/caller_name_history.dart';
import 'package:fake_whatsapp_call/features/fake_call/domain/repositories/caller_name_history_repository.dart';
import 'package:fake_whatsapp_call/features/fake_call/domain/usecases/forget_caller_name.dart';
import 'package:fake_whatsapp_call/features/fake_call/domain/usecases/get_caller_name_history.dart';
import 'package:fake_whatsapp_call/features/fake_call/domain/usecases/remember_caller_name.dart';
import 'package:fake_whatsapp_call/features/fake_call/presentation/bloc/caller_suggestions_bloc.dart';
import 'package:fake_whatsapp_call/features/fake_call/domain/repositories/caller_video_repository.dart';
import 'package:fake_whatsapp_call/features/fake_call/domain/usecases/pick_caller_video.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeCallRepository implements FakeCallRepository {
  CallConfig? scheduled;

  @override
  Future<Either<Failure, Unit>> scheduleCall(CallConfig config) async {
    scheduled = config;
    return const Right(unit);
  }

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

Widget _hostWithLanguage(FakeCallBloc bloc) {
  final languageRepository = _FakeLanguageRepository();
  return MultiBlocProvider(
    providers: [
      BlocProvider.value(value: bloc),
      BlocProvider(create: (_) => _suggestionsBloc()),
      BlocProvider(
        create: (_) => LanguageBloc(
          getAppLanguage: GetAppLanguage(languageRepository),
          saveAppLanguage: SaveAppLanguage(languageRepository),
          failureMessages: _messages,
        )..add(const LanguageStarted()),
      ),
    ],
    child: BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, state) => MaterialApp(
        locale: state.locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const CallSetupPage(),
      ),
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
    failureMessages: _messages,
  );

  Future<void> settle() => Future<void>.delayed(Duration.zero);

  setUp(() {
    _history.stored = const CallerNameHistory.empty();
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

    test('nama kosong ditolak dan menandai field nama', () async {
      final bloc = buildBloc()..add(const FakeCallScheduleRequested());
      await settle();

      final state = bloc.state as FakeCallError;
      expect(state.invalidField, CallConfigField.callerName);
      expect(callRepository.scheduled, isNull);
      await bloc.close();
    });

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
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final bloc = buildBloc();
    await tester.pumpWidget(_host(bloc));
    expect(find.text(_l10n.callerNameHint), findsOneWidget);

    await tester.tap(find.text(_l10n.scheduleCall));
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text(_l10n.errorCallerNameRequired), findsOneWidget);

    await tester.tap(find.text(_l10n.ok));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.ensureVisible(find.text(_l10n.callerNameRequiredShort));
    expect(find.text(_l10n.callerNameRequiredShort), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Pak Bos');
    await tester.pump();
    await tester.pump();
    expect(find.text(_l10n.callerNameRequiredShort), findsNothing);
    await tester.runAsync(bloc.close);
  });

  testWidgets('ganti bahasa dari AppBar langsung mengubah teks', (
    tester,
  ) async {
    final bloc = buildBloc();
    await tester.pumpWidget(_hostWithLanguage(bloc));
    await tester.pumpAndSettle();
    final english = lookupAppLocalizations(const Locale('en'));
    expect(find.text(_l10n.scheduleCall), findsOneWidget);

    await tester.tap(find.text('ID'));
    await tester.pumpAndSettle();
    await tester.tap(find.text(_l10n.languageEnglish));
    await tester.pumpAndSettle();

    expect(find.text(english.scheduleCall), findsOneWidget);
    expect(find.text('EN'), findsOneWidget);
    await tester.runAsync(bloc.close);
  });

  testWidgets('saran nama muncul saat field aktif dan bisa dipilih', (
    tester,
  ) async {
    _history.stored = const CallerNameHistory(['Mama', 'Pak Bos']);
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final bloc = buildBloc();
    await tester.pumpWidget(_host(bloc));
    await tester.pumpAndSettle();
    expect(find.text(_l10n.recentNamesLabel), findsNothing);

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
    tester.view.physicalSize = const Size(1080, 2400);
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
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final bloc = buildBloc();
    await tester.pumpWidget(_host(bloc));
    await tester.pumpAndSettle();
    expect(find.text(_l10n.callerVideoLabel), findsOneWidget);

    await tester.ensureVisible(find.text(_l10n.callTypeVoice));
    await tester.pumpAndSettle();
    await tester.tap(find.text(_l10n.callTypeVoice));
    await tester.pumpAndSettle();
    expect(find.text(_l10n.callerVideoLabel), findsNothing);
    await tester.runAsync(bloc.close);
  });

  testWidgets('form menampilkan jeda hanya saat panggil ulang aktif', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
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
