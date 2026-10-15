import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/failure_messages.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/app_update.dart';
import '../../domain/usecases/check_app_update.dart';
import '../../domain/usecases/start_app_update.dart';

part 'app_update_event.dart';
part 'app_update_state.dart';

class AppUpdateBloc extends Bloc<AppUpdateEvent, AppUpdateState> {
  final CheckAppUpdate checkAppUpdate;
  final StartAppUpdate startAppUpdate;
  final FailureMessages failureMessages;

  AppUpdateBloc({
    required this.checkAppUpdate,
    required this.startAppUpdate,
    required this.failureMessages,
  }) : super(const AppUpdateState()) {
    on<AppUpdateCheckRequested>(_onCheckRequested);
    on<AppUpdateStartRequested>(_onStartRequested);
  }

  Future<void> _onCheckRequested(
    AppUpdateCheckRequested event,
    Emitter<AppUpdateState> emit,
  ) async {
    if (state.isBusy) return;
    emit(state.copyWith(isBusy: true, clearMessage: true));
    final result = await checkAppUpdate(const NoParams());
    result.fold(
      (failure) => emit(
        state.copyWith(
          isBusy: false,
          message: event.silent ? null : failureMessages.of(failure),
        ),
      ),
      (availability) => emit(
        state.copyWith(
          isBusy: false,
          availability: availability,
          isUpToDateNotice:
              !event.silent && availability == AppUpdateAvailability.upToDate,
        ),
      ),
    );
  }

  Future<void> _onStartRequested(
    AppUpdateStartRequested event,
    Emitter<AppUpdateState> emit,
  ) async {
    if (state.isBusy) return;
    emit(state.copyWith(isBusy: true, clearMessage: true));
    final result = await startAppUpdate(const NoParams());
    result.fold(
      (failure) => emit(
        state.copyWith(isBusy: false, message: failureMessages.of(failure)),
      ),
      (_) => emit(state.copyWith(isBusy: false)),
    );
  }
}
