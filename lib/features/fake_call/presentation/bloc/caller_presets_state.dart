part of 'caller_presets_bloc.dart';

sealed class CallerPresetsState extends Equatable {
  final List<CallerPreset> presets;

  const CallerPresetsState(this.presets);

  @override
  List<Object?> get props => [presets];
}

final class CallerPresetsLoaded extends CallerPresetsState {
  const CallerPresetsLoaded(super.presets);
}

final class CallerPresetSaved extends CallerPresetsState {
  final String name;

  const CallerPresetSaved(super.presets, {required this.name});

  @override
  List<Object?> get props => [presets, name];
}

final class CallerPresetsError extends CallerPresetsState {
  final String message;

  const CallerPresetsError(super.presets, {required this.message});

  @override
  List<Object?> get props => [presets, message];
}
