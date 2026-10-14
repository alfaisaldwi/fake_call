import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/failure_messages.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/app_permission.dart';
import '../../domain/usecases/check_permissions.dart';
import '../../domain/usecases/request_permission.dart';

part 'permissions_event.dart';
part 'permissions_state.dart';

class PermissionsBloc extends Bloc<PermissionsEvent, PermissionsState> {
  final CheckPermissions checkPermissions;
  final RequestPermission requestPermission;
  final FailureMessages failureMessages;

  PermissionsBloc({
    required this.checkPermissions,
    required this.requestPermission,
    required this.failureMessages,
  }) : super(const PermissionsReady(PermissionSnapshot.unknown())) {
    on<PermissionsChecked>(_onChecked);
    on<PermissionRequested>(_onRequested);
  }

  Future<void> _onChecked(
    PermissionsChecked event,
    Emitter<PermissionsState> emit,
  ) async {
    final result = await checkPermissions(const NoParams());
    result.fold(
      (failure) => emit(
        PermissionsError(state.snapshot, message: failureMessages.of(failure)),
      ),
      (snapshot) => emit(PermissionsReady(snapshot)),
    );
  }

  Future<void> _onRequested(
    PermissionRequested event,
    Emitter<PermissionsState> emit,
  ) async {
    final result = await requestPermission(event.permission);
    result.fold(
      (failure) => emit(
        PermissionsError(state.snapshot, message: failureMessages.of(failure)),
      ),
      (snapshot) => emit(PermissionsReady(snapshot)),
    );
  }
}
