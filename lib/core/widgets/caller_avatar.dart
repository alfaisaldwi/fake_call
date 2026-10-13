import 'dart:io';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

ImageProvider? callerAvatarImage(String? path) {
  if (path == null || path.isEmpty) return null;
  if (path.startsWith('http://') || path.startsWith('https://')) {
    return NetworkImage(path);
  }
  return FileImage(File(path));
}

class CallerAvatar extends StatelessWidget {
  final String callerName;
  final String? avatarPath;
  final double radius;

  const CallerAvatar({
    super.key,
    required this.callerName,
    required this.avatarPath,
    this.radius = 56,
  });

  @override
  Widget build(BuildContext context) {
    final name = callerName.trim();
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.callSurface,
      foregroundImage: callerAvatarImage(avatarPath),
      onForegroundImageError: avatarPath == null ? null : (_, _) {},
      child: name.isEmpty
          ? Icon(Icons.person, size: radius * 1.1, color: Colors.white70)
          : Text(
              name[0].toUpperCase(),
              style: TextStyle(fontSize: radius * 0.8, color: Colors.white),
            ),
    );
  }
}
