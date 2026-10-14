import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';

class SecondsOptionSelector extends StatelessWidget {
  final List<int> options;
  final int selected;
  final ValueChanged<int> onChanged;
  final String? zeroLabel;

  const SecondsOptionSelector({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
    this.zeroLabel,
  });

  static String label(AppLocalizations l10n, int seconds, {String? zeroLabel}) {
    if (seconds == 0) return zeroLabel ?? l10n.optionImmediately;
    if (seconds >= 60 && seconds % 60 == 0) {
      return l10n.durationMinutes(seconds ~/ 60);
    }
    return l10n.durationSeconds(seconds);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final seconds in options)
          ChoiceChip(
            label: Text(
              label(l10n, seconds, zeroLabel: zeroLabel),
              style: selected == seconds
                  ? const TextStyle(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w600,
                    )
                  : null,
            ),
            selected: selected == seconds,
            showCheckmark: false,
            onSelected: (_) => onChanged(seconds),
          ),
      ],
    );
  }
}
