import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../core/theme/app_palette.dart';

class ScheduleBar extends StatelessWidget {
  final String summary;
  final VoidCallback onSchedule;

  const ScheduleBar({
    super.key,
    required this.summary,
    required this.onSchedule,
  });

  @override
  Widget build(BuildContext context) {
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
              FilledButton.icon(
                onPressed: onSchedule,
                icon: const Icon(Icons.phone_callback),
                label: Text(AppLocalizations.of(context).scheduleCall),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
