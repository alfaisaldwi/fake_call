import '../../l10n/app_localizations.dart';
import '../error/failures.dart';
import 'app_locale_holder.dart';

class FailureMessages {
  final AppLocaleHolder localeHolder;

  const FailureMessages(this.localeHolder);

  String of(Failure failure) => describe(failure, localeHolder.strings);

  static String describe(Failure failure, AppLocalizations l10n) {
    final limit = failure.limit ?? 0;
    return switch (failure.reason) {
      FailureReason.unknown => l10n.errorUnknown,
      FailureReason.fullScreenPermissionRequired =>
        l10n.errorFullScreenPermission,
      FailureReason.permissionRequestFailed => l10n.errorPermissionRequest,
      FailureReason.galleryPermissionDenied => l10n.errorGalleryPermission,
      FailureReason.cameraPermissionDenied => l10n.errorCameraPermission,
      FailureReason.photoPickFailed => l10n.errorPhotoPick,
      FailureReason.photoCropFailed => l10n.errorPhotoCrop,
      FailureReason.videoPickFailed => l10n.errorVideoPick,
      FailureReason.callStartFailed => l10n.errorCallStart,
      FailureReason.callScheduleFailed => l10n.errorCallSchedule,
      FailureReason.callEndFailed => l10n.errorCallEnd,
      FailureReason.callEventsFailed => l10n.errorCallEvents,
      FailureReason.avatarPreparationFailed => l10n.errorAvatar,
      FailureReason.cameraUnavailable => l10n.errorCamera,
      FailureReason.videoUnavailable => l10n.errorVideo,
      FailureReason.settingsFailed => l10n.errorSettings,
      FailureReason.historyFailed => l10n.errorHistory,
      FailureReason.presetFailed => l10n.errorPreset,
      FailureReason.callerNameRequired => l10n.errorCallerNameRequired,
      FailureReason.invalidDelay => l10n.errorInvalidDelay,
      FailureReason.invalidAutoHangup => l10n.errorInvalidAutoHangup,
      FailureReason.invalidRecallCount => l10n.errorInvalidRecallCount(limit),
      FailureReason.recallIntervalTooShort => l10n.errorRecallIntervalTooShort(
        limit,
      ),
    };
  }
}
