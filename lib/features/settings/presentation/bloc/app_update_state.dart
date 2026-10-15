part of 'app_update_bloc.dart';

class AppUpdateState extends Equatable {
  final AppUpdateAvailability? availability;
  final bool isBusy;
  final bool isUpToDateNotice;
  final String? message;

  const AppUpdateState({
    this.availability,
    this.isBusy = false,
    this.isUpToDateNotice = false,
    this.message,
  });

  bool get isAvailable => availability == AppUpdateAvailability.available;

  bool get isSupported => availability != AppUpdateAvailability.unsupported;

  AppUpdateState copyWith({
    AppUpdateAvailability? availability,
    bool? isBusy,
    bool isUpToDateNotice = false,
    String? message,
    bool clearMessage = false,
  }) {
    return AppUpdateState(
      availability: availability ?? this.availability,
      isBusy: isBusy ?? this.isBusy,
      isUpToDateNotice: isUpToDateNotice,
      message: clearMessage ? null : message,
    );
  }

  @override
  List<Object?> get props => [availability, isBusy, isUpToDateNotice, message];
}
