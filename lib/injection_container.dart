import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'core/l10n/app_locale_holder.dart';
import 'core/l10n/failure_messages.dart';
import 'features/active_call/data/datasources/call_media_local_data_source.dart';
import 'features/active_call/data/repositories/call_media_repository_impl.dart';
import 'features/active_call/domain/repositories/call_media_repository.dart';
import 'features/active_call/domain/usecases/set_camera_enabled.dart';
import 'features/active_call/domain/usecases/set_playback_paused.dart';
import 'features/active_call/domain/usecases/start_call_media.dart';
import 'features/active_call/domain/usecases/stop_call_media.dart';
import 'features/active_call/domain/usecases/switch_camera.dart';
import 'features/active_call/presentation/bloc/active_call_bloc.dart';
import 'features/fake_call/data/datasources/avatar_host_data_source.dart';
import 'features/fake_call/data/datasources/caller_avatar_local_data_source.dart';
import 'features/fake_call/data/datasources/caller_name_history_local_data_source.dart';
import 'features/fake_call/data/datasources/caller_video_local_data_source.dart';
import 'features/fake_call/data/datasources/fake_call_native_data_source.dart';
import 'features/fake_call/data/datasources/missed_call_notification_data_source.dart';
import 'features/fake_call/data/repositories/caller_avatar_repository_impl.dart';
import 'features/fake_call/data/repositories/caller_name_history_repository_impl.dart';
import 'features/fake_call/data/repositories/caller_video_repository_impl.dart';
import 'features/fake_call/data/repositories/fake_call_repository_impl.dart';
import 'features/fake_call/domain/repositories/caller_avatar_repository.dart';
import 'features/fake_call/domain/repositories/caller_name_history_repository.dart';
import 'features/fake_call/domain/repositories/caller_video_repository.dart';
import 'features/fake_call/domain/repositories/fake_call_repository.dart';
import 'features/fake_call/domain/usecases/end_fake_call.dart';
import 'features/fake_call/domain/usecases/forget_caller_name.dart';
import 'features/fake_call/domain/usecases/get_caller_name_history.dart';
import 'features/fake_call/domain/usecases/listen_to_call_events.dart';
import 'features/fake_call/domain/usecases/pick_caller_avatar.dart';
import 'features/fake_call/domain/usecases/pick_caller_video.dart';
import 'features/fake_call/domain/usecases/remember_caller_name.dart';
import 'features/fake_call/domain/usecases/schedule_fake_call.dart';
import 'features/fake_call/domain/usecases/sync_active_call.dart';
import 'features/fake_call/presentation/bloc/caller_suggestions_bloc.dart';
import 'features/fake_call/presentation/bloc/fake_call_bloc.dart';
import 'features/settings/data/datasources/language_local_data_source.dart';
import 'features/settings/data/repositories/language_repository_impl.dart';
import 'features/settings/domain/repositories/language_repository.dart';
import 'features/settings/domain/usecases/get_app_language.dart';
import 'features/settings/domain/usecases/save_app_language.dart';
import 'features/settings/presentation/bloc/language_bloc.dart';

final sl = GetIt.instance;

const _callerVideoAsset = 'assets/videos/caller.mp4';

Future<void> init() async {
  await _registerExternal();
  _registerDataSources();
  _registerRepositories();
  _registerUseCases();
  _registerBlocs();
}

Future<void> _registerExternal() async {
  final preferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => preferences);
  sl.registerLazySingleton<AppLocaleHolder>(AppLocaleHolder.new);
  sl.registerLazySingleton<FailureMessages>(() => FailureMessages(sl()));
  sl.registerLazySingleton<Uuid>(() => const Uuid());
  sl.registerLazySingleton(FlutterLocalNotificationsPlugin.new);
  sl.registerLazySingleton<ImagePicker>(ImagePicker.new);
  sl.registerLazySingleton<ImageCropper>(ImageCropper.new);
}

void _registerDataSources() {
  sl.registerLazySingleton<AvatarHostDataSource>(
    () => AvatarHostDataSourceImpl(uuid: sl()),
  );
  sl.registerLazySingleton<FakeCallNativeDataSource>(
    () => FakeCallNativeDataSourceImpl(avatarHost: sl(), localeHolder: sl()),
  );
  sl.registerLazySingleton<CallerAvatarLocalDataSource>(
    () => CallerAvatarLocalDataSourceImpl(
      imagePicker: sl(),
      imageCropper: sl(),
      localeHolder: sl(),
    ),
  );
  sl.registerLazySingleton<MissedCallNotificationDataSource>(
    () =>
        MissedCallNotificationDataSourceImpl(plugin: sl(), localeHolder: sl()),
  );
  sl.registerLazySingleton<CallerVideoLocalDataSource>(
    () => CallerVideoLocalDataSourceImpl(imagePicker: sl()),
  );
  sl.registerLazySingleton<CallerNameHistoryLocalDataSource>(
    () => CallerNameHistoryLocalDataSourceImpl(preferences: sl()),
  );
  sl.registerLazySingleton<LanguageLocalDataSource>(
    () => LanguageLocalDataSourceImpl(preferences: sl()),
  );
  sl.registerLazySingleton<CallMediaLocalDataSource>(
    () => CallMediaLocalDataSourceImpl(videoAssetPath: _callerVideoAsset),
  );
}

void _registerRepositories() {
  sl.registerLazySingleton<FakeCallRepository>(
    () => FakeCallRepositoryImpl(
      dataSource: sl(),
      missedCallNotifier: sl(),
      uuid: sl(),
    ),
  );
  sl.registerLazySingleton<CallerAvatarRepository>(
    () => CallerAvatarRepositoryImpl(dataSource: sl()),
  );
  sl.registerLazySingleton<CallerVideoRepository>(
    () => CallerVideoRepositoryImpl(dataSource: sl()),
  );
  sl.registerLazySingleton<CallerNameHistoryRepository>(
    () => CallerNameHistoryRepositoryImpl(dataSource: sl()),
  );
  sl.registerLazySingleton<LanguageRepository>(
    () => LanguageRepositoryImpl(dataSource: sl()),
  );
  sl.registerLazySingleton<CallMediaRepository>(
    () => CallMediaRepositoryImpl(dataSource: sl()),
  );
}

void _registerUseCases() {
  sl.registerLazySingleton(() => ScheduleFakeCall(sl()));
  sl.registerLazySingleton(() => ListenToCallEvents(sl()));
  sl.registerLazySingleton(() => EndFakeCall(sl()));
  sl.registerLazySingleton(() => PickCallerAvatar(sl()));
  sl.registerLazySingleton(() => PickCallerVideo(sl()));
  sl.registerLazySingleton(() => GetCallerNameHistory(sl()));
  sl.registerLazySingleton(() => RememberCallerName(sl()));
  sl.registerLazySingleton(() => ForgetCallerName(sl()));
  sl.registerLazySingleton(() => SyncActiveCall(sl()));
  sl.registerLazySingleton(() => StartCallMedia(sl()));
  sl.registerLazySingleton(() => StopCallMedia(sl()));
  sl.registerLazySingleton(() => SetCameraEnabled(sl()));
  sl.registerLazySingleton(() => SwitchCamera(sl()));
  sl.registerLazySingleton(() => GetAppLanguage(sl()));
  sl.registerLazySingleton(() => SaveAppLanguage(sl()));
  sl.registerLazySingleton(() => SetPlaybackPaused(sl()));
}

void _registerBlocs() {
  sl.registerFactory(
    () => FakeCallBloc(
      scheduleFakeCall: sl(),
      listenToCallEvents: sl(),
      endFakeCall: sl(),
      pickCallerAvatar: sl(),
      pickCallerVideo: sl(),
      rememberCallerName: sl(),
      syncActiveCall: sl(),
      failureMessages: sl(),
    ),
  );
  sl.registerFactory(
    () => ActiveCallBloc(
      startCallMedia: sl(),
      stopCallMedia: sl(),
      setCameraEnabled: sl(),
      switchCamera: sl(),
      setPlaybackPaused: sl(),
      failureMessages: sl(),
    ),
  );
  sl.registerFactory(
    () => LanguageBloc(
      getAppLanguage: sl(),
      saveAppLanguage: sl(),
      failureMessages: sl(),
    ),
  );
  sl.registerFactory(
    () => CallerSuggestionsBloc(
      getCallerNameHistory: sl(),
      forgetCallerName: sl(),
      failureMessages: sl(),
    ),
  );
}
