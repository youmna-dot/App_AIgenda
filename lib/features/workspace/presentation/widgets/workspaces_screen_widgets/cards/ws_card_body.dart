// lib/features/workspace/presentation/widgets/workspaces_screen_widgets/cards/ws_card_body.dart
import 'package:ajenda_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_values.dart';
import '../../../../../workspace/data/models/workspace_model.dart';
import 'ws_card_header.dart';
import 'ws_card_info.dart';

class WsCardBody extends StatelessWidget {
  final WorkspaceModel workspace;
  final Color color;
  final String emoji;
  final VoidCallback onMoreTap;

  const WsCardBody({
    super.key,
    required this.workspace,
    required this.color,
    required this.emoji,
    required this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppValues.radiusXl),
        border: Border.all(color: color.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.12),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WsCardHeader(
            color: color,
            emoji: emoji,
            isOwner: workspace.isOwnedByCurrentUser,
            onMoreTap: onMoreTap,
          ),
          Expanded(
            child: WsCardInfo(workspace: workspace, color: color),
          ),
        ],
      ),
    );
  }
}