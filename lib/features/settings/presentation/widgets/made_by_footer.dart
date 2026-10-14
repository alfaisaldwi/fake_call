import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../l10n/app_localizations.dart';

class MadeByFooter extends StatelessWidget {
  const MadeByFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Text(
          l10n.aboutMadeBy,
          style: textTheme.labelMedium?.copyWith(color: palette.textSecondary),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset('assets/img/elumi.png', width: 28, height: 28),
            ),
            const SizedBox(width: 8),
            Text(
              'Elumi',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          '© ${DateTime.now().year} Elumi',
          style: textTheme.labelSmall?.copyWith(color: palette.textSecondary),
        ),
      ],
    );
  }
}
