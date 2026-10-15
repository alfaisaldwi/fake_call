part of 'app_update_bloc.dart';

sealed class AppUpdateEvent extends Equatable {
  const AppUpdateEvent();

  @override
  List<Object> get props => [];
}

final class AppUpdateCheckRequested extends AppUpdateEvent {
  final bool silent;

  const AppUpdateCheckRequested({this.silent = false});

  @override
  List<Object> get props => [silent];
}

final class AppUpdateStartRequested extends AppUpdateEvent {
  const AppUpdateStartRequested();
}
