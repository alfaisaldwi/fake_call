part of 'caller_presets_bloc.dart';

sealed class CallerPresetsEvent extends Equatable {
  const CallerPresetsEvent();

  @override
  List<Object> get props => [];
}

final class CallerPresetsRequested extends CallerPresetsEvent {
  const CallerPresetsRequested();
}

final class CallerPresetSaveRequested extends CallerPresetsEvent {
  final CallConfig config;

  const CallerPresetSaveRequested(this.config);

  @override
  List<Object> get props => [config];
}

final class CallerPresetDeleteRequested extends CallerPresetsEvent {
  final String id;

  const CallerPresetDeleteRequested(this.id);

  @override
  List<Object> get props => [id];
}
