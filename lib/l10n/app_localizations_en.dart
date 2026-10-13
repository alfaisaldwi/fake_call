// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Fake Call: Prank & Escape';

  @override
  String get languageMenuTooltip => 'Change language';

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
}
