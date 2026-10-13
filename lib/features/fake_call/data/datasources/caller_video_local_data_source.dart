import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/error/exceptions.dart';

abstract class CallerVideoLocalDataSource {
  Future<String?> pickFromGallery();
}

class CallerVideoLocalDataSourceImpl implements CallerVideoLocalDataSource {
  static const _deniedCodes = {'photo_access_denied', 'camera_access_denied'};

  final ImagePicker imagePicker;

  CallerVideoLocalDataSourceImpl({required this.imagePicker});

  @override
  Future<String?> pickFromGallery() async {
    try {
      final file = await imagePicker.pickVideo(source: ImageSource.gallery);
      return file?.path;
    } on PlatformException catch (e) {
      if (_deniedCodes.contains(e.code)) {
        throw PermissionException(
          FailureReason.galleryPermissionDenied,
          e.message,
        );
      }
      throw MediaException(FailureReason.videoPickFailed, e.message);
    }
  }
}
