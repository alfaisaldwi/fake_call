<p align="center">
  <img src="assets/img/logo.png" alt="Fake Calling logo" width="140">
</p>

<h1 align="center">Fake Calling: Prank &amp; Escape</h1>

A Flutter app that schedules a realistic fake incoming call: a real ringtone, a full-screen incoming call screen (even on the lock screen), and an in-call screen with a looping caller video and your front camera. Use it to get out of awkward meetings, endless conversations, or just to prank a friend.

> Portfolio project. Not affiliated with, endorsed by, or connected to WhatsApp or Meta.

- **Application ID:** `com.elumi.prankcall` · **Dart package:** `fake_calling`
- **Launcher name:** Fake Calling
- **Platforms:** Android (full experience), iOS (CallKit-based, limited; see [Known limitations](#known-limitations))
- **Languages:** English and Bahasa Indonesia

---

## Features

### Scheduling
- Voice or video call.
- Ring delay: now, 10 s, 30 s, 1 min, 5 min, 10 min, 20 min, or 30 min, or **at a specific time of day** (rolls over to tomorrow if that time has passed).
- **Reliable when the app is closed:** every call is also scheduled with Android's `AlarmManager` (exact when allowed), so it rings on time even after the app is swiped away or the phone is dozing. Reopening the app during a countdown restores it with the correct remaining time.
- Auto hang-up after 10 s – 2 min, both while ringing and after answering.
- Auto redial 0–10 times when the call is declined or missed, with a configurable interval (5 s – 1 min).
- **Caller presets:** save frequently used callers (name, photo, call type, video) and apply them with one tap.
- Countdown screen with a progress ring, a summary of the active settings, and a pulsing animation while ringing. The back button is locked during the countdown; only **Cancel** stops it.

### Caller identity
- Any caller name, with validation and inline error highlighting.
- Recently used names (up to 10) are stored locally and shown as suggestions while the name field is focused.
- Caller photo from the gallery with a circular 1:1 crop.
- Caller video from the gallery for video calls. Portrait videos fill the screen; landscape videos are letterboxed over a blurred copy of themselves. If a video can't be played, the bundled default is used.
- Live preview card that mirrors the incoming call while you fill in the form.

### Quick triggers (Android)
- **Home screen widget** with 10 s / 1 min / 5 min buttons: schedules a call with your last settings straight from the launcher, without opening the app.
- App shortcuts (long-press the icon) for 10 s and 1 min, and a Quick Settings tile.

### Incoming call (Android)
- Full-screen incoming call, including on the lock screen, with a custom looping ringtone.
- Drag-to-answer button: it follows your finger and springs back if released too early. While idle it bounces, with a shimmering chevron hint above it.
- Video calls show a live front-camera preview behind the caller.

### In-call screen
- **Video call:** looping caller video, a draggable picture-in-picture front camera (long-press, drag, snaps to the nearest corner), call timer, switch camera, video toggle, mute, and end call.
- **Voice call:** blurred photo background, large avatar, timer, speaker, switch to video, mute, and end call.
- **Starting call timer:** the in-call timer can start at 1, 5, or 15 minutes, so it looks like the call has been going on for a while.
- Taps are ignored for the first second after answering, to prevent accidental hang-ups.

### Missed call notification
- Shown when a call isn't answered, with the caller's name, a red call icon, and their photo (custom Android layout).
- Multiple unanswered redial attempts are grouped, for example "3 missed video calls". Declined calls don't trigger a notification.

### Onboarding, settings, and guidance
- Animated splash screen and onboarding, ending with a permission checklist: notifications, full-screen intent, camera, on-time (exact) alarms, and unrestricted battery.
- A one-time coach-mark tour of the home screen, which can be replayed from Settings.
- Settings page: theme (light by default, or dark, or follow the system), language, privacy notes, responsible-use notes, and open-source licenses.

### Localization and privacy
- English and Bahasa Indonesia. Defaults to the device language, switchable in Settings.
- No account and no network calls. Settings, presets, the last call setup, and the name history are stored only on the device.

---

## Tech stack

| Concern | Library |
|---|---|
| State management | `flutter_bloc` (event-driven Bloc, no Cubits) |
| Dependency injection | `get_it` |
| Routing | `go_router` |
| Functional error handling | `dartz` (`Either<Failure, T>`) |
| Value equality | `equatable` |
| Native incoming call | `flutter_callkit_incoming` |
| Camera and video | `camera`, `video_player` (rendered through their platform interfaces) |
| Media picking | `image_picker`, `image_cropper` |
| Permissions | `permission_handler` |
| Notifications | Native Kotlin on Android, `flutter_local_notifications` on iOS |
| Persistence | `shared_preferences` |
| Localization | `flutter_localizations`, `intl`, `gen-l10n` |
| Coach marks | `showcaseview` |
| Time in tests | `clock` |
| Testing | `flutter_test`, `fake_async` |

---

## Architecture

The app follows **feature-first Clean Architecture**. Each feature has three layers with strict dependency rules:

```
presentation  ──▶  domain  ◀──  data
 (Bloc, UI)        (pure Dart)   (plugins, platform)
```

| Layer | Contains | Rules |
|---|---|---|
| **Domain** | Entities, abstract repositories, use cases | Pure Dart; no Flutter or third-party plugin imports. Repositories return `Future<Either<Failure, T>>`. One public `call()` per use case. |
| **Data** | Models (`fromJson`/`toJson`), data sources, repository implementations | Data sources throw `AppException`s; repositories catch them and return `Left(Failure)`. |
| **Presentation** | Blocs (events and states extend `Equatable`), pages, widgets | Blocs depend only on use cases. UI reacts with `BlocBuilder`/`BlocListener`; errors surface as top toasts or dialogs. |

### Project structure

```
lib/
├── app.dart                     # MaterialApp.router, Bloc providers, locale
├── main.dart                    # app entry + scheduledCallMain (background entry point)
├── injection_container.dart     # get_it registrations (external → data → domain → Bloc)
├── core/
│   ├── error/                   # Failure, AppException, FailureReason
│   ├── l10n/                    # AppLocaleHolder, FailureMessages, LocaleSync
│   ├── router/                  # go_router configuration
│   ├── theme/                   # AppColors (brand palette), AppPalette (light/dark), AppTheme
│   ├── usecases/                # UseCase<T, Params>, NoParams
│   ├── utils/
│   └── widgets/                 # shared widgets (avatar, tap guard, lifecycle listener)
├── features/
│   ├── fake_call/               # scheduling, alarms, redial, presets, history, setup UI
│   ├── active_call/             # camera + caller video, in-call UI
│   ├── onboarding/              # splash, onboarding, coach-mark tour
│   ├── permissions/             # permission checklist
│   └── settings/                # theme, language, about
└── l10n/                        # app_en.arb, app_id.arb (+ generated code)
```

### Notable design decisions
- **Errors are reasons, not sentences.** Failures carry a `FailureReason` enum. `FailureMessages` turns them into localized text, so the Data layer never contains user-facing copy.
- **Call sessions live in the repository.** `FakeCallRepositoryImpl` owns the delay, redial, and auto-hang-up timers, filters native events by call ID, ignores late events after a call is answered, and re-syncs with the OS (`activeCalls()`) whenever the app returns to the foreground.
- **Two clocks, one ring.** A scheduled call arms both an in-app timer and a native alarm. Whichever fires first cancels the other. If the app's Flutter engine is gone, the alarm starts a headless engine at `scheduledCallMain`, which runs the same repository logic (ringing, vibration, redial, missed-call notification) and shuts itself down when the call finishes.
- **No Flutter controllers in the domain.** The active call exposes texture/view IDs and aspect ratios through the `CallMedia` entity; widgets render them via `CameraPlatform` and `VideoPlayerPlatform`.

---

## Native Android customizations

These live in `android/app/src/main` and don't modify any plugin source:

| What | How |
|---|---|
| WhatsApp-style incoming call screen | App-level override of the plugin's `activity_callkit_incoming.xml`, using the same view IDs, plus custom views in `com.elumi.prankcall.incoming`: `IncomingCallLayout` (adapts to voice/video), `FrontCameraPreviewView` (Camera2 preview), `AcceptCallButton` (drag-to-answer with bounce), `SwipeHintChevrons` (shimmer). |
| Opening the call screen after answering | `MainActivity` uses `launchMode="singleInstance"` and sets `showWhenLocked`/`turnScreenOn` only for accept intents. |
| Caller photo on the native screen | The plugin only loads `http(s)` URLs, so a loopback-only HTTP server (`127.0.0.1`, random token) serves the local file. `network_security_config.xml` allows cleartext for `127.0.0.1` only. |
| Caller video freezing during the call | ExoPlayer waits for audio focus held by the active call, so the player is created with `setMixWithOthers(true)`. |
| Portrait videos shown sideways | The player's `rotationCorrection` is applied with a `RotatedBox`, mirroring the official `VideoPlayer` widget. |
| Missed call notification with a red icon | `MissedCallNotifier` (Kotlin) posts a `DecoratedCustomViewStyle` notification with a custom layout, called from Dart through a `MethodChannel`. |
| Scheduling when the app is closed | `CallAlarm` (`setAlarmClock`, inexact fallback) stores the call payload and fires `CallAlarmReceiver`. `CallDispatcher` forwards it to the running app, or `BackgroundCallEngine` starts a headless Flutter engine. Shared method channels are registered in `NativeChannels` for both engines. |
| Home screen widget | `QuickCallWidget` (`AppWidgetProvider`) reads the last setup saved by Flutter and schedules the alarm directly. |
| Quick Settings tile and shortcuts | `QuickCallTileService` and `res/xml/shortcuts.xml` open the app with a delay, handled over a `MethodChannel`. |
| Fewer permissions | The manifest removes plugin permissions the app doesn't use (`RECORD_AUDIO`, `FOREGROUND_SERVICE_MICROPHONE`, `READ_EXTERNAL_STORAGE`, `ACCESS_NOTIFICATION_POLICY`, `DISABLE_KEYGUARD`) and narrows the CallKit service to `phoneCall|camera`. |
| Custom ringtone | `res/raw/incoming_call.mp3`, kept from resource shrinking via `res/raw/keep.xml`. iOS uses `ios/Runner/incoming_call.caf`. |

---

## Getting started

### Requirements
- Flutter 3.47 (Dart SDK `^3.13.0`)
- Android SDK with `compileSdk` 36; the minimum SDK follows Flutter's default
- Xcode, for iOS builds

### Run
```bash
flutter pub get
flutter run
```

Localizations are generated automatically on build (`generate: true`). To regenerate them manually after editing the ARB files:
```bash
flutter gen-l10n
```

### Assets
- **Default caller video:** `assets/videos/caller.mp4`. Replace it with a video you have the rights to.
- **Ringtone:** `android/app/src/main/res/raw/incoming_call.mp3` and `ios/Runner/incoming_call.caf`.
- **Logo and icons:** source logo in `assets/img/logo.png`; launcher icons and splash images live in `assets/img/launcher/`. Regenerate with `dart run flutter_launcher_icons` and `dart run flutter_native_splash:create`.

### Permissions requested at runtime
- **Notifications** and **full-screen intent** (Android 14+): needed to show the incoming call. If full-screen intent is off, the app opens the system setting.
- **Camera:** requested when a video call is scheduled, for the front-camera preview.
- **Alarms & reminders** (Android 12+): required when scheduling; if it's off, the app opens the system setting. Calls are scheduled with `setAlarmClock`, which the system doesn't defer.
- **Unrestricted battery:** optional; the app opens its system info page so the user can pick *Battery → Unrestricted*. Recommended on aggressive OEM skins.
- **Photos/videos:** through the system photo picker, when choosing a caller photo or video.

> After changing native code, the manifest, or Gradle files, stop the app and run it again; hot reload won't pick those changes up.

---

## Testing

```bash
flutter analyze
flutter test
```

The suite has 98 tests covering:
- domain rules: config validation, ring-at-time calculation, and caller name history,
- models: JSON round-trips for the call setup and scheduled call payloads, including older saved data,
- the call session logic in the repository, using `fake_async`: delay, native alarm hand-off without double rings, restoring a pending call, background ringing, redial, auto hang-up, late native events, active-call sync, and missed-call notification counts,
- Blocs: fake call (including countdown restore), active call (including the starting timer), presets, suggestions, theme, language, onboarding, and the coach-mark tour,
- widgets: the setup form, validation dialog, suggestions, back-button lock, video picker visibility, presets, settings, onboarding permissions, the in-call views, the draggable PiP, and the top toast.

CI (`.github/workflows/build_apk.yml`) runs analyze and tests, then builds a release `fake_calling.apk` for `arm64-v8a`.

---

## Known limitations
- **Scheduled calls don't survive a reboot.** Alarms are cleared when the phone restarts.
- **Release builds are signed with the debug key** until a release keystore is configured.
- **An alarm icon shows in the status bar** while a call is scheduled, because calls use `setAlarmClock` for on-time delivery.
- **Mute and speaker only change the button state;** no audio is captured.
- **The "Message" button and the "Turn off your video" pill** on the incoming call screen are visual only.
- **Native incoming call text** ("Swipe up to accept", "Message") follows the system language, not the in-app language choice.
- **iOS** uses the system CallKit UI: no caller photo, camera background, or custom controls on the incoming screen; no red icon in the missed call notification; and scheduling (alarms, widget, ring-at-time while closed) only works while the app is open.
