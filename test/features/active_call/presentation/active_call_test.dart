import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:fake_calling/core/error/failures.dart';
import 'package:fake_calling/features/active_call/domain/entities/call_media.dart';
import 'package:fake_calling/features/active_call/domain/repositories/call_media_repository.dart';
import 'package:fake_calling/features/active_call/domain/usecases/set_camera_enabled.dart';
import 'package:fake_calling/features/active_call/domain/usecases/set_playback_paused.dart';
import 'package:fake_calling/features/active_call/domain/usecases/start_call_media.dart';
import 'package:fake_calling/features/active_call/domain/usecases/stop_call_media.dart';
import 'package:fake_calling/features/active_call/domain/usecases/switch_camera.dart';
import 'package:fake_calling/features/active_call/presentation/bloc/active_call_bloc.dart';
import 'package:fake_calling/features/active_call/presentation/widgets/video_call_view.dart';
import 'package:fake_calling/features/active_call/presentation/widgets/voice_call_view.dart';
import 'package:fake_calling/features/fake_call/domain/entities/call_config.dart';
import 'package:fake_calling/core/l10n/app_locale_holder.dart';
import 'package:fake_calling/core/l10n/failure_messages.dart';
import 'package:fake_calling/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

const _media = CallMedia(
  cameraViewId: 1,
  cameraAspectRatio: 4 / 3,
  remoteVideoViewId: 2,
  remoteVideoAspectRatio: 9 / 16,
);

class _FakeMediaRepository implements CallMediaRepository {
  int started = 0;
  int stopped = 0;
  Completer<void>? startGate;
  Either<Failure, CallMedia> startResult = const Right(_media);
  String? lastVideoPath;

  @override
  Future<Either<Failure, CallMedia>> startMedia({String? videoPath}) async {
    started++;
    lastVideoPath = videoPath;
    await startGate?.future;
    return startResult;
  }

  @override
  Future<Either<Failure, Unit>> stopMedia() async {
    stopped++;
    return const Right(unit);
  }

  @override
  Future<Either<Failure, Unit>> setCameraEnabled(bool enabled) async =>
      const Right(unit);

  @override
  Future<Either<Failure, CallMedia>> switchCamera() async =>
      const Right(_media);

  final pausedCalls = <bool>[];

  @override
  Future<Either<Failure, Unit>> setPlaybackPaused(bool paused) async {
    pausedCalls.add(paused);
    return const Right(unit);
  }
}

void main() {
  late _FakeMediaRepository repository;

  ActiveCallBloc buildBloc() => ActiveCallBloc(
    startCallMedia: StartCallMedia(repository),
    stopCallMedia: StopCallMedia(repository),
    setCameraEnabled: SetCameraEnabled(repository),
    switchCamera: SwitchCamera(repository),
    setPlaybackPaused: SetPlaybackPaused(repository),
    failureMessages: FailureMessages(AppLocaleHolder(const Locale('en'))),
  );

  Future<void> settle() => Future<void>.delayed(Duration.zero);

  setUp(() => repository = _FakeMediaRepository());

  group('ActiveCallBloc', () {
    test('timer panggilan mulai dari durasi awal', () async {
      final bloc = buildBloc()
        ..add(
          const ActiveCallStarted(
            CallType.voice,
            initialElapsed: Duration(minutes: 5),
          ),
        );
      await settle();

      expect(
        (bloc.state as ActiveCallInProgress).elapsed,
        const Duration(minutes: 5),
      );
      await bloc.close();
    });

    test('voice call tidak membuka kamera maupun video', () async {
      final bloc = buildBloc()
        ..add(const ActiveCallStarted(CallType.voice))
        ..add(const ActiveCallForegroundChanged(true));
      await settle();

      final state = bloc.state as ActiveCallInProgress;
      expect(state.isVideoMode, isFalse);
      expect(state.media, isNull);
      expect(repository.started, 0);

      await bloc.close();
      expect(repository.stopped, 0);
    });

    test('video call memuat media lalu melepasnya saat ditutup', () async {
      final bloc = buildBloc()
        ..add(const ActiveCallStarted(CallType.video))
        ..add(const ActiveCallForegroundChanged(true));
      await settle();

      expect((bloc.state as ActiveCallInProgress).media, _media);
      await bloc.close();
      expect(repository.stopped, 1);
    });

    test('video kustom diteruskan ke media', () async {
      final bloc = buildBloc()
        ..add(
          const ActiveCallStarted(CallType.video, videoPath: '/videos/bos.mp4'),
        )
        ..add(const ActiveCallForegroundChanged(true));
      await settle();

      expect(repository.lastVideoPath, '/videos/bos.mp4');
      await bloc.close();
    });

    test('upgrade voice ke video memuat media', () async {
      final bloc = buildBloc()
        ..add(const ActiveCallStarted(CallType.voice))
        ..add(const ActiveCallForegroundChanged(true));
      await settle();
      bloc.add(const ActiveCallVideoRequested());
      await settle();

      final state = bloc.state as ActiveCallInProgress;
      expect(state.isVideoMode, isTrue);
      expect(state.media, _media);
      await bloc.close();
    });

    test('upgrade gagal kembali ke voice dan mengirim error', () async {
      repository.startResult = const Left(
        MediaFailure(FailureReason.cameraUnavailable),
      );
      final bloc = buildBloc()
        ..add(const ActiveCallStarted(CallType.voice))
        ..add(const ActiveCallForegroundChanged(true));
      await settle();
      final emitted = <ActiveCallState>[];
      final sub = bloc.stream.listen(emitted.add);

      bloc.add(const ActiveCallVideoRequested());
      await settle();

      expect(emitted.whereType<ActiveCallError>(), isNotEmpty);
      expect((bloc.state as ActiveCallInProgress).isVideoMode, isFalse);
      await sub.cancel();
      await bloc.close();
    });

    test('media baru dimuat setelah app tampil di depan', () async {
      final bloc = buildBloc()..add(const ActiveCallStarted(CallType.video));
      await settle();
      expect(repository.started, 0);
      expect((bloc.state as ActiveCallInProgress).isMediaLoading, isTrue);

      bloc.add(const ActiveCallForegroundChanged(true));
      await settle();
      expect(repository.started, 1);
      expect((bloc.state as ActiveCallInProgress).media, _media);
      await bloc.close();
    });

    test('video dijeda saat app ke background dan diputar lagi', () async {
      final bloc = buildBloc()
        ..add(const ActiveCallStarted(CallType.video))
        ..add(const ActiveCallForegroundChanged(true));
      await settle();
      bloc.add(const ActiveCallForegroundChanged(false));
      await settle();
      bloc.add(const ActiveCallForegroundChanged(true));
      await settle();

      expect(repository.pausedCalls, [true, false]);
      await bloc.close();
    });

    test(
      'media yang selesai dimuat setelah halaman ditutup tetap dilepas',
      () async {
        repository.startGate = Completer<void>();
        final bloc = buildBloc()
          ..add(const ActiveCallStarted(CallType.video))
          ..add(const ActiveCallForegroundChanged(true));
        await settle();
        bloc.add(const ActiveCallStopped());
        await settle();

        repository.startGate!.complete();
        await settle();
        await settle();

        expect(repository.stopped, 1);
        await bloc.close();
      },
    );
  });

  group('render', () {
    const config = CallConfig(
      delayInSeconds: 0,
      callerName: 'Pak Bos',
      callType: CallType.video,
    );

    Widget host(ActiveCallBloc bloc, Widget child) => MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider.value(
        value: bloc,
        child: Scaffold(body: child),
      ),
    );

    testWidgets('VideoCallView tanpa media menampilkan overlay lengkap', (
      tester,
    ) async {
      final bloc = buildBloc();
      await tester.pumpWidget(
        host(
          bloc,
          VideoCallView(
            config: config,
            state: const ActiveCallInProgress(
              isVideoMode: true,
              isMediaLoading: true,
              elapsed: Duration(seconds: 75),
            ),
            onBack: () {},
            onEndCall: () {},
          ),
        ),
      );

      expect(find.text('Pak Bos'), findsOneWidget);
      expect(find.text('01:15'), findsOneWidget);
      expect(find.text('End-to-end encrypted'), findsOneWidget);
      expect(find.byIcon(Icons.call_end), findsOneWidget);
      expect(find.byIcon(Icons.cameraswitch_outlined), findsOneWidget);
      await tester.runAsync(bloc.close);
    });

    testWidgets('VoiceCallView menampilkan identitas dan aksi suara', (
      tester,
    ) async {
      final bloc = buildBloc();
      var ended = false;
      await tester.pumpWidget(
        host(
          bloc,
          VoiceCallView(
            config: config.copyWith(callType: CallType.voice),
            state: const ActiveCallInProgress(
              isVideoMode: false,
              elapsed: Duration(seconds: 9),
            ),
            onBack: () {},
            onEndCall: () => ended = true,
          ),
        ),
      );

      expect(find.text('Pak Bos'), findsOneWidget);
      expect(find.text('00:09'), findsOneWidget);
      expect(find.byIcon(Icons.volume_up_outlined), findsOneWidget);

      await tester.tap(find.byIcon(Icons.call_end));
      expect(ended, isTrue);
      await tester.runAsync(bloc.close);
    });
  });
}
