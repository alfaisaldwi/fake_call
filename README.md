# Fake Call: Prank & Escape

A Flutter app that schedules a realistic fake incoming call: a real ringtone, a full-screen incoming call screen (even on the lock screen), and an in-call screen with a looping caller video and your front camera. Use it to get out of awkward meetings, endless conversations, or just to prank a friend.

> Portfolio project. Not affiliated with, endorsed by, or connected to WhatsApp or Meta.

- **Package:** `com.elumi.prankcall`
- **Platforms:** Android (full experience), iOS (CallKit-based, limited; see [Known limitations](#known-limitations))
- **Languages:** English and Bahasa Indonesia

---

## Features

### Scheduling
- Voice or video call.
- Ring delay: now, 10 s, 30 s, 1 min, 5 min, 10 min, 20 min, or 30 min.
- Auto hang-up after 10 s – 2 min, both while ringing and after answering.
- Auto redial 0–10 times when the call is declined or missed, with a configurable interval (5 s – 1 min).
- Countdown screen with a progress ring, a summary of the active settings, and a pulsing animation while ringing. The back button is locked during the countdown; only **Cancel** stops it.

### Caller identity
- Any caller name, with validation and inline error highlighting.
- Recently used names (up to 10) are stored locally and shown as suggestions while the name field is focused.
- Caller photo from the gallery with a circular 1:1 crop.
- Caller video from the gallery for video calls. Portrait videos fill the screen; landscape videos are letterboxed over a blurred copy of themselves. If a video can't be played, the bundled default is used.
- Live preview card that mirrors the incoming call while you fill in the form.

### Incoming call (Android)
- Full-screen incoming call, including on the lock screen, with a custom looping ringtone.
- Drag-to-answer button: it follows your finger and springs back if released too early. While idle it bounces, with a shimmering chevron hint above it.
- Video calls show a live front-camera preview behind the caller.

### In-call screen
- **Video call:** looping caller video, a draggable picture-in-picture front camera (long-press, drag, snaps to the nearest corner), call timer, switch camera, video toggle, mute, and end call.
- **Voice call:** blurred photo background, large avatar, timer, speaker, switch to video, mute, and end call.
- Taps are ignored for the first second after answering, to prevent accidental hang-ups.

### Missed call notification
- Shown when a call isn't answered, with the caller's name, a red call icon, and their photo (custom Android layout).
- Multiple unanswered redial attempts are grouped, for example "3 missed video calls". Declined calls don't trigger a notification.

### Localization and privacy
- English and Bahasa Indonesia. Defaults to the device language, switchable from the app bar flag menu.
- No account and no network calls. Only the language choice and the name history are stored on the device.

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
| **Presentation** | Blocs (events and states extend `Equatable`), pages, widgets | Blocs depend only on use cases. UI reacts with `BlocBuilder`/`BlocListener`; errors surface as SnackBars or dialogs. |

### Project structure

```
lib/
├── app.dart                     # MaterialApp.router, Bloc providers, locale
├── main.dart
├── injection_container.dart     # get_it registrations (external → data → domain → Bloc)
├── core/
│   ├── error/                   # Failure, AppException, FailureReason
│   ├── l10n/                    # AppLocaleHolder, FailureMessages, LocaleSync
│   ├── router/                  # go_router configuration
│   ├── theme/                   # AppColors, AppTheme
│   ├── usecases/                # UseCase<T, Params>, NoParams
│   ├── utils/
│   └── widgets/                 # shared widgets (avatar, tap guard, lifecycle listener)
├── features/
│   ├── fake_call/               # scheduling, redial, history, notifications, setup UI
│   ├── active_call/             # camera + caller video, in-call UI
│   └── settings/                # app language
└── l10n/                        # app_en.arb, app_id.arb (+ generated code)
```

### Notable design decisions
- **Errors are reasons, not sentences.** Failures carry a `FailureReason` enum. `FailureMessages` turns them into localized text, so the Data layer never contains user-facing copy.
- **Call sessions live in the repository.** `FakeCallRepositoryImpl` owns the delay, redial, and auto-hang-up timers, filters native events by call ID, ignores late events after a call is answered, and re-syncs with the OS (`activeCalls()`) whenever the app returns to the foreground.
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

### Permissions requested at runtime
- **Notifications** and **full-screen intent** (Android 14+): needed to show the incoming call. If full-screen intent is off, the app opens the system setting.
- **Camera:** requested when a video call is scheduled, for the front-camera preview.
- **Photos/videos:** through the system photo picker, when choosing a caller photo or video.

> After changing native code, the manifest, or Gradle files, stop the app and run it again; hot reload won't pick those changes up.

---

## Testing

```bash
flutter analyze
flutter test
```

The suite has 59 tests covering:
- domain rules: config validation and caller name history,
- the call session logic in the repository, using `fake_async`: delay, redial, auto hang-up, late native events, active-call sync, and missed-call notification counts,
- Blocs: fake call, active call media lifecycle, suggestions, and language,
- widgets: the setup form, validation dialog, suggestions, back-button lock, video picker visibility, language switching, the in-call views, and the draggable PiP.

---

## Known limitations
- **Delays run on a Dart timer.** Long delays (20–30 min) on a locked phone can be cut short by aggressive battery optimization. Moving scheduling to `AlarmManager` would fix this.
- **Mute and speaker only change the button state;** no audio is captured.
- **The "Message" button and the "Turn off your video" pill** on the incoming call screen are visual only.
- **Native incoming call text** ("Swipe up to accept", "Message") follows the system language, not the in-app language choice.
- **iOS** uses the system CallKit UI: no caller photo, camera background, or custom controls on the incoming screen; no red icon in the missed call notification; and delays only run while the app is open.

---

## Play Store

Listing copy (Indonesian and English), Play Console notes, and a pre-release checklist are in [`PLAY_STORE.md`](PLAY_STORE.md).
