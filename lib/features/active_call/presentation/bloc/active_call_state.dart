part of 'active_call_bloc.dart';

sealed class ActiveCallState extends Equatable {
  const ActiveCallState();

  @override
  List<Object?> get props => [];
}

final class ActiveCallInitial extends ActiveCallState {
  const ActiveCallInitial();
}

final class ActiveCallInProgress extends ActiveCallState {
  final bool isVideoMode;
  final CallMedia? media;
  final bool isMediaLoading;
  final Duration elapsed;
  final bool isCameraOn;
  final bool isMuted;
  final bool isSpeakerOn;

  const ActiveCallInProgress({
    required this.isVideoMode,
    this.media,
    this.isMediaLoading = false,
    this.elapsed = Duration.zero,
    this.isCameraOn = true,
    this.isMuted = false,
    this.isSpeakerOn = false,
  });

  bool get canControlCamera => media != null && !isMediaLoading;

  ActiveCallInProgress copyWith({
    bool? isVideoMode,
    CallMedia? media,
    bool clearMedia = false,
    bool? isMediaLoading,
    Duration? elapsed,
    bool? isCameraOn,
    bool? isMuted,
    bool? isSpeakerOn,
  }) {
    return ActiveCallInProgress(
      isVideoMode: isVideoMode ?? this.isVideoMode,
      media: clearMedia ? null : media ?? this.media,
      isMediaLoading: isMediaLoading ?? this.isMediaLoading,
      elapsed: elapsed ?? this.elapsed,
      isCameraOn: isCameraOn ?? this.isCameraOn,
      isMuted: isMuted ?? this.isMuted,
      isSpeakerOn: isSpeakerOn ?? this.isSpeakerOn,
    );
  }

  @override
  List<Object?> get props => [
    isVideoMode,
    media,
    isMediaLoading,
    elapsed,
    isCameraOn,
    isMuted,
    isSpeakerOn,
  ];
}

final class ActiveCallStoppedState extends ActiveCallState {
  const ActiveCallStoppedState();
}

final class ActiveCallError extends ActiveCallState {
  final String message;

  const ActiveCallError(this.message);

  @override
  List<Object?> get props => [message];
}
