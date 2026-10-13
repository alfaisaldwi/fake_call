import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/app_language.dart';
import '../bloc/language_bloc.dart';

class LanguageMenuButton extends StatelessWidget {
  const LanguageMenuButton({super.key});

  static String _flagOf(String languageCode) =>
      languageCode == 'id' ? '🇮🇩' : '🇬🇧';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final activeCode = Localizations.localeOf(context).languageCode;
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, state) {
        return PopupMenuButton<AppLanguage>(
          tooltip: l10n.languageMenuTooltip,
          initialValue: state.language,
          position: PopupMenuPosition.under,
          onSelected: (language) =>
              context.read<LanguageBloc>().add(LanguageSelected(language)),
          itemBuilder: (_) => [
            _item(AppLanguage.system, '🌐', l10n.languageSystem, state),
            _item(
              AppLanguage.indonesian,
              '🇮🇩',
              l10n.languageIndonesian,
              state,
            ),
            _item(AppLanguage.english, '🇬🇧', l10n.languageEnglish, state),
          ],
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _flagOf(activeCode),
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    activeCode.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down, color: Colors.white),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  PopupMenuItem<AppLanguage> _item(
    AppLanguage language,
    String flag,
    String label,
    LanguageState state,
  ) {
    return PopupMenuItem(
      value: language,
      child: Row(
        children: [
          Text(flag, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(child: Text(label)),
          if (state.language == language) const Icon(Icons.check, size: 18),
        ],
      ),
    );
  }
}
