// lib/features/workspace/presentation/widgets/workspaces_screen_widgets/ws_list.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../config/routes/route_names.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_values.dart';
import '../../../../../core/storage/secure_storage_service.dart';
import '../../../../../core/theme/app_icons.dart' show AppIcons;
import '../../../../workspace/data/models/workspace_model.dart';
import 'sheets/ws_actions_sheet.dart';
import 'sheets/ws_edit_sheet.dart';
import 'shared/ws_confirm_dialog.dart';
import 'ws_color_service.dart';

class WsList extends StatelessWidget {
  final List<WorkspaceModel> workspaces;
  final Future<bool> Function(int id) onDelete;
  final Future<bool> Function(int id, String email) onLeave;
  final Future<bool> Function({
    required int workspaceId,
    required String name,
    required String description,
    required String iconCode,
    required int visibility,
  }) onEdit;

  const WsList({
    super.key,
    required this.workspaces,
    required this.onDelete,
    required this.onLeave,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        horizontal: AppValues.horizontalPadding,
        vertical: 4,
      ),
      itemCount: workspaces.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (_, i) => WsListItem(
        workspace: workspaces[i],
        onDelete: onDelete,
        onLeave: onLeave,
        onEdit: onEdit,
      ),
    );
  }
}

class WsListItem extends StatefulWidget {
  final WorkspaceModel workspace;
  final Future<bool> Function(int id) onDelete;
  final Future<bool> Function(int id, String email) onLeave;
  final Future<bool> Function({
    required int workspaceId,
    required String name,
    required String description,
    required String iconCode,
    required int visibility,
  }) onEdit;

  const WsListItem({
    super.key,
    required this.workspace,
    required this.onDelete,
    required this.onLeave,
    required this.onEdit,
  });

  @override
  State<WsListItem> createState() => _WsListItemState();
}

class _WsListItemState extends State<WsListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  Color _color = AppColors.primary;

  static const double _mockProgress = 0.84;
  static const int _mockDueCount = 2;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 110),
    );
    _scale = Tween(begin: 1.0, end: 0.97)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _loadColor();
  }

  Future<void> _loadColor() async {
    final color = await WsColorService.load(widget.workspace.id);
    if (mounted) setState(() => _color = color);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final emoji = AppIcons.displayFromCode(widget.workspace.iconCode);

    return AnimatedBuilder(
      animation: _scale,
      builder: (_, child) =>
          Transform.scale(scale: _scale.value, child: child),
      child: GestureDetector(
        onTapDown: (_) => _ctrl.forward(),
        onTapUp: (_) {
          _ctrl.reverse();
          context.push(
            RouteNames.workspaceDashboard,
            extra: {
              'workspaceId': widget.workspace.id,
              'workspaceName': widget.workspace.name,
              'workspaceDescription': widget.workspace.description,
              'numberOfMembers': widget.workspace.numberOfMembers,
              'isCurrentUserOwner':
                  widget.workspace.isOwnedByCurrentUser,
            },
          );
        },
        onTapCancel: () => _ctrl.reverse(),
        onLongPress: () {
          HapticFeedback.mediumImpact();
          _openActions(context);
        },
        child: Container(
          decoration: BoxDecoration(
            color: _color.withOpacity(0.07),
            borderRadius: BorderRadius.circular(AppValues.radiusXl),
            border: Border.all(
              color: _color.withOpacity(0.18),
              width: 0.8,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 12, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: _color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Text(emoji,
                            style: const TextStyle(fontSize: 24)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.workspace.name,
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textDark,
                              letterSpacing: -0.3,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Last edited 2m ago',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: AppColors.black.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _openActions(context),
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Icon(Icons.more_horiz_rounded,
                            color: AppColors.textDark, size: 25),
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.workspace.description.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                  child: Text(
                    widget.workspace.description,
                    style: GoogleFonts.outfit(
                      fontSize: 15,
                      color: AppColors.appPurpleDark,
                      height: 1.5,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text('Progress',
                        style: GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark)),
                    const Spacer(),
                    Text(
                      '${(_mockProgress * 100).toInt()}%',
                      style: GoogleFonts.outfit(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: _color),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: _mockProgress,
                    backgroundColor: _color.withOpacity(0.12),
                    color: _color,
                    minHeight: 6,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Row(
                  children: [
                    _Chip(
                      icon: Icons.check_circle_outline_rounded,
                      label: '${widget.workspace.numberOfTasks} Tasks',
                      color: _color,
                    ),
                    const SizedBox(width: 8),
                    if (_mockDueCount > 0)
                      _Chip(
                        icon: Icons.calendar_today_outlined,
                        label: '$_mockDueCount Due',
                        color: AppColors.accentOrange,
                      ),
                    const Spacer(),
                    _MembersAvatars(
                      count: widget.workspace.numberOfMembers,
                      color: _color,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => WsActionsSheet(
        workspace: widget.workspace,
        color: _color,
        isOwner: widget.workspace.isOwnedByCurrentUser,
        onEditTap: widget.workspace.isOwnedByCurrentUser
            ? () => _openEdit(context)
            : null,
        onDeleteTap: widget.workspace.isOwnedByCurrentUser
            ? () => _confirmDelete(context)
            : null,
        onLeaveTap: !widget.workspace.isOwnedByCurrentUser
            ? () => _confirmLeave(context)
            : null,
      ),
    );
  }

  void _openEdit(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (_) => WsEditSheet(
        workspace: widget.workspace,
        currentColor: _color,
        onColorSaved: (c) {
          if (mounted) setState(() => _color = c);
        },
        onSave: (name, description, iconCode, visibility) =>
            widget.onEdit(
          workspaceId: widget.workspace.id,
          name: name,
          description: description,
          iconCode: iconCode,
          visibility: visibility,
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    final sm = ScaffoldMessenger.of(context);
    final name = widget.workspace.name;
    final id = widget.workspace.id;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (d) => WsConfirmDialog(
        title: 'Delete Workspace?',
        body: '"$name" and all its data will be permanently removed.',
        confirmLabel: 'Delete',
        confirmColor: AppColors.error,
        onConfirm: () async {
          Navigator.of(d).pop();
          final ok = await widget.onDelete(id);
          if (!mounted) return;
          sm
            ..clearSnackBars()
            ..showSnackBar(_snack(
              ok ? '"$name" deleted.' : 'Failed to delete.',
              ok ? AppColors.success : AppColors.error,
            ));
        },
        onCancel: () => Navigator.of(d).pop(),
      ),
    );
  }

  void _confirmLeave(BuildContext context) async {
    final email = await SecureStorageService().getEmail() ?? '';
    if (!mounted) return;
    final sm = ScaffoldMessenger.of(context);
    final name = widget.workspace.name;
    final id = widget.workspace.id;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (d) => WsConfirmDialog(
        title: 'Leave Workspace?',
        body: 'You will lose access to "$name".',
        confirmLabel: 'Leave',
        confirmColor: AppColors.warning,
        onConfirm: () async {
          Navigator.of(d).pop();
          final ok = await widget.onLeave(id, email);
          if (!mounted) return;
          sm
            ..clearSnackBars()
            ..showSnackBar(_snack(
              ok ? 'Left "$name".' : 'Failed to leave.',
              ok ? AppColors.success : AppColors.error,
            ));
        },
        onCancel: () => Navigator.of(d).pop(),
      ),
    );
  }

  SnackBar _snack(String msg, Color bg) => SnackBar(
        content: Text(msg,
            style: GoogleFonts.outfit(
                fontSize: 13, color: AppColors.white)),
        backgroundColor: bg,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppValues.radiusSm)),
        margin: const EdgeInsets.all(AppValues.paddingMd),
        duration: const Duration(seconds: 3),
      );
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _Chip(
      {required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(label,
              style: GoogleFonts.outfit(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: color)),
        ],
      ),
    );
  }
}

class _MembersAvatars extends StatelessWidget {
  final int count;
  final Color color;
  const _MembersAvatars({required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    if (count == 0) return const SizedBox.shrink();
    final show = count > 3 ? 3 : count;
    final extra = count - show;

    return SizedBox(
      width: show * 20.0 + (extra > 0 ? 24 : 0),
      height: 28,
      child: Stack(
        children: [
          ...List.generate(
              show,
              (i) => Positioned(
                    left: i * 20.0,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.15 + i * 0.1),
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: AppColors.white, width: 2),
                      ),
                      child: Center(
                        child: Icon(Icons.person_rounded,
                            size: 14, color: color),
                      ),
                    ),
                  )),
          if (extra > 0)
            Positioned(
              left: show * 20.0,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.white, width: 2),
                ),
                child: Center(
                  child: Text('+$extra',
                      style: GoogleFonts.outfit(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: AppColors.white)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}