import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/app_info_bloc.dart';

class MadeByFooter extends StatelessWidget {
  const MadeByFooter({super.key});

  @override
  Widget build(BuildContext context) {
    // final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset('assets/img/elumi.png', width: 28, height: 28),
            ),
            const SizedBox(width: 8),
            // Text(
            //   'Elumi',
            //   style: textTheme.titleMedium?.copyWith(
            //     fontWeight: FontWeight.w600,
            //     letterSpacing: 0.2,
            //   ),
            // ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          '© ${DateTime.now().year} Elumi',
          style: textTheme.labelSmall?.copyWith(color: palette.textSecondary),
        ),
        BlocBuilder<AppInfoBloc, AppInfoState>(
          builder: (context, state) => Text(
            state is AppInfoLoaded
                ? AppLocalizations.of(context).aboutVersion(
                    '${state.info.version} (${state.info.buildNumber})',
                  )
                : '',
            style: textTheme.labelSmall?.copyWith(color: palette.textSecondary),
          ),
        ),
      ],
    );
  }
}
