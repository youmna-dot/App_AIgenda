// lib/core/widgets/dynamic_icon.dart

import 'package:flutter/material.dart';
import '../theme/app_icons.dart';
import '../theme/app_colors.dart';

class DynamicIcon extends StatelessWidget {
  final String iconCode;
  final String id;
  final double size;
  final bool showBackground;

  const DynamicIcon({
    super.key,
    required this.iconCode,
    required this.id,
    this.size = 44,
    this.showBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    final color   = AppColors.fromId(id);
    final display = AppIcons.displayFromCode(iconCode);

    final child = Text(
      display,
      style: TextStyle(fontSize: size * 0.5),
    );

    if (!showBackground) return child;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(size * 0.25),
      ),
      alignment: Alignment.center,
      child: child,
    );
  }
}