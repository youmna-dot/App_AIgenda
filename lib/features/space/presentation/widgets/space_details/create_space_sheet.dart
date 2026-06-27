// lib/features/workspace/presentation/widgets/space_details/create_space_sheet.dart
//
// FIX 5: onCreated كانت ValueChanged<dynamic> بتبعت Map
//         دلوقتي typed callback: (name, description, iconCode, isPublic)
//         يتوافق مع WorkspaceDashboardScreen._openCreateSheet

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_values.dart';
import '../../../../workspace/presentation/widgets/workspace_dash_widgets/color_dot.dart';
import '../../../../workspace/presentation/widgets/workspace_dash_widgets/icon_picker_sheet.dart';
import '../../../../workspace/presentation/widgets/workspace_dash_widgets/sheet_field.dart';
import '../../../../workspace/presentation/widgets/workspace_dash_widgets/sheet_handle.dart';
import '../../../../workspace/presentation/widgets/workspace_dash_widgets/sheet_label.dart';
import '../../../../workspace/presentation/widgets/workspace_dash_widgets/visibility_picker.dart';

const List<Color> _spaceColors = [
  Color.fromARGB(255, 182, 74, 74),
  Color.fromARGB(255, 6, 106, 74),
  Color.fromARGB(255, 188, 21, 102),
  Color.fromARGB(255, 171, 113, 147),
  Color.fromARGB(255, 245, 11, 11),
  Color.fromARGB(255, 79, 2, 2),
  Color.fromARGB(255, 52, 164, 216),
  Color.fromARGB(255, 246, 218, 92),
  Color.fromARGB(255, 87, 173, 136),
  Color(0xFFD97706),
  Color.fromARGB(255, 124, 86, 190),
  Color.fromARGB(255, 17, 5, 150),
];

class CreateSpaceSheet extends StatefulWidget {
  // [FIX] typed callback بدل ValueChanged<dynamic>
  final void Function(
      String name,
      String description,
      String iconCode,
      bool isPublic,
      int colorIndex,
      ) onCreated;

  const CreateSpaceSheet({super.key, required this.onCreated});

  @override
  State<CreateSpaceSheet> createState() => _CreateSpaceSheetState();
}

class _CreateSpaceSheetState extends State<CreateSpaceSheet> {
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  String _iconCode = '📁';
  int _colorIdx = 0;
  int _visibility = 0; // 0 = public, 1 = private

  Color get _accent => _spaceColors[_colorIdx];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _create() {
    if (_nameCtrl.text.trim().isEmpty) return;

    // [FIX] بنبعت args منفصلة مع colorIndex
    widget.onCreated(
      _nameCtrl.text.trim(),
      _descCtrl.text.trim(),
      _iconCode,
      _visibility == 0, // isPublic
      _colorIdx,        // colorIndex
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppValues.radiusCard - 4)),
      ),
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
            AppValues.horizontalPadding, 16,
            AppValues.horizontalPadding, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SheetHandle(),
            const SizedBox(height: 18),
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: _accent.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Center(
                      child: Text(_iconCode,
                          style: const TextStyle(fontSize: 20))),
                ),
                const SizedBox(width: 11),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Create a Space',
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark)),
                    Text('Organize tasks_widgets & notes.',
                        style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: AppColors.textMuted)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Divider(height: 1, color: _accent.withOpacity(0.12)),
            const SizedBox(height: 18),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SheetLabel('Space Icon'),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _pickIcon,
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: _accent.withOpacity(0.09),
                          borderRadius: BorderRadius.circular(
                              AppValues.radiusLg + 2),
                          border: Border.all(
                              color: _accent.withOpacity(0.3),
                              width: 1.5),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(_iconCode,
                                style: const TextStyle(fontSize: 30)),
                            Text('CHANGE',
                                style: GoogleFonts.poppins(
                                    fontSize: 7,
                                    color: _accent,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.4)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SheetLabel('Color'),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: List.generate(
                          _spaceColors.length,
                              (i) => ColorDot(
                            color: _spaceColors[i],
                            isSelected: _colorIdx == i,
                            onTap: () =>
                                setState(() => _colorIdx = i),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            const SheetLabel('Space Name'),
            const SizedBox(height: 6),
            SheetField(
                ctrl: _nameCtrl,
                hint: 'e.g. Design, Development',
                accent: _accent),
            const SizedBox(height: 14),
            const SheetLabel('Description (Optional)'),
            const SizedBox(height: 6),
            SheetField(
                ctrl: _descCtrl,
                hint: 'What is this space for?',
                accent: _accent,
                maxLines: 2),
            const SizedBox(height: 18),
            const SheetLabel('Visibility'),
            const SizedBox(height: 10),
            SpaceVisibilityPicker(
              selected: _visibility,
              accent: _accent,
              onChanged: (v) => setState(() => _visibility = v),
            ),
            const SizedBox(height: 26),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: AppValues.buttonHeight - 8,
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(
                            AppValues.radiusMd - 1),
                        border: Border.all(
                            color: _accent.withOpacity(0.2)),
                      ),
                      child: Center(
                        child: Text('Cancel',
                            style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: _create,
                    child: Container(
                      height: AppValues.buttonHeight - 8,
                      decoration: BoxDecoration(
                        color: _accent,
                        borderRadius: BorderRadius.circular(
                            AppValues.radiusMd - 1),
                        boxShadow: [
                          BoxShadow(
                              color: _accent.withOpacity(0.35),
                              blurRadius: 16,
                              offset: const Offset(0, 6)),
                        ],
                      ),
                      child: Center(
                        child: Text('Create Space',
                            style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.white)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _pickIcon() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => IconPickerSheet(
        selectedIcon: _iconCode,
        accent: _accent,
        onSelected: (icon) => setState(() => _iconCode = icon),
      ),
    );
  }
}