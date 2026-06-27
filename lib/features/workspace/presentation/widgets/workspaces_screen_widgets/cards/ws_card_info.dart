// lib/features/workspace/presentation/widgets/workspaces_screen_widgets/cards/ws_card_info.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../workspace/data/models/workspace_model.dart';

class WsCardInfo extends StatelessWidget {
  final WorkspaceModel workspace;
  final Color color;

  const WsCardInfo({super.key, required this.workspace, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            workspace.name,
            style: GoogleFonts.poppins(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
              height: 1.2,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          if (workspace.description.isNotEmpty) ...[
            const SizedBox(height: 3),
            Text(
              workspace.description,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: AppColors.textMuted,
                height: 1.3,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const Spacer(),
          Row(
            children: [
              Icon(Icons.people_outline_rounded,
                  size: 12, color: color.withOpacity(0.7)),
              const SizedBox(width: 3),
              Text(
                '${workspace.numberOfMembers}',
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 10),
              Icon(Icons.task_alt_rounded,
                  size: 12, color: color.withOpacity(0.7)),
              const SizedBox(width: 3),
              Text(
                '${workspace.numberOfTasks}',
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}