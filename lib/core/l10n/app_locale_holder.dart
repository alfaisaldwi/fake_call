import 'dart:ui';

import '../../l10n/app_localizations.dart';

class AppLocaleHolder {
  static const fallback = Locale('en');

  Locale _locale;

  AppLocaleHolder([Locale? initial])
    : _locale = resolve(initial ?? PlatformDispatcher.instance.locale);

  static Locale resolve(Locale? locale) {
    return AppLocalizations.supportedLocales.firstWhere(
      (supported) => supported.languageCode == locale?.languageCode,
      orElse: () => fallback,
    );
  }

  Locale get locale => _locale;

  AppLocalizations get strings => lookupAppLocalizations(_locale);

  void update(Locale locale) => _locale = resolve(locale);
}
