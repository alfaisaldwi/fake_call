import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/app_info_bloc.dart';

class SettingsHeader extends StatelessWidget {
  const SettingsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                blurRadius: 28,
                spreadRadius: -6,
                offset: const Offset(0, 12),
                color: palette.primary.withValues(alpha: 0.18),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.asset(
              'assets/img/launcher/launcher_icon.png',
              width: 84,
              height: 84,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          l10n.appTitle,
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        BlocBuilder<AppInfoBloc, AppInfoState>(
          builder: (context, state) => AnimatedOpacity(
            opacity: state is AppInfoLoaded ? 1 : 0,
            duration: const Duration(milliseconds: 250),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: palette.primaryTint,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                state is AppInfoLoaded
                    ? l10n.aboutVersion(
                        '${state.info.version} (${state.info.buildNumber})',
                      )
                    : ' ',
                style: textTheme.labelMedium?.copyWith(
                  color: palette.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            l10n.aboutDescription,
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(
              color: palette.textSecondary,
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }
}
