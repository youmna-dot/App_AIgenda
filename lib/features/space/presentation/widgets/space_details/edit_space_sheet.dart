// lib/features/space/presentation/widgets/space_details/edit_space_sheet.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_values.dart';
import '../../../../../core/theme/app_icons.dart';
import '../../../../../core/pickers/icon_picker.dart';
import '../../../../space/data/models/space_model.dart';
import '../../../../space/presentation/utils/space_color_service.dart';
import '../../../../workspace/presentation/widgets/workspace_dash_widgets/color_dot.dart';
import '../../../../workspace/presentation/widgets/workspace_dash_widgets/sheet_field.dart';
import '../../../../workspace/presentation/widgets/workspace_dash_widgets/sheet_handle.dart';
import '../../../../workspace/presentation/widgets/workspace_dash_widgets/sheet_label.dart';
import '../../../../workspace/presentation/widgets/workspace_dash_widgets/visibility_picker.dart';

const List<Color> _spaceColors = SpaceColorService.palette;

class EditSpaceSheet extends StatefulWidget {
  final SpaceModel space;

  // [FIX] initialColorIndex بييجي من SharedPreferences مش من space.colorIndex
  // لأن الـ backend مش بيخزن الـ colorIndex
  final int initialColorIndex;

  final void Function(
      String name,
      String description,
      String iconCode,
      bool isPublic,
      int colorIndex,
      ) onSaved;

  const EditSpaceSheet({
    super.key,
    required this.space,
    required this.initialColorIndex,
    required this.onSaved,
  });

  @override
  State<EditSpaceSheet> createState() => _EditSpaceSheetState();
}

class _EditSpaceSheetState extends State<EditSpaceSheet> {
  late TextEditingController _nameCtrl;
  late TextEditingController _descCtrl;
  late String _iconCode;
  late int _colorIdx;
  late int _visibility;

  Color get _accent => _spaceColors[_colorIdx];

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.space.name);
    _descCtrl = TextEditingController(text: widget.space.description ?? '');
    _iconCode = widget.space.iconCode;
    // [FIX] بنستخدم initialColorIndex اللي اتحسب من SharedPreferences
    // مش space.colorIndex اللي دايماً null من الـ API
    _colorIdx = widget.initialColorIndex;
    _visibility = widget.space.isPublic ? 0 : 1;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (_nameCtrl.text.trim().isEmpty) return;

    widget.onSaved(
      _nameCtrl.text.trim(),
      _descCtrl.text.trim(),
      _iconCode,
      _visibility == 0,
      _colorIdx,
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
                    color: AppColors.gradientBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: const Icon(Icons.edit_outlined,
                      color: AppColors.gradientBlue, size: 18),
                ),
                const SizedBox(width: 11),
                Text('Edit Space',
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark)),
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
                    const SheetLabel('Icon'),
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
                            Text(AppIcons.displayFromCode(_iconCode),
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
                hint: 'Space name',
                accent: _accent),
            const SizedBox(height: 14),
            const SheetLabel('Description'),
            const SizedBox(height: 6),
            SheetField(
                ctrl: _descCtrl,
                hint: 'Short description...',
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
                    onTap: _save,
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
                        child: Text('Save Changes',
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
      builder: (_) => IconPicker(
        icons: AppIcons.space,
        selectedCode: _iconCode,
        accentColor: _accent,
        title: 'Choose Space Icon',
        onSelected: (icon) => setState(() => _iconCode = icon.code),
      ),
    );
  }
}