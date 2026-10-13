part of 'language_bloc.dart';

sealed class LanguageState extends Equatable {
  final AppLanguage language;

  const LanguageState(this.language);

  Locale? get locale {
    final code = language.languageCode;
    return code == null ? null : Locale(code);
  }

  @override
  List<Object> get props => [language];
}

final class LanguageReady extends LanguageState {
  const LanguageReady(super.language);
}

final class LanguageError extends LanguageState {
  final String message;

  const LanguageError(super.language, {required this.message});

  @override
  List<Object> get props => [language, message];
}
