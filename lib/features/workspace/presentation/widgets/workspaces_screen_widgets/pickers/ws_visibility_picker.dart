// lib/features/workspace/presentation/widgets/workspaces_screen_widgets/pickers/ws_visibility_picker.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_values.dart';

class WsVisibilityPicker extends StatelessWidget {
  final int selected;
  final Color accent;
  final ValueChanged<int> onChanged;

  const WsVisibilityPicker({
    super.key,
    required this.selected,
    required this.accent,
    required this.onChanged,
  });

  static const _opts = [
    (Icons.lock_outline_rounded, 'Private', 'Only invited members can see this.'),
    (Icons.people_outline_rounded, 'Team', 'Visible to everyone in the organization.'),
    (Icons.public_rounded, 'Public', 'Anyone with the link can view.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(3, (i) {
        final isSelected = selected == i;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i < 2 ? 8.0 : 0),
            child: GestureDetector(
              onTap: () => onChanged(i),
              child: AnimatedContainer(
                duration: AppValues.animFast,
                padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
                decoration: BoxDecoration(
                  color: isSelected ? accent.withValues(alpha: 0.07) : AppColors.roleViewer.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(AppValues.radiusSm + 1),
                  border: Border.all(
                    color: isSelected ? accent : AppColors.cardBorder,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Column(
                  children: [
                    _RadioDot(isSelected: isSelected, accent: accent),
                    const SizedBox(height: 6),
                    Icon(
                      _opts[i].$1,
                      color: isSelected ? accent : AppColors.textDark,
                      size: 17,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _opts[i].$2,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? accent : AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _opts[i].$3,
                      style: GoogleFonts.poppins(
                        fontSize: 9.5,
                        color: AppColors.roleViewer,
                        height: 1.3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _RadioDot extends StatelessWidget {
  final bool isSelected;
  final Color accent;

  const _RadioDot({required this.isSelected, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? accent : AppColors.textPrimary,
          width: 2,
        ),
      ),
      child: isSelected
          ? Center(
              child: Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
              ),
            )
          : null,
    );
  }
}