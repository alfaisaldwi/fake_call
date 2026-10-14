import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/l10n/app_locale_holder.dart';
import '../../../../core/theme/app_appearance_holder.dart';

abstract class CallerAvatarLocalDataSource {
  Future<String?> pickFromGallery();
}

class CallerAvatarLocalDataSourceImpl implements CallerAvatarLocalDataSource {
  static const _pickDimension = 1600.0;
  static const _avatarDimension = 512;
  static const _deniedCodes = {'photo_access_denied', 'camera_access_denied'};

  final ImagePicker imagePicker;
  final ImageCropper imageCropper;
  final AppLocaleHolder localeHolder;
  final AppAppearanceHolder appearance;

  CallerAvatarLocalDataSourceImpl({
    required this.imagePicker,
    required this.imageCropper,
    required this.localeHolder,
    required this.appearance,
  });

  @override
  Future<String?> pickFromGallery() async {
    final picked = await _pick();
    if (picked == null) return null;
    return _crop(picked);
  }

  Future<String?> _pick() async {
    try {
      final file = await imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: _pickDimension,
        maxHeight: _pickDimension,
        requestFullMetadata: false,
      );
      return file?.path;
    } on PlatformException catch (e) {
      if (_deniedCodes.contains(e.code)) {
        throw PermissionException(
          FailureReason.galleryPermissionDenied,
          e.message,
        );
      }
      throw MediaException(FailureReason.photoPickFailed, e.message);
    }
  }

  Future<String?> _crop(String sourcePath) async {
    final strings = localeHolder.strings;
    final palette = appearance.palette;
    try {
      final cropped = await imageCropper.cropImage(
        sourcePath: sourcePath,
        maxWidth: _avatarDimension,
        maxHeight: _avatarDimension,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 85,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: strings.cropTitle,
            toolbarColor: palette.background,
            statusBarLight: !appearance.isDark,
            navBarLight: !appearance.isDark,
            toolbarWidgetColor: palette.textPrimary,
            backgroundColor: palette.background,
            dimmedLayerColor: palette.background.withValues(alpha: 0.82),
            cropFrameColor: palette.primary,
            activeControlsWidgetColor: palette.primary,
            cropStyle: CropStyle.circle,
            lockAspectRatio: true,
            hideBottomControls: true,
            showCropGrid: false,
          ),
          IOSUiSettings(
            title: strings.cropTitle,
            doneButtonTitle: strings.cropDone,
            cancelButtonTitle: strings.cropCancel,
            cropStyle: CropStyle.circle,
            aspectRatioLockEnabled: true,
            aspectRatioPickerButtonHidden: true,
            resetAspectRatioEnabled: false,
          ),
        ],
      );
      return cropped?.path;
    } on PlatformException catch (e) {
      throw MediaException(FailureReason.photoCropFailed, e.message);
    }
  }
}
