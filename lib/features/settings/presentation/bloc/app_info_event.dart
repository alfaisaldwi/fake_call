part of 'app_info_bloc.dart';

sealed class AppInfoEvent extends Equatable {
  const AppInfoEvent();

  @override
  List<Object> get props => [];
}

final class AppInfoRequested extends AppInfoEvent {
  const AppInfoRequested();
}
