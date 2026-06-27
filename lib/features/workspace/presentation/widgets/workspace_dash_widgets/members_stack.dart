// lib/features/workspace/presentation/widgets/workspace_dash_widgets/members_stack.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';

class MembersStack extends StatelessWidget {
  final Color color;
  final int count;

  const MembersStack({
    super.key,
    required this.color,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    if (count == 0) return const SizedBox.shrink();

    final show = count > 3 ? 3 : count;
    final extra = count - show;

    return SizedBox(
      width: show * 18.0 + (extra > 0 ? 22 : 0),
      height: 28,
      child: Stack(
        children: [
          ...List.generate(
            show,
            (i) => Positioned(
              left: i * 18.0,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.20 + i * 0.08),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.white, width: 2),
                ),
                child: Center(
                  child: Icon(Icons.person_rounded, size: 13, color: color),
                ),
              ),
            ),
          ),
          if (extra > 0)
            Positioned(
              left: show * 18.0,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.white, width: 2),
                ),
                child: Center(
                  child: Text(
                    '+$extra',
                    style: GoogleFonts.outfit(
                      fontSize: 8,
                      fontWeight: FontWeight.w800,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}