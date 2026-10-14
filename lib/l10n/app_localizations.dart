import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Fake Calling: Prank & Escape'**
  String get appTitle;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'Use phone language'**
  String get languageSystem;

  /// No description provided for @languageIndonesian.
  ///
  /// In en, this message translates to:
  /// **'Bahasa Indonesia'**
  String get languageIndonesian;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @previewLabel.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get previewLabel;

  /// No description provided for @endToEndEncrypted.
  ///
  /// In en, this message translates to:
  /// **'End-to-end encrypted'**
  String get endToEndEncrypted;

  /// No description provided for @callerNamePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Mom'**
  String get callerNamePlaceholder;

  /// No description provided for @incomingVideoCall.
  ///
  /// In en, this message translates to:
  /// **'Incoming video call'**
  String get incomingVideoCall;

  /// No description provided for @incomingVoiceCall.
  ///
  /// In en, this message translates to:
  /// **'Incoming voice call'**
  String get incomingVoiceCall;

  /// No description provided for @pickPhotoSemantic.
  ///
  /// In en, this message translates to:
  /// **'Choose caller photo'**
  String get pickPhotoSemantic;

  /// No description provided for @pickPhotoFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get pickPhotoFromGallery;

  /// No description provided for @changePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change photo'**
  String get changePhoto;

  /// No description provided for @removePhoto.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get removePhoto;

  /// No description provided for @callerSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Caller'**
  String get callerSectionTitle;

  /// No description provided for @callerSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Shows up on the incoming call screen'**
  String get callerSectionSubtitle;

  /// No description provided for @callerNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Caller name'**
  String get callerNameLabel;

  /// No description provided for @callerNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Mom'**
  String get callerNameHint;

  /// No description provided for @callTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Call type'**
  String get callTypeLabel;

  /// No description provided for @callTypeVoice.
  ///
  /// In en, this message translates to:
  /// **'Voice'**
  String get callTypeVoice;

  /// No description provided for @callTypeVideo.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get callTypeVideo;

  /// No description provided for @timingSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Timing'**
  String get timingSectionTitle;

  /// No description provided for @timingSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'When it rings and when it hangs up'**
  String get timingSectionSubtitle;

  /// No description provided for @ringAfterLabel.
  ///
  /// In en, this message translates to:
  /// **'Ring after'**
  String get ringAfterLabel;

  /// No description provided for @autoHangupLabel.
  ///
  /// In en, this message translates to:
  /// **'Auto hang up'**
  String get autoHangupLabel;

  /// No description provided for @autoHangupDescription.
  ///
  /// In en, this message translates to:
  /// **'Hangs up on its own, while ringing or after you answer.'**
  String get autoHangupDescription;

  /// No description provided for @recallSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Auto redial'**
  String get recallSectionTitle;

  /// No description provided for @recallSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'When the call is declined or missed'**
  String get recallSectionSubtitle;

  /// No description provided for @recallIntervalLabel.
  ///
  /// In en, this message translates to:
  /// **'Redial interval'**
  String get recallIntervalLabel;

  /// No description provided for @recallDecrease.
  ///
  /// In en, this message translates to:
  /// **'Decrease'**
  String get recallDecrease;

  /// No description provided for @recallIncrease.
  ///
  /// In en, this message translates to:
  /// **'Increase'**
  String get recallIncrease;

  /// No description provided for @recallNone.
  ///
  /// In en, this message translates to:
  /// **'No redial'**
  String get recallNone;

  /// No description provided for @recallTimes.
  ///
  /// In en, this message translates to:
  /// **'redial(s)'**
  String get recallTimes;

  /// No description provided for @optionImmediately.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get optionImmediately;

  /// No description provided for @optionOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get optionOff;

  /// No description provided for @durationSeconds.
  ///
  /// In en, this message translates to:
  /// **'{seconds} sec'**
  String durationSeconds(int seconds);

  /// No description provided for @durationMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String durationMinutes(int minutes);

  /// No description provided for @summaryVideoCall.
  ///
  /// In en, this message translates to:
  /// **'Video call'**
  String get summaryVideoCall;

  /// No description provided for @summaryVoiceCall.
  ///
  /// In en, this message translates to:
  /// **'Voice call'**
  String get summaryVoiceCall;

  /// No description provided for @summaryRingsNow.
  ///
  /// In en, this message translates to:
  /// **'rings now'**
  String get summaryRingsNow;

  /// No description provided for @summaryRingsIn.
  ///
  /// In en, this message translates to:
  /// **'rings in {duration}'**
  String summaryRingsIn(String duration);

  /// No description provided for @summaryRedial.
  ///
  /// In en, this message translates to:
  /// **'redial {count}x'**
  String summaryRedial(int count);

  /// No description provided for @scheduleCall.
  ///
  /// In en, this message translates to:
  /// **'Schedule call'**
  String get scheduleCall;

  /// No description provided for @invalidConfigTitle.
  ///
  /// In en, this message translates to:
  /// **'Hold on, can\'t schedule yet'**
  String get invalidConfigTitle;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @callerNameRequiredShort.
  ///
  /// In en, this message translates to:
  /// **'Caller name is empty'**
  String get callerNameRequiredShort;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @progressWillCall.
  ///
  /// In en, this message translates to:
  /// **'{name} will call you'**
  String progressWillCall(String name);

  /// No description provided for @progressLockScreenHint.
  ///
  /// In en, this message translates to:
  /// **'Feel free to lock your screen, the call will still come in.'**
  String get progressLockScreenHint;

  /// No description provided for @progressRedialIn.
  ///
  /// In en, this message translates to:
  /// **'Calling again in {seconds} seconds'**
  String progressRedialIn(int seconds);

  /// No description provided for @progressAttempt.
  ///
  /// In en, this message translates to:
  /// **'Attempt {attempt} of {total}'**
  String progressAttempt(int attempt, int total);

  /// No description provided for @progressRinging.
  ///
  /// In en, this message translates to:
  /// **'Ringing...'**
  String get progressRinging;

  /// No description provided for @progressAnswerHint.
  ///
  /// In en, this message translates to:
  /// **'Pick up from the incoming call screen.'**
  String get progressAnswerHint;

  /// No description provided for @progressInCall.
  ///
  /// In en, this message translates to:
  /// **'In a call'**
  String get progressInCall;

  /// No description provided for @progressOpeningCall.
  ///
  /// In en, this message translates to:
  /// **'Opening call screen...'**
  String get progressOpeningCall;

  /// No description provided for @callDeclined.
  ///
  /// In en, this message translates to:
  /// **'You declined the call.'**
  String get callDeclined;

  /// No description provided for @callMissed.
  ///
  /// In en, this message translates to:
  /// **'Nobody picked up.'**
  String get callMissed;

  /// No description provided for @callCancelled.
  ///
  /// In en, this message translates to:
  /// **'Call cancelled.'**
  String get callCancelled;

  /// No description provided for @callEnded.
  ///
  /// In en, this message translates to:
  /// **'Call ended.'**
  String get callEnded;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @switchCamera.
  ///
  /// In en, this message translates to:
  /// **'Switch camera'**
  String get switchCamera;

  /// No description provided for @turnOffVideo.
  ///
  /// In en, this message translates to:
  /// **'Turn off video'**
  String get turnOffVideo;

  /// No description provided for @turnOnVideo.
  ///
  /// In en, this message translates to:
  /// **'Turn on video'**
  String get turnOnVideo;

  /// No description provided for @muteMic.
  ///
  /// In en, this message translates to:
  /// **'Mute microphone'**
  String get muteMic;

  /// No description provided for @unmuteMic.
  ///
  /// In en, this message translates to:
  /// **'Unmute microphone'**
  String get unmuteMic;

  /// No description provided for @endCall.
  ///
  /// In en, this message translates to:
  /// **'End call'**
  String get endCall;

  /// No description provided for @speaker.
  ///
  /// In en, this message translates to:
  /// **'Speaker'**
  String get speaker;

  /// No description provided for @switchToVideo.
  ///
  /// In en, this message translates to:
  /// **'Switch to video call'**
  String get switchToVideo;

  /// No description provided for @switchingToVideo.
  ///
  /// In en, this message translates to:
  /// **'Switching to video...'**
  String get switchingToVideo;

  /// No description provided for @nativeAccept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get nativeAccept;

  /// No description provided for @nativeDecline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get nativeDecline;

  /// No description provided for @nativeMissedCall.
  ///
  /// In en, this message translates to:
  /// **'Missed call'**
  String get nativeMissedCall;

  /// No description provided for @nativeIncomingChannel.
  ///
  /// In en, this message translates to:
  /// **'Incoming calls'**
  String get nativeIncomingChannel;

  /// No description provided for @nativeMissedChannel.
  ///
  /// In en, this message translates to:
  /// **'Missed calls'**
  String get nativeMissedChannel;

  /// No description provided for @notificationPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Notification permission'**
  String get notificationPermissionTitle;

  /// No description provided for @notificationPermissionRationale.
  ///
  /// In en, this message translates to:
  /// **'Notifications are needed to show incoming calls.'**
  String get notificationPermissionRationale;

  /// No description provided for @notificationPermissionSettings.
  ///
  /// In en, this message translates to:
  /// **'Enable notifications in Settings so calls can appear.'**
  String get notificationPermissionSettings;

  /// No description provided for @cropTitle.
  ///
  /// In en, this message translates to:
  /// **'Adjust photo'**
  String get cropTitle;

  /// No description provided for @cropDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get cropDone;

  /// No description provided for @cropCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cropCancel;

  /// No description provided for @errorUnknown.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Give it another try.'**
  String get errorUnknown;

  /// No description provided for @errorFullScreenPermission.
  ///
  /// In en, this message translates to:
  /// **'Enable the \"Full screen notification\" permission, then try again.'**
  String get errorFullScreenPermission;

  /// No description provided for @errorPermissionRequest.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t request permission.'**
  String get errorPermissionRequest;

  /// No description provided for @errorGalleryPermission.
  ///
  /// In en, this message translates to:
  /// **'Gallery access was denied.'**
  String get errorGalleryPermission;

  /// No description provided for @errorCameraPermission.
  ///
  /// In en, this message translates to:
  /// **'Camera access was denied.'**
  String get errorCameraPermission;

  /// No description provided for @errorPhotoPick.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t pick the photo.'**
  String get errorPhotoPick;

  /// No description provided for @errorPhotoCrop.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t crop the photo.'**
  String get errorPhotoCrop;

  /// No description provided for @errorCallStart.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t show the call.'**
  String get errorCallStart;

  /// No description provided for @errorCallEnd.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t end the call.'**
  String get errorCallEnd;

  /// No description provided for @errorCallEvents.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t read call status.'**
  String get errorCallEvents;

  /// No description provided for @errorAvatar.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t prepare the caller photo.'**
  String get errorAvatar;

  /// No description provided for @errorCamera.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open the camera.'**
  String get errorCamera;

  /// No description provided for @errorVideo.
  ///
  /// In en, this message translates to:
  /// **'The caller video can\'t be played.'**
  String get errorVideo;

  /// No description provided for @errorSettings.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save the setting.'**
  String get errorSettings;

  /// No description provided for @errorCallerNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Add a caller name first.'**
  String get errorCallerNameRequired;

  /// No description provided for @errorInvalidDelay.
  ///
  /// In en, this message translates to:
  /// **'Delay can\'t be negative.'**
  String get errorInvalidDelay;

  /// No description provided for @errorInvalidAutoHangup.
  ///
  /// In en, this message translates to:
  /// **'Auto hang up can\'t be negative.'**
  String get errorInvalidAutoHangup;

  /// No description provided for @errorInvalidRecallCount.
  ///
  /// In en, this message translates to:
  /// **'Redial count must be 0 to {max}.'**
  String errorInvalidRecallCount(int max);

  /// No description provided for @errorRecallIntervalTooShort.
  ///
  /// In en, this message translates to:
  /// **'The interval needs to be at least {min} seconds.'**
  String errorRecallIntervalTooShort(int min);

  /// No description provided for @backBlockedHint.
  ///
  /// In en, this message translates to:
  /// **'Want to stop? Tap Cancel.'**
  String get backBlockedHint;

  /// No description provided for @errorHistory.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t update recent names.'**
  String get errorHistory;

  /// No description provided for @recentNamesLabel.
  ///
  /// In en, this message translates to:
  /// **'Recently used'**
  String get recentNamesLabel;

  /// No description provided for @forgetName.
  ///
  /// In en, this message translates to:
  /// **'Remove {name} from history'**
  String forgetName(String name);

  /// No description provided for @callerVideoLabel.
  ///
  /// In en, this message translates to:
  /// **'Caller video'**
  String get callerVideoLabel;

  /// No description provided for @callerVideoDescription.
  ///
  /// In en, this message translates to:
  /// **'Plays after you answer the video call.'**
  String get callerVideoDescription;

  /// No description provided for @callerVideoDefault.
  ///
  /// In en, this message translates to:
  /// **'Default video'**
  String get callerVideoDefault;

  /// No description provided for @callerVideoCustom.
  ///
  /// In en, this message translates to:
  /// **'Video from gallery'**
  String get callerVideoCustom;

  /// No description provided for @pickVideo.
  ///
  /// In en, this message translates to:
  /// **'Choose video'**
  String get pickVideo;

  /// No description provided for @changeVideo.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get changeVideo;

  /// No description provided for @useDefaultVideo.
  ///
  /// In en, this message translates to:
  /// **'Use default'**
  String get useDefaultVideo;

  /// No description provided for @errorVideoPick.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t pick the video. Give it another try.'**
  String get errorVideoPick;

  /// No description provided for @chipAutoHangup.
  ///
  /// In en, this message translates to:
  /// **'Hangs up in {duration}'**
  String chipAutoHangup(String duration);

  /// No description provided for @chipRedial.
  ///
  /// In en, this message translates to:
  /// **'Redial {count}x'**
  String chipRedial(int count);

  /// No description provided for @missedVoiceCall.
  ///
  /// In en, this message translates to:
  /// **'Missed voice call'**
  String get missedVoiceCall;

  /// No description provided for @missedVideoCall.
  ///
  /// In en, this message translates to:
  /// **'Missed video call'**
  String get missedVideoCall;

  /// No description provided for @missedVoiceCalls.
  ///
  /// In en, this message translates to:
  /// **'{count} missed voice calls'**
  String missedVoiceCalls(int count);

  /// No description provided for @missedVideoCalls.
  ///
  /// In en, this message translates to:
  /// **'{count} missed video calls'**
  String missedVideoCalls(int count);

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingStart.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get onboardingStart;

  /// No description provided for @onboarding1Title.
  ///
  /// In en, this message translates to:
  /// **'Fake calls that feel real'**
  String get onboarding1Title;

  /// No description provided for @onboarding1Body.
  ///
  /// In en, this message translates to:
  /// **'A full-screen incoming call with a real ringtone and vibration, even when your phone is locked.'**
  String get onboarding1Body;

  /// No description provided for @onboarding2Title.
  ///
  /// In en, this message translates to:
  /// **'Make it yours'**
  String get onboarding2Title;

  /// No description provided for @onboarding2Body.
  ///
  /// In en, this message translates to:
  /// **'Pick the caller\'s name, photo, and video. Choose when it rings, from right now to 30 minutes later.'**
  String get onboarding2Body;

  /// No description provided for @onboarding3Title.
  ///
  /// In en, this message translates to:
  /// **'Escape like a pro'**
  String get onboarding3Title;

  /// No description provided for @onboarding3Body.
  ///
  /// In en, this message translates to:
  /// **'Auto hang up, auto redial, and missed call alerts. Nobody will ever know.'**
  String get onboarding3Body;

  /// No description provided for @splashTagline.
  ///
  /// In en, this message translates to:
  /// **'Your way out of awkward moments'**
  String get splashTagline;

  /// No description provided for @onboarding4Title.
  ///
  /// In en, this message translates to:
  /// **'One last thing'**
  String get onboarding4Title;

  /// No description provided for @onboarding4Body.
  ///
  /// In en, this message translates to:
  /// **'Allow these so your fake call can ring like the real thing.'**
  String get onboarding4Body;

  /// No description provided for @permissionNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get permissionNotificationTitle;

  /// No description provided for @permissionNotificationBody.
  ///
  /// In en, this message translates to:
  /// **'To show the incoming call and missed calls.'**
  String get permissionNotificationBody;

  /// No description provided for @permissionFullScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Full-screen calls'**
  String get permissionFullScreenTitle;

  /// No description provided for @permissionFullScreenBody.
  ///
  /// In en, this message translates to:
  /// **'So the call shows up even when your phone is locked.'**
  String get permissionFullScreenBody;

  /// No description provided for @permissionCameraTitle.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get permissionCameraTitle;

  /// No description provided for @permissionCameraBody.
  ///
  /// In en, this message translates to:
  /// **'For your face during video calls. Nothing is recorded.'**
  String get permissionCameraBody;

  /// No description provided for @permissionAllow.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get permissionAllow;

  /// No description provided for @permissionGranted.
  ///
  /// In en, this message translates to:
  /// **'Allowed'**
  String get permissionGranted;

  /// No description provided for @errorPreset.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t update saved callers.'**
  String get errorPreset;

  /// No description provided for @presetsTitle.
  ///
  /// In en, this message translates to:
  /// **'Saved callers'**
  String get presetsTitle;

  /// No description provided for @presetsSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get presetsSave;

  /// No description provided for @presetsSaved.
  ///
  /// In en, this message translates to:
  /// **'{name} saved.'**
  String presetsSaved(String name);

  /// No description provided for @presetsDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove {name}?'**
  String presetsDeleteTitle(String name);

  /// No description provided for @presetsDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'The photo and video saved with this caller will be removed too.'**
  String get presetsDeleteBody;

  /// No description provided for @presetsDelete.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get presetsDelete;

  /// No description provided for @presetsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Save callers you use often to set them up in one tap.'**
  String get presetsEmpty;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'Use phone setting'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTooltip;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @aboutVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String aboutVersion(String version);

  /// No description provided for @aboutDescription.
  ///
  /// In en, this message translates to:
  /// **'Schedule a realistic fake incoming call to escape awkward moments, or just to prank a friend.'**
  String get aboutDescription;

  /// No description provided for @aboutPrivacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get aboutPrivacyTitle;

  /// No description provided for @aboutPrivacyBody.
  ///
  /// In en, this message translates to:
  /// **'No account and nothing sent over the internet. Everything stays on your phone.'**
  String get aboutPrivacyBody;

  /// No description provided for @aboutUseTitle.
  ///
  /// In en, this message translates to:
  /// **'Use it kindly'**
  String get aboutUseTitle;

  /// No description provided for @aboutUseBody.
  ///
  /// In en, this message translates to:
  /// **'Made for fun. Please don\'t use it to deceive or harm anyone.'**
  String get aboutUseBody;

  /// No description provided for @aboutLicenses.
  ///
  /// In en, this message translates to:
  /// **'Open-source licenses'**
  String get aboutLicenses;

  /// No description provided for @aboutMadeBy.
  ///
  /// In en, this message translates to:
  /// **'Made by'**
  String get aboutMadeBy;

  /// No description provided for @settingsPreferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get settingsPreferences;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Fake Calling'**
  String get homeTitle;

  /// No description provided for @homeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your way out, one tap away'**
  String get homeSubtitle;

  /// No description provided for @coachSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get coachSkip;

  /// No description provided for @coachNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get coachNext;

  /// No description provided for @coachDone.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get coachDone;

  /// No description provided for @coachPreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'This is how it looks'**
  String get coachPreviewTitle;

  /// No description provided for @coachPreviewBody.
  ///
  /// In en, this message translates to:
  /// **'A live preview of the incoming call. Tap the photo to pick one from your gallery.'**
  String get coachPreviewBody;

  /// No description provided for @coachPresetsTitle.
  ///
  /// In en, this message translates to:
  /// **'Saved callers'**
  String get coachPresetsTitle;

  /// No description provided for @coachPresetsBody.
  ///
  /// In en, this message translates to:
  /// **'Save callers you use often, then set them up again in one tap.'**
  String get coachPresetsBody;

  /// No description provided for @coachNameTitle.
  ///
  /// In en, this message translates to:
  /// **'Who\'s calling?'**
  String get coachNameTitle;

  /// No description provided for @coachNameBody.
  ///
  /// In en, this message translates to:
  /// **'Type any name. Names you\'ve used before show up as suggestions.'**
  String get coachNameBody;

  /// No description provided for @coachTypeTitle.
  ///
  /// In en, this message translates to:
  /// **'Voice or video'**
  String get coachTypeTitle;

  /// No description provided for @coachTypeBody.
  ///
  /// In en, this message translates to:
  /// **'Pick the call type. Video calls can use your own caller video.'**
  String get coachTypeBody;

  /// No description provided for @coachTimingTitle.
  ///
  /// In en, this message translates to:
  /// **'Set the timing'**
  String get coachTimingTitle;

  /// No description provided for @coachTimingBody.
  ///
  /// In en, this message translates to:
  /// **'Choose when it rings and when it hangs up on its own.'**
  String get coachTimingBody;

  /// No description provided for @coachScheduleTitle.
  ///
  /// In en, this message translates to:
  /// **'Ready to go'**
  String get coachScheduleTitle;

  /// No description provided for @coachScheduleBody.
  ///
  /// In en, this message translates to:
  /// **'Tap here to schedule the call. Feel free to lock your phone after.'**
  String get coachScheduleBody;

  /// No description provided for @coachSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get coachSettingsTitle;

  /// No description provided for @coachSettingsBody.
  ///
  /// In en, this message translates to:
  /// **'Theme, language, and this tour live here.'**
  String get coachSettingsBody;

  /// No description provided for @settingsReplayTour.
  ///
  /// In en, this message translates to:
  /// **'Show the tour again'**
  String get settingsReplayTour;

  /// No description provided for @errorCallSchedule.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t set the call timer.'**
  String get errorCallSchedule;

  /// No description provided for @ringAtPick.
  ///
  /// In en, this message translates to:
  /// **'Pick a time'**
  String get ringAtPick;

  /// No description provided for @ringAtLabel.
  ///
  /// In en, this message translates to:
  /// **'At {time}'**
  String ringAtLabel(String time);

  /// No description provided for @ringAtPickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Ring at what time?'**
  String get ringAtPickerTitle;

  /// No description provided for @summaryRingsAt.
  ///
  /// In en, this message translates to:
  /// **'rings at {time}'**
  String summaryRingsAt(String time);

  /// No description provided for @summaryRingsTomorrowAt.
  ///
  /// In en, this message translates to:
  /// **'rings tomorrow at {time}'**
  String summaryRingsTomorrowAt(String time);

  /// No description provided for @initialDurationLabel.
  ///
  /// In en, this message translates to:
  /// **'Starting call timer'**
  String get initialDurationLabel;

  /// No description provided for @initialDurationDescription.
  ///
  /// In en, this message translates to:
  /// **'The call timer starts from here, so it looks like you\'ve been talking for a while.'**
  String get initialDurationDescription;

  /// No description provided for @initialDurationZero.
  ///
  /// In en, this message translates to:
  /// **'From 00:00'**
  String get initialDurationZero;

  /// No description provided for @permissionExactAlarmTitle.
  ///
  /// In en, this message translates to:
  /// **'On-time alarms'**
  String get permissionExactAlarmTitle;

  /// No description provided for @permissionExactAlarmBody.
  ///
  /// In en, this message translates to:
  /// **'So the call rings right on time, even after the app is closed.'**
  String get permissionExactAlarmBody;

  /// No description provided for @permissionBatteryTitle.
  ///
  /// In en, this message translates to:
  /// **'Unrestricted battery'**
  String get permissionBatteryTitle;

  /// No description provided for @permissionBatteryBody.
  ///
  /// In en, this message translates to:
  /// **'Open Battery and pick “Unrestricted”. On Xiaomi, also turn on “Autostart” on the same page.'**
  String get permissionBatteryBody;

  /// No description provided for @errorExactAlarmPermission.
  ///
  /// In en, this message translates to:
  /// **'Allow \"Alarms & reminders\" so the call rings right on time, then schedule again.'**
  String get errorExactAlarmPermission;

  /// No description provided for @permissionReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Please allow everything'**
  String get permissionReminderTitle;

  /// No description provided for @permissionReminderBody.
  ///
  /// In en, this message translates to:
  /// **'Fake Calling needs these permissions to ring on time, show up on the lock screen, and keep working after the app is closed. Without them, the app can\'t work properly.'**
  String get permissionReminderBody;

  /// No description provided for @permissionReminderConfirm.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get permissionReminderConfirm;

  /// No description provided for @settingsPermissions.
  ///
  /// In en, this message translates to:
  /// **'App permissions'**
  String get settingsPermissions;

  /// No description provided for @settingsPermissionsBody.
  ///
  /// In en, this message translates to:
  /// **'Keep all of these on so your fake calls ring on time, even when the app is closed.'**
  String get settingsPermissionsBody;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
