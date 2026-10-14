part of 'permissions_bloc.dart';

sealed class PermissionsEvent extends Equatable {
  const PermissionsEvent();

  @override
  List<Object> get props => [];
}

final class PermissionsChecked extends PermissionsEvent {
  const PermissionsChecked();
}

final class PermissionRequested extends PermissionsEvent {
  final AppPermission permission;

  const PermissionRequested(this.permission);

  @override
  List<Object> get props => [permission];
}
