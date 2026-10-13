import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';

class CallerNameSuggestions extends StatelessWidget {
  final List<String> names;
  final ValueChanged<String> onSelected;
  final ValueChanged<String> onRemoved;

  const CallerNameSuggestions({
    super.key,
    required this.names,
    required this.onSelected,
    required this.onRemoved,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return TextFieldTapRegion(
      child: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.history,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 6),
                Text(
                  l10n.recentNamesLabel,
                  style: Theme.of(context).textTheme.labelMedium
                      ?.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final name in names)
                  InputChip(
                    label: Text(name),
                    onPressed: () => onSelected(name),
                    onDeleted: () => onRemoved(name),
                    deleteIcon: const Icon(Icons.close, size: 16),
                    deleteButtonTooltipMessage: l10n.forgetName(name),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
