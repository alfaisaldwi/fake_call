import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../l10n/app_localizations.dart';

class CallerVideoPicker extends StatelessWidget {
  final String? videoPath;
  final VoidCallback onPick;
  final VoidCallback onUseDefault;

  const CallerVideoPicker({
    super.key,
    required this.videoPath,
    required this.onPick,
    required this.onUseDefault,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final path = videoPath;
    final isCustom = path != null && path.isNotEmpty;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.palette.background,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isCustom
                  ? context.palette.primary
                  : context.palette.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isCustom ? Icons.movie : Icons.movie_outlined,
              color: isCustom ? Colors.white : context.palette.textSecondary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isCustom ? l10n.callerVideoCustom : l10n.callerVideoDefault,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (isCustom)
                  Text(
                    path.split('/').last,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodySmall?.copyWith(
                      color: context.palette.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          if (isCustom)
            TextButton(
              onPressed: onUseDefault,
              child: Text(l10n.useDefaultVideo),
            ),
          TextButton(
            onPressed: onPick,
            child: Text(isCustom ? l10n.changeVideo : l10n.pickVideo),
          ),
        ],
      ),
    );
  }
}
