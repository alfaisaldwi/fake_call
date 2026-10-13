part of 'language_bloc.dart';

sealed class LanguageEvent extends Equatable {
  const LanguageEvent();

  @override
  List<Object> get props => [];
}

final class LanguageStarted extends LanguageEvent {
  const LanguageStarted();
}

final class LanguageSelected extends LanguageEvent {
  final AppLanguage language;

  const LanguageSelected(this.language);

  @override
  List<Object> get props => [language];
}
