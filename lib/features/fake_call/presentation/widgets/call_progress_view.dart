import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/duration_format.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/call_config.dart';
import 'progress_avatar_ring.dart';
import 'seconds_option_selector.dart';

class CallProgressView extends StatelessWidget {
  final CallConfig config;
  final String title;
  final String subtitle;
  final int? remainingSeconds;
  final int? totalSeconds;
  final VoidCallback onCancel;

  const CallProgressView({
    super.key,
    required this.config,
    required this.title,
    required this.subtitle,
    required this.onCancel,
    this.remainingSeconds,
    this.totalSeconds,
  });

  double? get _progress {
    final remaining = remainingSeconds;
    final total = totalSeconds;
    if (remaining == null) return null;
    if (total == null || total <= 0) return 0;
    return remaining / total;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final remaining = remainingSeconds;
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.greenTint, AppColors.background],
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ProgressAvatarRing(
                        callerName: config.callerName,
                        avatarPath: config.callerAvatarPath,
                        progress: _progress,
                      ),
                      const SizedBox(height: 28),
                      if (remaining != null) ...[
                        Text(
                          Duration(seconds: remaining).toCallTimer(),
                          style: textTheme.displayMedium?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        subtitle,
                        textAlign: TextAlign.center,
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _ConfigChips(config: config),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),
                  foregroundColor: AppColors.error,
                  backgroundColor: AppColors.surface,
                  side: const BorderSide(color: AppColors.outline),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: onCancel,
                icon: const Icon(Icons.close),
                label: Text(AppLocalizations.of(context).cancel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConfigChips extends StatelessWidget {
  final CallConfig config;

  const _ConfigChips({required this.config});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: [
        _InfoChip(
          icon: config.isVideoCall ? Icons.videocam : Icons.call,
          label: config.isVideoCall
              ? l10n.summaryVideoCall
              : l10n.summaryVoiceCall,
        ),
        if (config.hasAutoHangup)
          _InfoChip(
            icon: Icons.timer_outlined,
            label: l10n.chipAutoHangup(
              SecondsOptionSelector.label(l10n, config.autoHangupSeconds),
            ),
          ),
        if (config.autoRecallCount > 0)
          _InfoChip(
            icon: Icons.replay,
            label: l10n.chipRedial(config.autoRecallCount),
          ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.outline),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.teal),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
