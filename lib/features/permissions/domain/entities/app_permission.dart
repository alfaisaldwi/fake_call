import 'package:equatable/equatable.dart';

enum AppPermission { notification, fullScreen, camera }

class PermissionSnapshot extends Equatable {
  final Map<AppPermission, bool> granted;

  const PermissionSnapshot(this.granted);

  const PermissionSnapshot.unknown() : granted = const {};

  bool isGranted(AppPermission permission) => granted[permission] ?? false;

  bool get allGranted => AppPermission.values.every(isGranted);

  @override
  List<Object> get props => [granted];
}
