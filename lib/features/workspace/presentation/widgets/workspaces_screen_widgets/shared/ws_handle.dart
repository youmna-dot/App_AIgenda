// lib/features/workspace/presentation/widgets/workspaces_screen_widgets/shared/ws_handle.dart
import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_colors.dart';

class WsHandle extends StatelessWidget {
  const WsHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 36,
        height: 4,
        decoration: BoxDecoration(
          color: AppColors.cardBorder,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}