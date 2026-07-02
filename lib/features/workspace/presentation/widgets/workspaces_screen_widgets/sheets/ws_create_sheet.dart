// lib/features/workspace/presentation/widgets/workspaces_screen_widgets/sheets/ws_create_sheet.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_values.dart';
import '../../../../../../core/theme/app_icons.dart';
import '../../../../../../core/pickers/icon_picker.dart';
import '../../../../../roles/models/workspce_role.dart';
import '../../../../../workspace/logic/workspace_cubit/workspace_cubit.dart';
import '../shared/ws_handle.dart';
import '../shared/ws_label.dart';
import '../shared/ws_text_field.dart';
import '../shared/ws_color_dot.dart';
import '../ws_color_service.dart';
import '../ws_member.dart';
import '../pickers/ws_visibility_picker.dart';
import 'ws_role_picker_sheet.dart';

class WsCreateSheet extends StatefulWidget {
  const WsCreateSheet({super.key});

  @override
  State<WsCreateSheet> createState() => _WsCreateSheetState();
}

class _WsCreateSheetState extends State<WsCreateSheet> {
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final List<WsMemberEntry> _members = [];

  String _emoji = AppIcons.workspace.first.display;
  String _emojiCode = AppIcons.workspace.first.code;
  int _colorIdx = 0;
  int _visibility = 0;
  bool _isLoading = false;

  Color get _accent => WsColorService.palette[_colorIdx];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _addMember() async {
    final email = _emailCtrl.text.trim();
    if (email.isEmpty) return;
    if (_members.any((m) => m.email == email)) return;

    final role = await _showRolePicker();
    if (role == null) return;

    setState(() {
      _members.add(WsMemberEntry(email: email, role: role));
      _emailCtrl.clear();
    });
  }

  Future<WorkspaceRole?> _showRolePicker() {
    return showModalBottomSheet<WorkspaceRole>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => WsRolePickerSheet(accent: _accent),
    );
  }

  Future<void> _create() async {
    if (_nameCtrl.text.trim().isEmpty) return;
    setState(() => _isLoading = true);

    final cubit = context.read<WorkspaceCubit>();
    final newId = await cubit.createWorkspace(
      name: _nameCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      iconCode: _emojiCode,
      visibility: _visibility,
    );

    if (newId != null) {
      await WsColorService.save(newId, _accent);
      // TODO: Add members after creating workspace
      for (final member in _members) {
        await cubit.addMember(newId, member.email, permissions: member.permissions);
      }
    }

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          newId != null ? 'Workspace created!' : 'Failed to create.',
          style: GoogleFonts.poppins(fontSize: 13, color: AppColors.white),
        ),
        backgroundColor: newId != null ? AppColors.success : AppColors.error,
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
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
            const SizedBox(height: 22),
            _buildSheetTitle(),
            const SizedBox(height: 26),
            _buildIconAndColorCard(),
            const SizedBox(height: 18),
            const WsLabel('Workspace Name'),
            const SizedBox(height: 7),
            WsTextField(controller: _nameCtrl, hint: ' Marketing Team', accentColor: _accent),
            const SizedBox(height: 16),
            const WsLabel('Description (Optional)'),
            const SizedBox(height: 7),
            WsTextField(
              controller: _descCtrl,
              hint: 'What is this workspace for?',
              accentColor: _accent,
              maxLines: 3,
            ),
            const SizedBox(height: 22),
            _buildInviteCard(),
            const SizedBox(height: 22),
            const WsLabel('Workspace Visibility'),
            const SizedBox(height: 10),
            WsVisibilityPicker(
              selected: _visibility,
              accent: _accent,
              onChanged: (v) => setState(() => _visibility = v),
            ),
            const SizedBox(height: 30),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  // ── Title — centered, bold, no icon clutter ─────────────────
  Widget _buildSheetTitle() {
    return Column(
      children: [
        Text(
          'Create New Workspace',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          'Set up a space for your team.',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: AppColors.roleViewer,
          ),
        ),
      ],
    );
  }

  // ── Icon + Color — grouped in a soft card ───────────────────
  Widget _buildIconAndColorCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.roleViewer.withOpacity(0.10),
        borderRadius: BorderRadius.circular(AppValues.radiusXl),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const WsLabel('Icon'),
              const SizedBox(height: 9),
              GestureDetector(
                onTap: _pickEmoji,
                child: Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    color: _accent.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(AppValues.radiusLg),
                    border: Border.all(color: _accent.withOpacity(0.30), width: 1.5),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_emoji, style: const TextStyle(fontSize: 33)),
                      const SizedBox(height: 2),
                      Text(
                        'CHANGE',
                        style: GoogleFonts.inter(
                          fontSize: 8.5,
                          color: _accent,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const WsLabel('Color Theme'),
                const SizedBox(height: 9),
                Wrap(
                  spacing: 9,
                  runSpacing: 9,
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
      ),
    );
  }

  // ── Invite section — grouped in a soft card ─────────────────
  Widget _buildInviteCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.roleViewer.withOpacity(0.10),
        borderRadius: BorderRadius.circular(AppValues.radiusXl),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person_add_alt_1_outlined, size: 15, color: _accent),
              const SizedBox(width: 6),
              const WsLabel('Invite Team Members'),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            'Tap "Add" to choose a role for each member.',
            style: GoogleFonts.outfit(fontSize: 11.5, color: AppColors.roleViewer),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: WsTextField(
                  controller: _emailCtrl,
                  hint: 'member@example.com',
                  accentColor: _accent,
                  onSubmitted: (_) => _addMember(),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _addMember,
                child: Container(
                  height: 46,
                  padding: const EdgeInsets.symmetric(horizontal: AppValues.paddingMd),
                  decoration: BoxDecoration(
                    color: _accent,
                    borderRadius: BorderRadius.circular(AppValues.pillRadius),
                    boxShadow: [
                      BoxShadow(
                        color: _accent.withOpacity(0.30),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'Add',
                      style: GoogleFonts.outfit(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (_members.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: _members
                  .map((m) => WsMemberChip(
                        member: m,
                        accentColor: _accent,
                        onRemove: () => setState(() => _members.remove(m)),
                      ))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  // ── Action buttons — full pill shape ─────────────────────────
  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.roleViewer.withOpacity(0.10),
                borderRadius: BorderRadius.circular(AppValues.pillRadius),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Center(
                child: Text(
                  'Cancel',
                  style: GoogleFonts.outfit(
                    fontSize: 14.5,
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
            onTap: _isLoading ? null : _create,
            child: AnimatedContainer(
              duration: AppValues.animFast,
              height: 52,
              decoration: BoxDecoration(
                color: _isLoading ? AppColors.grey : _accent,
                borderRadius: BorderRadius.circular(AppValues.pillRadius),
                boxShadow: _isLoading
                    ? []
                    : [
                        BoxShadow(
                          color: _accent.withOpacity(0.35),
                          blurRadius: 18,
                          offset: const Offset(0, 7),
                        ),
                      ],
              ),
              child: Center(
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.white),
                      )
                    : Text(
                        'Create Workspace',
                        style: GoogleFonts.outfit(
                          fontSize: 14.5,
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