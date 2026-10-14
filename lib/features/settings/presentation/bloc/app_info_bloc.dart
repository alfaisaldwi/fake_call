import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/failure_messages.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/app_info.dart';
import '../../domain/usecases/get_app_info.dart';

part 'app_info_event.dart';
part 'app_info_state.dart';

class AppInfoBloc extends Bloc<AppInfoEvent, AppInfoState> {
  final GetAppInfo getAppInfo;
  final FailureMessages failureMessages;

  AppInfoBloc({required this.getAppInfo, required this.failureMessages})
    : super(const AppInfoLoading()) {
    on<AppInfoRequested>(_onRequested);
  }

  Future<void> _onRequested(
    AppInfoRequested event,
    Emitter<AppInfoState> emit,
  ) async {
    final result = await getAppInfo(const NoParams());
    result.fold(
      (failure) => emit(AppInfoError(failureMessages.of(failure))),
      (info) => emit(AppInfoLoaded(info)),
    );
  }
}
