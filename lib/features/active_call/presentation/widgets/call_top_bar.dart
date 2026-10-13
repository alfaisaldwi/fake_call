import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';

class CallTopBar extends StatelessWidget {
  static const _shadow = [Shadow(blurRadius: 6, color: Color(0x8A000000))];

  final String? callerName;
  final String? subtitle;
  final VoidCallback onBack;

  const CallTopBar({
    super.key,
    required this.onBack,
    this.callerName,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final name = callerName;
    final sub = subtitle;
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            onPressed: onBack,
            tooltip: AppLocalizations.of(context).back,
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  const _EncryptedLabel(),
                  if (name != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        shadows: _shadow,
                      ),
                    ),
                  ],
                  if (sub != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      sub,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontFeatures: [FontFeature.tabularFigures()],
                        shadows: _shadow,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class _EncryptedLabel extends StatelessWidget {
  const _EncryptedLabel();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.lock, size: 12, color: AppColors.callSecondaryText),
        const SizedBox(width: 4),
        Text(
          AppLocalizations.of(context).endToEndEncrypted,
          style: const TextStyle(
            color: AppColors.callSecondaryText,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
