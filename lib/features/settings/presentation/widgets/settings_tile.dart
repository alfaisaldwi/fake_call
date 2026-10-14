import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String? value;
  final VoidCallback? onTap;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textTheme = Theme.of(context).textTheme;
    final current = value;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 19, color: color),
            ),
            const SizedBox(width: 14),
            Flexible(
              flex: 3,
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: current == null
                  ? const SizedBox.shrink()
                  : Text(
                      current,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                      style: textTheme.bodyMedium?.copyWith(
                        color: palette.textSecondary,
                      ),
                    ),
            ),
            if (onTap != null) ...[
              const SizedBox(width: 4),
              Icon(Icons.chevron_right, color: palette.textSecondary),
            ],
          ],
        ),
      ),
    );
  }
}
