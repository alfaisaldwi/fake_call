part of 'app_info_bloc.dart';

sealed class AppInfoState extends Equatable {
  const AppInfoState();

  @override
  List<Object> get props => [];
}

final class AppInfoLoading extends AppInfoState {
  const AppInfoLoading();
}

final class AppInfoLoaded extends AppInfoState {
  final AppInfo info;

  const AppInfoLoaded(this.info);

  @override
  List<Object> get props => [info];
}

final class AppInfoError extends AppInfoState {
  final String message;

  const AppInfoError(this.message);

  @override
  List<Object> get props => [message];
}
