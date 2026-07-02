// lib/features/worksspace/presentation/widgets/workspace_widgets/create_space_sheet.dart

import 'package:ajenda_app/features/workspace/presentation/widgets/workspace_dash_widgets/sheet_field.dart';
import 'package:ajenda_app/features/workspace/presentation/widgets/workspace_dash_widgets/sheet_label.dart';
import 'package:ajenda_app/features/workspace/presentation/widgets/workspace_dash_widgets/visibility_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_values.dart';
import '../../../../../core/theme/app_icons.dart';
import '../../../../../core/pickers/icon_picker.dart';
import '../../../../space/presentation/utils/space_color_service.dart';
import 'color_dot.dart';
import 'sheet_handle.dart';

const List<Color> _spaceColors = SpaceColorService.palette;

class CreateSpaceSheet extends StatefulWidget {
  final void Function(
    String name,
    String description,
    String iconCode,
    bool isPublic,
    int colorIndex,
  )
  onCreated;

  const CreateSpaceSheet({super.key, required this.onCreated});

  @override
  State<CreateSpaceSheet> createState() => _CreateSpaceSheetState();
}

class _CreateSpaceSheetState extends State<CreateSpaceSheet> {
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  String _iconCode = AppIcons.space.first.code;
  int _colorIdx = 0;
  int _visibility = 0;

  Color get _accent => _spaceColors[_colorIdx];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _create() async {
    if (_nameCtrl.text.trim().isEmpty) return;

    final spaceName = _nameCtrl.text.trim();
    final spaceDesc = _descCtrl.text.trim();
    final spaceIcon = _iconCode;
    final isPublic = _visibility == 0;

    // Pass colorIndex to callback - will be saved after space creation with actual spaceId
    widget.onCreated(spaceName, spaceDesc, spaceIcon, isPublic, _colorIdx);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppValues.radiusCard - 4),
        ),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppValues.horizontalPadding,
          16,
          AppValues.horizontalPadding,
          32,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SheetHandle(),
            const SizedBox(height: 18),
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _accent.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Center(
                    child: Text(
                      AppIcons.displayFromCode(_iconCode),
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(width: 11),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create a Space',
                      style: GoogleFonts.poppins(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    Text(
                      'Organize tasks_widgets & notes.',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.roleViewer,
                      ),
                    ),
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
                            AppValues.radiusLg + 2,
                          ),
                          border: Border.all(
                            color: _accent.withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppIcons.displayFromCode(_iconCode),
                              style: const TextStyle(fontSize: 30),
                            ),
                            Text(
                              'CHANGE',
                              style: GoogleFonts.poppins(
                                fontSize: 9,
                                color: _accent,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.4,
                              ),
                            ),
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
                            onTap: () => setState(() => _colorIdx = i),
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
              hint: ' Design, Development',
              accent: _accent,
            ),
            const SizedBox(height: 14),
            const SheetLabel('Description (Optional)'),
            const SizedBox(height: 6),
            SheetField(
              ctrl: _descCtrl,
              hint: 'What is this space for?',
              accent: _accent,
              maxLines: 2,
            ),
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
                        color: AppColors.roleViewer.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(
                          AppValues.radiusMd - 1,
                        ),
                        border: Border.all(color: _accent.withOpacity(0.2)),
                      ),
                      child: Center(
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.poppins(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark,
                          ),
                        ),
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
                          AppValues.radiusMd - 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _accent.withOpacity(0.35),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'Create Space',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.white,
                          ),
                        ),
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

  // Pick icon from the space icon list
  void _pickIcon() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => IconPicker(
        icons: AppIcons.space,
        selectedCode: _iconCode,        // ← مش _icon
        accentColor: _accent,
        title: 'Choose Space Icon',
        onSelected: (icon) => setState(() => _iconCode = icon.code),  // ← icon.code
      ),
    );
  }
}

