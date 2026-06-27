// lib/core/pickers/icon_picker.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_icons.dart';
import '../theme/app_colors.dart';

class IconPicker extends StatelessWidget {
  final List<AppIcon> icons;
  final String selectedCode;
  final Color accentColor;          // ← Color مش String
  final ValueChanged<AppIcon> onSelected;
  final String title;

  const IconPicker({
    super.key,
    required this.icons,
    required this.selectedCode,
    required this.accentColor,      // ←
    required this.onSelected,
    this.title = 'Choose Icon',
  });

  @override
  Widget build(BuildContext context) {
    final accent = accentColor;     // ← مش fromId

    return Container(
      height: MediaQuery.of(context).size.height * 0.55,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemCount: icons.length,
              itemBuilder: (ctx, i) {
                final item = icons[i];
                final isSelected = item.code == selectedCode;

                return GestureDetector(
                  onTap: () {
                    onSelected(item);
                    Navigator.pop(ctx);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? accent.withOpacity(0.12)
                          : AppColors.background,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? accent : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      item.display,
                      style: const TextStyle(fontSize: 26),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}