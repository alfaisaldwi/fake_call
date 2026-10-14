import 'package:fake_calling/features/active_call/data/models/call_media_model.dart';
import 'package:fake_calling/features/active_call/domain/entities/call_media.dart';
import 'package:flutter_test/flutter_test.dart';

CallMedia _media(double aspectRatio) => CallMedia(
  cameraViewId: 1,
  cameraAspectRatio: 4 / 3,
  remoteVideoViewId: 2,
  remoteVideoAspectRatio: aspectRatio,
);

void main() {
  test('video tegak dianggap portrait', () {
    expect(_media(9 / 16).isRemoteVideoPortrait, isTrue);
    expect(_media(3 / 4).isRemoteVideoPortrait, isTrue);
  });

  test('video landscape dan persegi memakai latar blur', () {
    expect(_media(16 / 9).isRemoteVideoPortrait, isFalse);
    expect(_media(1).isRemoteVideoPortrait, isFalse);
  });

  test('rotasi ikut tersimpan di model', () {
    const model = CallMediaModel(
      cameraViewId: 1,
      cameraAspectRatio: 4 / 3,
      remoteVideoViewId: 2,
      remoteVideoAspectRatio: 9 / 16,
      remoteVideoQuarterTurns: 1,
    );

    final restored = CallMediaModel.fromJson(model.toJson());

    expect(restored.remoteVideoQuarterTurns, 1);
    expect(restored, model);
  });
}
