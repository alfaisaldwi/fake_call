part of 'permissions_bloc.dart';

sealed class PermissionsState extends Equatable {
  final PermissionSnapshot snapshot;

  const PermissionsState(this.snapshot);

  @override
  List<Object> get props => [snapshot];
}

final class PermissionsReady extends PermissionsState {
  const PermissionsReady(super.snapshot);
}

final class PermissionsError extends PermissionsState {
  final String message;

  const PermissionsError(super.snapshot, {required this.message});

  @override
  List<Object> get props => [snapshot, message];
}
