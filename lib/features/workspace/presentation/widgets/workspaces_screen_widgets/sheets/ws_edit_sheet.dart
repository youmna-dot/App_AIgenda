// lib/features/workspace/presentation/widgets/workspaces_screen_widgets/sheets/ws_edit_sheet.dart
//
// FIX 4: اتحولت لـ pure widget — مش بتقرأ WorkspaceCubit مباشرة
//         بدل كده بتاخد onSave callback من WsCard
// FIX 3: اتشالت isOwner من الـ editWorkspace call جوا الـ sheet

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_values.dart';
import '../../../../../../core/theme/app_icons.dart';
import '../../../../../../core/pickers/icon_picker.dart';
import '../../../../../workspace/data/models/workspace_model.dart';
import '../shared/ws_handle.dart';
import '../shared/ws_label.dart';
import '../shared/ws_text_field.dart';
import '../shared/ws_color_dot.dart';
import '../ws_color_service.dart';

class WsEditSheet extends StatefulWidget {
  final WorkspaceModel workspace;
  final Color currentColor;

  /// بيتنادى لما اليوزر يحفظ اللون محلياً (SharedPrefs)
  final ValueChanged<Color> onColorSaved;

  /// [FIX] callback جديد — WsCard هي اللي بتكلم الكيوبيت
  /// بترجع bool عشان الـ sheet تعرض snackbar صح أو غلط
  final Future<bool> Function(
  String name,
  String description,
  String iconCode,
  int visibility,
  ) onSave;

  const WsEditSheet({
    super.key,
    required this.workspace,
    required this.currentColor,
    required this.onColorSaved,
    required this.onSave,
  });

  @override
  State<WsEditSheet> createState() => _WsEditSheetState();
}

class _WsEditSheetState extends State<WsEditSheet> {
  late TextEditingController _nameCtrl;
  late TextEditingController _descCtrl;
  late String _emoji;
  late String _emojiCode;
  late int _colorIdx;
  bool _isLoading = false;

  Color get _accent => WsColorService.palette[_colorIdx];

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.workspace.name);
    _descCtrl = TextEditingController(text: widget.workspace.description);
    _emojiCode = widget.workspace.iconCode;
    _emoji = AppIcons.displayFromCode(_emojiCode);
    _colorIdx = WsColorService.palette
        .indexWhere((c) => c.value == widget.currentColor.value);
    if (_colorIdx == -1) _colorIdx = 0;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_nameCtrl.text.trim().isEmpty) return;
    setState(() => _isLoading = true);

    // اللون — محلي بس، مش بيتبعت للـ API
    await WsColorService.save(widget.workspace.id, _accent);
    widget.onColorSaved(_accent);

    // [FIX] بدل ما نقرأ الكيوبيت مباشرة، بنكلم الـ callback
    final ok = await widget.onSave(
      _nameCtrl.text.trim(),
      _descCtrl.text.trim(),
      _emojiCode,
      widget.workspace.visibility,
    );

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          ok ? 'Workspace updated' : 'Failed to update.',
          style: GoogleFonts.poppins(fontSize: 13, color: AppColors.white),
        ),
        backgroundColor: ok ? AppColors.success : AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppValues.radiusSm),
        ),
        margin: const EdgeInsets.all(AppValues.paddingMd),
      ));
    }
  }

  void _pickEmoji() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => IconPicker(
        icons: AppIcons.workspace,
        selectedCode: _emojiCode,
        accentColor: _accent,        
        onSelected: (icon) => setState(() {
          _emoji = icon.display;
          _emojiCode = icon.code;
        }),
        title: 'Choose Icon',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding:
      EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppValues.paddingXl,
          AppValues.paddingMd,
          AppValues.paddingXl,
          32,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const WsHandle(),
            const SizedBox(height: 18),
            _buildSheetTitle(),
            const SizedBox(height: 20),
            Divider(height: 1, color: _accent.withOpacity(0.12)),
            const SizedBox(height: 18),
            _buildIconAndColorRow(),
            const SizedBox(height: 18),
            const WsLabel('Workspace Name'),
            const SizedBox(height: 6),
            WsTextField(
              controller: _nameCtrl,
              hint: 'Workspace name',
              accentColor: _accent,
            ),
            const SizedBox(height: 14),
            const WsLabel('Description'),
            const SizedBox(height: 6),
            WsTextField(
              controller: _descCtrl,
              hint: 'Short description...',
              accentColor: _accent,
              maxLines: 2,
            ),
            const SizedBox(height: 26),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildSheetTitle() {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.gradientBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(11),
          ),
          child: const Icon(
            Icons.edit_outlined,
            color: AppColors.gradientBlue,
            size: 18,
          ),
        ),
        const SizedBox(width: 11),
        Text(
          'Edit Workspace',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
      ],
    );
  }

  Widget _buildIconAndColorRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const WsLabel('Icon'),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickEmoji,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: _accent.withOpacity(0.09),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                      color: _accent.withOpacity(0.3), width: 1.5),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_emoji,
                        style: const TextStyle(fontSize: 30)),
                    Text(
                      'CHANGE',
                      style: GoogleFonts.poppins(
                        fontSize: 8.5,
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
              const WsLabel('Color'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(
                  WsColorService.palette.length,
                      (i) => WsColorDot(
                    color: WsColorService.palette[i],
                    isSelected: _colorIdx == i,
                    onTap: () => setState(() => _colorIdx = i),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.roleViewer.withOpacity(0.10),
                borderRadius:
                BorderRadius.circular(AppValues.radiusSm + 1),
                border:
                Border.all(color: _accent.withOpacity(0.2)),
              ),
              child: Center(
                child: Text(
                  'Cancel',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
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
            onTap: _isLoading ? null : _save,
            child: AnimatedContainer(
              duration: AppValues.animFast,
              height: 48,
              decoration: BoxDecoration(
                color: _isLoading ? AppColors.grey : _accent,
                borderRadius:
                BorderRadius.circular(AppValues.radiusSm + 1),
                boxShadow: _isLoading
                    ? []
                    : [
                  BoxShadow(
                    color: _accent.withOpacity(0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Center(
                child: _isLoading
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.white,
                  ),
                )
                    : Text(
                  'Save Changes',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}