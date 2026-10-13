import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/caller_avatar.dart';

class CallPreviewCard extends StatelessWidget {
  final String callerName;
  final String? avatarPath;
  final bool isVideoCall;
  final VoidCallback onPickPhoto;
  final VoidCallback onRemovePhoto;

  const CallPreviewCard({
    super.key,
    required this.callerName,
    required this.avatarPath,
    required this.isVideoCall,
    required this.onPickPhoto,
    required this.onRemovePhoto,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final name = callerName.trim();
    final hasAvatar = avatarPath?.isNotEmpty ?? false;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.callSurface, AppColors.callBackground],
        ),
      ),
      child: Column(
        children: [
          const _PreviewLabel(),
          const SizedBox(height: 18),
          _PhotoButton(
            callerName: name,
            avatarPath: avatarPath,
            onTap: onPickPhoto,
          ),
          const SizedBox(height: 14),
          Text(
            name.isEmpty ? l10n.callerNamePlaceholder : name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: name.isEmpty ? Colors.white38 : Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isVideoCall ? Icons.videocam : Icons.call,
                size: 16,
                color: AppColors.callSecondaryText,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  isVideoCall ? l10n.incomingVideoCall : l10n.incomingVoiceCall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.callSecondaryText),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _PhotoActions(
            hasAvatar: hasAvatar,
            onPick: onPickPhoto,
            onRemove: onRemovePhoto,
          ),
        ],
      ),
    );
  }
}

class _PreviewLabel extends StatelessWidget {
  const _PreviewLabel();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            l10n.previewLabel,
            style: const TextStyle(
              color: AppColors.callSecondaryText,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 12),
        const Spacer(),
        const Icon(Icons.lock, size: 12, color: AppColors.callSecondaryText),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            l10n.endToEndEncrypted,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.callSecondaryText,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}

class _PhotoButton extends StatelessWidget {
  final String callerName;
  final String? avatarPath;
  final VoidCallback onTap;

  const _PhotoButton({
    required this.callerName,
    required this.avatarPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: AppLocalizations.of(context).pickPhotoSemantic,
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white24, width: 1.5),
              ),
              child: CallerAvatar(
                callerName: callerName,
                avatarPath: avatarPath,
                radius: 48,
              ),
            ),
            Positioned(
              right: -2,
              bottom: -2,
              child: Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: AppColors.green,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.callBackground, width: 3),
                ),
                child: const Icon(
                  Icons.photo_camera,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PhotoActions extends StatelessWidget {
  final bool hasAvatar;
  final VoidCallback onPick;
  final VoidCallback onRemove;

  const _PhotoActions({
    required this.hasAvatar,
    required this.onPick,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final style = TextButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: Colors.white.withValues(alpha: 0.08),
      shape: const StadiumBorder(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
    );
    return Wrap(
      spacing: 8,
      alignment: WrapAlignment.center,
      children: [
        TextButton.icon(
          style: style,
          onPressed: onPick,
          icon: const Icon(Icons.image_outlined, size: 18),
          label: Text(hasAvatar ? l10n.changePhoto : l10n.pickPhotoFromGallery),
        ),
        if (hasAvatar)
          TextButton.icon(
            style: style,
            onPressed: onRemove,
            icon: const Icon(Icons.delete_outline, size: 18),
            label: Text(l10n.removePhoto),
          ),
      ],
    );
  }
}
