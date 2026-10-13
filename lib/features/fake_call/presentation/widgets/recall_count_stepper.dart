import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';

class RecallCountStepper extends StatelessWidget {
  final int count;
  final int max;
  final ValueChanged<int> onChanged;

  const RecallCountStepper({
    super.key,
    required this.count,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _StepButton(
            icon: Icons.remove,
            tooltip: l10n.recallDecrease,
            onPressed: count > 0 ? () => onChanged(count - 1) : null,
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  '$count',
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: count == 0
                        ? AppColors.textSecondary
                        : AppColors.teal,
                  ),
                ),
                Text(
                  count == 0 ? l10n.recallNone : l10n.recallTimes,
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          _StepButton(
            icon: Icons.add,
            tooltip: l10n.recallIncrease,
            onPressed: count < max ? () => onChanged(count + 1) : null,
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  const _StepButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      tooltip: tooltip,
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.teal,
        disabledBackgroundColor: AppColors.surface.withValues(alpha: 0.6),
        disabledForegroundColor: AppColors.outline,
        fixedSize: const Size.square(44),
      ),
      icon: Icon(icon),
    );
  }
}
