// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Fake Calling: Prank & Escape';

  @override
  String get languageSystem => 'Use phone language';

  @override
  String get languageIndonesian => 'Bahasa Indonesia';

  @override
  String get languageEnglish => 'English';

  @override
  String get previewLabel => 'Preview';

  @override
  String get endToEndEncrypted => 'End-to-end encrypted';

  @override
  String get callerNamePlaceholder => 'Mom';

  @override
  String get incomingVideoCall => 'Incoming video call';

  @override
  String get incomingVoiceCall => 'Incoming voice call';

  @override
  String get pickPhotoSemantic => 'Choose caller photo';

  @override
  String get pickPhotoFromGallery => 'Choose from gallery';

  @override
  String get changePhoto => 'Change photo';

  @override
  String get removePhoto => 'Remove';

  @override
  String get callerSectionTitle => 'Caller';

  @override
  String get callerSectionSubtitle => 'Shows up on the incoming call screen';

  @override
  String get callerNameLabel => 'Caller name';

  @override
  String get callerNameHint => 'e.g. Mom';

  @override
  String get callTypeLabel => 'Call type';

  @override
  String get callTypeVoice => 'Voice';

  @override
  String get callTypeVideo => 'Video';

  @override
  String get timingSectionTitle => 'Timing';

  @override
  String get timingSectionSubtitle => 'When it rings and when it hangs up';

  @override
  String get ringAfterLabel => 'Ring after';

  @override
  String get autoHangupLabel => 'Auto hang up';

  @override
  String get autoHangupDescription =>
      'Hangs up on its own, while ringing or after you answer.';

  @override
  String get recallSectionTitle => 'Auto redial';

  @override
  String get recallSectionSubtitle => 'When the call is declined or missed';

  @override
  String get recallIntervalLabel => 'Redial interval';

  @override
  String get recallDecrease => 'Decrease';

  @override
  String get recallIncrease => 'Increase';

  @override
  String get recallNone => 'No redial';

  @override
  String get recallTimes => 'redial(s)';

  @override
  String get optionImmediately => 'Now';

  @override
  String get optionOff => 'Off';

  @override
  String durationSeconds(int seconds) {
    return '$seconds sec';
  }

  @override
  String durationMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get summaryVideoCall => 'Video call';

  @override
  String get summaryVoiceCall => 'Voice call';

  @override
  String get summaryRingsNow => 'rings now';

  @override
  String summaryRingsIn(String duration) {
    return 'rings in $duration';
  }

  @override
  String summaryRedial(int count) {
    return 'redial ${count}x';
  }

  @override
  String get scheduleCall => 'Schedule call';

  @override
  String get invalidConfigTitle => 'Hold on, can\'t schedule yet';

  @override
  String get ok => 'OK';

  @override
  String get callerNameRequiredShort => 'Caller name is empty';

  @override
  String get cancel => 'Cancel';

  @override
  String progressWillCall(String name) {
    return '$name will call you';
  }

  @override
  String get progressLockScreenHint =>
      'Feel free to lock your screen, the call will still come in.';

  @override
  String progressRedialIn(int seconds) {
    return 'Calling again in $seconds seconds';
  }

  @override
  String progressAttempt(int attempt, int total) {
    return 'Attempt $attempt of $total';
  }

  @override
  String get progressRinging => 'Ringing...';

  @override
  String get progressAnswerHint => 'Pick up from the incoming call screen.';

  @override
  String get progressInCall => 'In a call';

  @override
  String get progressOpeningCall => 'Opening call screen...';

  @override
  String get callDeclined => 'You declined the call.';

  @override
  String get callMissed => 'Nobody picked up.';

  @override
  String get callCancelled => 'Call cancelled.';

  @override
  String get callEnded => 'Call ended.';

  @override
  String get back => 'Back';

  @override
  String get switchCamera => 'Switch camera';

  @override
  String get turnOffVideo => 'Turn off video';

  @override
  String get turnOnVideo => 'Turn on video';

  @override
  String get muteMic => 'Mute microphone';

  @override
  String get unmuteMic => 'Unmute microphone';

  @override
  String get endCall => 'End call';

  @override
  String get speaker => 'Speaker';

  @override
  String get switchToVideo => 'Switch to video call';

  @override
  String get switchingToVideo => 'Switching to video...';

  @override
  String get nativeAccept => 'Accept';

  @override
  String get nativeDecline => 'Decline';

  @override
  String get nativeMissedCall => 'Missed call';

  @override
  String get nativeIncomingChannel => 'Incoming calls';

  @override
  String get nativeMissedChannel => 'Missed calls';

  @override
  String get notificationPermissionTitle => 'Notification permission';

  @override
  String get notificationPermissionRationale =>
      'Notifications are needed to show incoming calls.';

  @override
  String get notificationPermissionSettings =>
      'Enable notifications in Settings so calls can appear.';

  @override
  String get cropTitle => 'Adjust photo';

  @override
  String get cropDone => 'Done';

  @override
  String get cropCancel => 'Cancel';

  @override
  String get errorUnknown => 'Something went wrong. Give it another try.';

  @override
  String get errorFullScreenPermission =>
      'Enable the \"Full screen notification\" permission, then try again.';

  @override
  String get errorPermissionRequest => 'Couldn\'t request permission.';

  @override
  String get errorGalleryPermission => 'Gallery access was denied.';

  @override
  String get errorCameraPermission => 'Camera access was denied.';

  @override
  String get errorPhotoPick => 'Couldn\'t pick the photo.';

  @override
  String get errorPhotoCrop => 'Couldn\'t crop the photo.';

  @override
  String get errorCallStart => 'Couldn\'t show the call.';

  @override
  String get errorCallEnd => 'Couldn\'t end the call.';

  @override
  String get errorCallEvents => 'Couldn\'t read call status.';

  @override
  String get errorAvatar => 'Couldn\'t prepare the caller photo.';

  @override
  String get errorCamera => 'Couldn\'t open the camera.';

  @override
  String get errorVideo => 'The caller video can\'t be played.';

  @override
  String get errorSettings => 'Couldn\'t save the setting.';

  @override
  String get errorCallerNameRequired => 'Add a caller name first.';

  @override
  String get errorInvalidDelay => 'Delay can\'t be negative.';

  @override
  String get errorInvalidAutoHangup => 'Auto hang up can\'t be negative.';

  @override
  String errorInvalidRecallCount(int max) {
    return 'Redial count must be 0 to $max.';
  }

  @override
  String errorRecallIntervalTooShort(int min) {
    return 'The interval needs to be at least $min seconds.';
  }

  @override
  String get backBlockedHint => 'Want to stop? Tap Cancel.';

  @override
  String get errorHistory => 'Couldn\'t update recent names.';

  @override
  String get recentNamesLabel => 'Recently used';

  @override
  String forgetName(String name) {
    return 'Remove $name from history';
  }

  @override
  String get callerVideoLabel => 'Caller video';

  @override
  String get callerVideoDescription => 'Plays after you answer the video call.';

  @override
  String get callerVideoDefault => 'Default video';

  @override
  String get callerVideoCustom => 'Video from gallery';

  @override
  String get pickVideo => 'Choose video';

  @override
  String get changeVideo => 'Change';

  @override
  String get useDefaultVideo => 'Use default';

  @override
  String get errorVideoPick => 'Couldn\'t pick the video. Give it another try.';

  @override
  String chipAutoHangup(String duration) {
    return 'Hangs up in $duration';
  }

  @override
  String chipRedial(int count) {
    return 'Redial ${count}x';
  }

  @override
  String get missedVoiceCall => 'Missed voice call';

  @override
  String get missedVideoCall => 'Missed video call';

  @override
  String missedVoiceCalls(int count) {
    return '$count missed voice calls';
  }

  @override
  String missedVideoCalls(int count) {
    return '$count missed video calls';
  }

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingStart => 'Get started';

  @override
  String get onboarding1Title => 'Fake calls that feel real';

  @override
  String get onboarding1Body =>
      'A full-screen incoming call with a real ringtone and vibration, even when your phone is locked.';

  @override
  String get onboarding2Title => 'Make it yours';

  @override
  String get onboarding2Body =>
      'Pick the caller\'s name, photo, and video. Choose when it rings, from right now to 30 minutes later.';

  @override
  String get onboarding3Title => 'Escape like a pro';

  @override
  String get onboarding3Body =>
      'Auto hang up, auto redial, and missed call alerts. Nobody will ever know.';

  @override
  String get splashTagline => 'Your way out of awkward moments';

  @override
  String get onboarding4Title => 'One last thing';

  @override
  String get onboarding4Body =>
      'Allow these so your fake call can ring like the real thing.';

  @override
  String get permissionNotificationTitle => 'Notifications';

  @override
  String get permissionNotificationBody =>
      'To show the incoming call and missed calls.';

  @override
  String get permissionFullScreenTitle => 'Full-screen calls';

  @override
  String get permissionFullScreenBody =>
      'So the call shows up even when your phone is locked.';

  @override
  String get permissionCameraTitle => 'Camera';

  @override
  String get permissionCameraBody =>
      'For your face during video calls. Nothing is recorded.';

  @override
  String get permissionAllow => 'Allow';

  @override
  String get permissionGranted => 'Allowed';

  @override
  String get errorPreset => 'Couldn\'t update saved callers.';

  @override
  String get presetsTitle => 'Saved callers';

  @override
  String get presetsSave => 'Save';

  @override
  String presetsSaved(String name) {
    return '$name saved.';
  }

  @override
  String presetsDeleteTitle(String name) {
    return 'Remove $name?';
  }

  @override
  String get presetsDeleteBody =>
      'The photo and video saved with this caller will be removed too.';

  @override
  String get presetsDelete => 'Remove';

  @override
  String get presetsEmpty =>
      'Save callers you use often to set them up in one tap.';

  @override
  String get themeSystem => 'Use phone setting';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsTooltip => 'Settings';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsAbout => 'About';

  @override
  String aboutVersion(String version) {
    return 'Version $version';
  }

  @override
  String get aboutDescription =>
      'Schedule a realistic fake incoming call to escape awkward moments, or just to prank a friend.';

  @override
  String get aboutPrivacyTitle => 'Privacy';

  @override
  String get aboutPrivacyBody =>
      'No account and nothing sent over the internet. Everything stays on your phone.';

  @override
  String get aboutUseTitle => 'Use it kindly';

  @override
  String get aboutUseBody =>
      'Made for fun. Please don\'t use it to deceive or harm anyone.';

  @override
  String get aboutLicenses => 'Open-source licenses';

  @override
  String get aboutMadeBy => 'Made by';

  @override
  String get settingsPreferences => 'Preferences';

  @override
  String get homeTitle => 'Fake Calling';

  @override
  String get coachSkip => 'Skip';

  @override
  String get coachNext => 'Next';

  @override
  String get coachDone => 'Got it';

  @override
  String get coachPreviewTitle => 'This is how it looks';

  @override
  String get coachPreviewBody =>
      'A live preview of the incoming call. Tap the photo to pick one from your gallery.';

  @override
  String get coachPresetsTitle => 'Saved callers';

  @override
  String get coachPresetsBody =>
      'Save callers you use often, then set them up again in one tap.';

  @override
  String get coachNameTitle => 'Who\'s calling?';

  @override
  String get coachNameBody =>
      'Type any name. Names you\'ve used before show up as suggestions.';

  @override
  String get coachTypeTitle => 'Voice or video';

  @override
  String get coachTypeBody =>
      'Pick the call type. Video calls can use your own caller video.';

  @override
  String get coachTimingTitle => 'Set the timing';

  @override
  String get coachTimingBody =>
      'Choose when it rings and when it hangs up on its own.';

  @override
  String get coachScheduleTitle => 'Ready to go';

  @override
  String get coachScheduleBody =>
      'Tap here to schedule the call. Feel free to lock your phone after.';

  @override
  String get coachSettingsTitle => 'Settings';

  @override
  String get coachSettingsBody => 'Theme, language, and this tour live here.';

  @override
  String get settingsReplayTour => 'Show the tour again';

  @override
  String get errorCallSchedule => 'Couldn\'t set the call timer.';

  @override
  String get ringAtPick => 'Pick a time';

  @override
  String ringAtLabel(String time) {
    return 'At $time';
  }

  @override
  String get ringAtPickerTitle => 'Ring at what time?';

  @override
  String summaryRingsAt(String time) {
    return 'rings at $time';
  }

  @override
  String summaryRingsTomorrowAt(String time) {
    return 'rings tomorrow at $time';
  }

  @override
  String get initialDurationLabel => 'Starting call timer';

  @override
  String get initialDurationZero => 'From 00:00';

  @override
  String get permissionExactAlarmTitle => 'On-time alarms';

  @override
  String get permissionExactAlarmBody =>
      'So the call rings right on time, even after the app is closed.';

  @override
  String get permissionBatteryTitle => 'Unrestricted battery';

  @override
  String get permissionBatteryBody =>
      'Open Battery and pick “Unrestricted”. On Xiaomi, also turn on “Autostart” on the same page.';

  @override
  String get errorExactAlarmPermission =>
      'Allow \"Alarms & reminders\" so the call rings right on time, then schedule again.';

  @override
  String get permissionReminderTitle => 'Please allow everything';

  @override
  String get permissionReminderBody =>
      'Fake Calling needs these permissions to ring on time, show up on the lock screen, and keep working after the app is closed. Without them, the app can\'t work properly.';

  @override
  String get permissionReminderConfirm => 'Got it';

  @override
  String get settingsPermissions => 'App permissions';

  @override
  String get settingsPermissionsBody =>
      'Keep all of these on so your fake calls ring on time, even when the app is closed.';

  @override
  String get ringtoneLabel => 'Ringtone';

  @override
  String get ringtoneApp => 'Default';

  @override
  String get ringtoneSystem => 'My phone\'s ringtone';

  @override
  String get ringtoneSilent => 'Silent';

  @override
  String get vibrateLabel => 'Vibrate';

  @override
  String get previewCall => 'Preview';

  @override
  String get settingsCalls => 'Calls';

  @override
  String get homeSubtitle => 'Your way out, one tap away';

  @override
  String get updateCheck => 'Check for updates';

  @override
  String get updateAvailable => 'Update available';

  @override
  String get updateLatest => 'Up to date';

  @override
  String get updateUpToDate => 'You\'re on the latest version.';

  @override
  String get errorUpdateCheck =>
      'Couldn\'t check for updates. Make sure the app was installed from Google Play.';

  @override
  String get errorUpdate => 'The update couldn\'t start. Please try again.';
}
