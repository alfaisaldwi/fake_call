import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_theme.dart';

class ScheduleBar extends StatelessWidget {
  final String summary;
  final VoidCallback onSchedule;
  final VoidCallback onPreview;

  const ScheduleBar({
    super.key,
    required this.summary,
    required this.onSchedule,
    required this.onPreview,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.palette.surface,
        boxShadow: [
          BoxShadow(
            blurRadius: 16,
            offset: Offset(0, -4),
            color: Color(0x0A000000),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.schedule,
                    size: 16,
                    color: context.palette.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      summary,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall
                          ?.copyWith(color: context.palette.textSecondary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: onPreview,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 56),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      foregroundColor: context.palette.primary,
                      side: BorderSide(color: context.palette.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    icon: const Icon(Icons.play_circle_outline),
                    label: Text(l10n.previewCall),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: onSchedule,
                      style: AppTheme.brandButton(null),
                      icon: const Icon(Icons.phone_callback),
                      label: Text(
                        l10n.scheduleCall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
