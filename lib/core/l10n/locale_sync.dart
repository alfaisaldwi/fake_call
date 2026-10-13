import 'package:flutter/widgets.dart';

import 'app_locale_holder.dart';

class LocaleSync extends StatelessWidget {
  final AppLocaleHolder holder;
  final Widget child;

  const LocaleSync({super.key, required this.holder, required this.child});

  @override
  Widget build(BuildContext context) {
    holder.update(Localizations.localeOf(context));
    return child;
  }
}
