enum AppLanguage {
  system(null),
  indonesian('id'),
  english('en');

  final String? languageCode;

  const AppLanguage(this.languageCode);
}
