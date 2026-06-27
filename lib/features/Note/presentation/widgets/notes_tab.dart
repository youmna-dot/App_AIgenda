// lib/features/Note/presentation/widgets/notes_tab.dart
//
// FIXES:
//  1. Border radius crash → replaced non-uniform Border() with
//     clipBehavior + inner accent strip (Container) approach
//  2. Tap → NoteViewerSheet (read-only), long-press → context menu
//  3. Color passed from card to viewer/editor

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_values.dart';
import '../../../task/presentation/widgets/tasks_widgets/kanban/delete_confirm_sheet.dart';
import '../../data/models/note_model.dart';
import '../../logic/note_cubit/note_cubit.dart';
import '../../logic/note_cubit/note_state.dart';
import 'edit_note_sheet.dart';
import 'note_viewer_sheet.dart'; // NEW – read-only viewer

enum _NoteFilter { all, text, voice, image, draw }

extension _NoteFilterX on _NoteFilter {
  String get label {
    switch (this) {
      case _NoteFilter.all:   return 'All';
      case _NoteFilter.text:  return '📝 Text';
      case _NoteFilter.voice: return '🎙️ Voice';
      case _NoteFilter.image: return '🖼️ Image';
      case _NoteFilter.draw:  return '✏️ Draw';
    }
  }

  String? get typeValue {
    switch (this) {
      case _NoteFilter.all:   return null;
      case _NoteFilter.text:  return 'Text';
      case _NoteFilter.voice: return 'Voice';
      case _NoteFilter.image: return 'Image';
      case _NoteFilter.draw:  return 'HandDraw';
    }
  }
}

class NotesTab extends StatefulWidget {
  final int workspaceId;
  final String spaceId;
  final Color accentColor;
  final bool canCreate;
  final VoidCallback? onAddNote;

  const NotesTab({
    super.key,
    required this.workspaceId,
    required this.spaceId,
    required this.accentColor,
    this.canCreate = false,
    this.onAddNote,
  });

  @override
  State<NotesTab> createState() => _NotesTabState();
}

class _NotesTabState extends State<NotesTab> {
  _NoteFilter _filter = _NoteFilter.all;

  List<NoteModel> _filtered(List<NoteModel> all) {
    if (_filter.typeValue == null) return all;
    return all.where((n) => n.type == _filter.typeValue).toList();
  }

  List<NoteModel> _pinned(List<NoteModel> notes) =>
      notes.where((n) => n.isPinned).toList();

  List<NoteModel> _unpinned(List<NoteModel> notes) =>
      notes.where((n) => !n.isPinned).toList();

  // ── FIX 2: tap → viewer ────────────────────────────────────
  void _openViewer(NoteModel note) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (_) => NoteViewerSheet(
        note: note,
        accentColor: widget.accentColor,
        onEdit: () => _openEdit(note),
      ),
    );
  }

  void _openEdit(NoteModel note) {
    final cubit = context.read<NoteCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (_) => EditNoteSheet(
        note: note,
        accentColor: widget.accentColor,
        onSaved: (title, plainText, type, isPinned) {
          cubit.updateNote(
            workspaceId: widget.workspaceId,
            spaceId:     widget.spaceId,
            noteId:      note.id,
            title:       title,
            type:        type,
            isPinned:    isPinned,
            plainText:   plainText.isEmpty ? null : plainText,
          );
        },
      ),
    );
  }

  void _onDelete(NoteModel note) {
    showDeleteConfirmSheet(
      context: context,
      type: DeleteType.note,
      itemName: note.title,
      accentColor: widget.accentColor,
      onConfirm: () => context.read<NoteCubit>().deleteNote(
        widget.workspaceId, widget.spaceId, note.id,
      ),
    );
  }

  void _onTogglePin(NoteModel note) {
    context.read<NoteCubit>().togglePin(
      workspaceId: widget.workspaceId,
      spaceId:     widget.spaceId,
      note:        note,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteCubit, NoteState>(
      builder: (ctx, state) {
        if (state is NoteLoading) {
          return const Center(
            child: CircularProgressIndicator(
                color: AppColors.primary, strokeWidth: 2),
          );
        }

        if (state is NoteError) {
          return _ErrorView(
            message: state.message,
            onRetry: () => ctx
                .read<NoteCubit>()
                .getNotes(widget.workspaceId, widget.spaceId),
          );
        }

        final all = state is NotesSuccess
            ? _filtered(state.data.items)
            : <NoteModel>[];
        final pinned   = _pinned(all);
        final unpinned = _unpinned(all);

        return ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            AppValues.horizontalPadding, 8,
            AppValues.horizontalPadding, 24,
          ),
          children: [
            _buildFilterChips(),
            const SizedBox(height: 10),

            if (widget.canCreate) ...[
              _buildAddButton(),
              const SizedBox(height: 12),
            ],

            if (all.isEmpty)
              _EmptyNotesView(accentColor: widget.accentColor)
            else ...[
              if (pinned.isNotEmpty) ...[
                _sectionLabel('📌 Pinned', widget.accentColor),
                const SizedBox(height: 6),
                ...pinned.map((n) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _PinnedNoteCard(
                    note: n,
                    accentColor: widget.accentColor,
                    onView:   () => _openViewer(n),   // FIX 2
                    onEdit:   () => _openEdit(n),
                    onPin:    () => _onTogglePin(n),
                    onDelete: () => _onDelete(n),
                  ),
                )),
                const SizedBox(height: 4),
              ],

              if (unpinned.isNotEmpty) ...[
                _sectionLabel(
                  'All Notes  ·  tap to view  ·  long press for options',
                  AppColors.textMuted,
                  small: true,
                ),
                const SizedBox(height: 6),
                _buildNotesGrid(unpinned),
              ],
            ],
          ],
        );
      },
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 28,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: _NoteFilter.values.map((f) {
          final isOn = f == _filter;
          return GestureDetector(
            onTap: () => setState(() => _filter = f),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: const EdgeInsets.only(right: 6),
              padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isOn ? widget.accentColor : AppColors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isOn
                      ? widget.accentColor
                      : AppColors.primary.withOpacity(0.15),
                  width: 0.5,
                ),
              ),
              child: Text(
                f.label,
                style: GoogleFonts.poppins(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w700,
                  color: isOn ? AppColors.white : AppColors.textMuted,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAddButton() {
    return GestureDetector(
      onTap: widget.onAddNote,
      child: Container(
        height: 36,
        decoration: BoxDecoration(
          color: widget.accentColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: widget.accentColor.withOpacity(0.28),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_rounded, color: AppColors.white, size: 15),
            const SizedBox(width: 6),
            Text(
              'New Note',
              style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesGrid(List<NoteModel> notes) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1.05,
      ),
      itemCount: notes.length,
      itemBuilder: (_, i) => _NoteGridCard(
        note: notes[i],
        accentColor: widget.accentColor,
        onView:   () => _openViewer(notes[i]),  // FIX 2
        onEdit:   () => _openEdit(notes[i]),
        onPin:    () => _onTogglePin(notes[i]),
        onDelete: () => _onDelete(notes[i]),
      ),
    );
  }

  Widget _sectionLabel(String text, Color color, {bool small = false}) {
    return Row(
      children: [
        if (!small)
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(right: 5),
            decoration: const BoxDecoration(
                color: AppColors.warning, shape: BoxShape.circle),
          ),
        Flexible(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: small ? 8 : 9,
              fontWeight: FontWeight.w700,
              color: color,
              letterSpacing: small ? 0 : 0.4,
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Pinned Note Card
// FIX 1: non-uniform border → clipBehavior + left accent strip
// FIX 2: onTap → view, context menu has edit option
// ─────────────────────────────────────────────────────────────
class _PinnedNoteCard extends StatelessWidget {
  final NoteModel note;
  final Color accentColor;
  final VoidCallback onView;    // NEW
  final VoidCallback onEdit;
  final VoidCallback onPin;
  final VoidCallback onDelete;

  const _PinnedNoteCard({
    required this.note,
    required this.accentColor,
    required this.onView,
    required this.onEdit,
    required this.onPin,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onView,  // FIX 2: opens viewer
      onLongPress: () {
        HapticFeedback.mediumImpact();
        _showContextMenu(context);
      },
      child: Container(
        // FIX 1: uniform border + borderRadius is valid
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(11),
          border: Border.all(
            color: AppColors.primary.withOpacity(0.08),
            width: 0.5,
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 2))
          ],
        ),
        clipBehavior: Clip.antiAlias, // clips accent strip to rounded corners
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left accent strip (replaces non-uniform border)
              Container(width: 3, color: accentColor),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              note.title,
                              style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textDark),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          _TypeBadge(type: note.type),
                        ],
                      ),
                      if (note.plainText != null && note.plainText!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          note.plainText!,
                          style: GoogleFonts.poppins(
                              fontSize: 10,
                              color: AppColors.textMuted,
                              height: 1.4),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                              width: 5,
                              height: 5,
                              decoration: const BoxDecoration(
                                  color: AppColors.warning,
                                  shape: BoxShape.circle)),
                          const SizedBox(width: 4),
                          Text(
                            _formatDate(note.updatedAt ?? note.createdAt),
                            style: GoogleFonts.poppins(
                                fontSize: 8, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _NoteContextMenu(
        note: note,
        onView: onView,     // NEW
        onEdit: onEdit,
        onPin: onPin,
        onDelete: onDelete,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Note Grid Card
// FIX 1: non-uniform border → clipBehavior + top accent strip
// FIX 2: onTap → view
// ─────────────────────────────────────────────────────────────
class _NoteGridCard extends StatelessWidget {
  final NoteModel note;
  final Color accentColor;
  final VoidCallback onView;    // NEW
  final VoidCallback onEdit;
  final VoidCallback onPin;
  final VoidCallback onDelete;

  const _NoteGridCard({
    required this.note,
    required this.accentColor,
    required this.onView,
    required this.onEdit,
    required this.onPin,
    required this.onDelete,
  });

  Color _topColor() {
    switch (note.type) {
      case 'Voice':    return AppColors.error;
      case 'Image':    return const Color(0xFF0984E3);
      case 'HandDraw': return AppColors.warning;
      default:         return AppColors.primary;
    }
  }

  String _typeEmoji() {
    switch (note.type) {
      case 'Voice':    return '🎙️';
      case 'Image':    return '🖼️';
      case 'HandDraw': return '✏️';
      default:         return '📝';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onView,  // FIX 2: opens viewer
      onLongPress: () {
        HapticFeedback.mediumImpact();
        _showContextMenu(context);
      },
      child: Container(
        // FIX 1: uniform border is fine with borderRadius
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(11),
          border: Border.all(
            color: AppColors.primary.withOpacity(0.08),
            width: 0.5,
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 6,
                offset: const Offset(0, 2))
          ],
        ),
        clipBehavior: Clip.antiAlias, // clips top strip to rounded corners
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top accent strip (replaces non-uniform border)
            Container(height: 2.5, color: _topColor()),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(_typeEmoji(),
                            style: const TextStyle(fontSize: 14)),
                        const Spacer(),
                        Text(
                          _formatDate(note.updatedAt ?? note.createdAt),
                          style: GoogleFonts.poppins(
                              fontSize: 7.5, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      note.title,
                      style: GoogleFonts.poppins(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (note.type == 'Voice') ...[
                      const SizedBox(height: 4),
                      _WaveformPlaceholder(color: AppColors.error),
                    ] else if (note.type == 'Image') ...[
                      const SizedBox(height: 4),
                      _ImageThumbPlaceholder(),
                    ] else if (note.type == 'HandDraw') ...[
                      const SizedBox(height: 4),
                      _DrawThumbPlaceholder(),
                    ] else if (note.plainText != null &&
                        note.plainText!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        note.plainText!,
                        style: GoogleFonts.poppins(
                            fontSize: 9,
                            color: AppColors.textMuted,
                            height: 1.3),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _NoteContextMenu(
        note: note,
        onView: onView,     // NEW
        onEdit: onEdit,
        onPin: onPin,
        onDelete: onDelete,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Context Menu — now has "View" + "Edit" separately
// ─────────────────────────────────────────────────────────────
class _NoteContextMenu extends StatelessWidget {
  final NoteModel note;
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onPin;
  final VoidCallback onDelete;

  const _NoteContextMenu({
    required this.note,
    required this.onView,
    required this.onEdit,
    required this.onPin,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                  color: AppColors.wsHandleBar,
                  borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            note.title,
            style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 14),
          _CtxItem(
            icon: Icons.visibility_outlined,
            label: 'View note',
            color: AppColors.primary,
            onTap: () {
              Navigator.pop(context);
              onView();
            },
          ),
          _CtxItem(
            icon: Icons.edit_outlined,
            label: 'Edit note',
            color: AppColors.textMuted,
            onTap: () {
              Navigator.pop(context);
              onEdit();
            },
          ),
          _CtxItem(
            icon: note.isPinned
                ? Icons.push_pin_rounded
                : Icons.push_pin_outlined,
            label: note.isPinned ? 'Unpin' : 'Pin',
            color: AppColors.warning,
            onTap: () {
              Navigator.pop(context);
              onPin();
            },
          ),
          const Divider(height: 1, color: AppColors.dividerLight),
          _CtxItem(
            icon: Icons.delete_outline_rounded,
            label: 'Delete note',
            color: AppColors.error,
            onTap: () {
              Navigator.pop(context);
              onDelete();
            },
          ),
        ],
      ),
    );
  }
}

class _CtxItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _CtxItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      leading: Icon(icon, color: color, size: 19),
      title: Text(label,
          style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color)),
      onTap: onTap,
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Type Badge
// ─────────────────────────────────────────────────────────────
class _TypeBadge extends StatelessWidget {
  final String type;
  const _TypeBadge({required this.type});

  Color _color() {
    switch (type) {
      case 'Voice':    return AppColors.error;
      case 'Image':    return const Color(0xFF0984E3);
      case 'HandDraw': return AppColors.warning;
      default:         return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: _color().withOpacity(0.10),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(type,
          style: GoogleFonts.poppins(
              fontSize: 8,
              fontWeight: FontWeight.w700,
              color: _color())),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Placeholders
// ─────────────────────────────────────────────────────────────
class _WaveformPlaceholder extends StatelessWidget {
  final Color color;
  const _WaveformPlaceholder({required this.color});

  @override
  Widget build(BuildContext context) {
    final heights = [6.0, 12.0, 8.0, 16.0, 7.0, 14.0, 6.0, 10.0];
    return Row(
      children: heights
          .map((h) => Container(
        width: 3,
        height: h,
        margin: const EdgeInsets.only(right: 2),
        decoration: BoxDecoration(
          color: color.withOpacity(0.7),
          borderRadius: BorderRadius.circular(2),
        ),
      ))
          .toList(),
    );
  }
}

class _ImageThumbPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE8F4FD), Color(0xFFC8E6F9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Center(
          child: Text('🖼️', style: TextStyle(fontSize: 16))),
    );
  }
}

class _DrawThumbPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(0.10),
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Center(
          child: Text('✏️', style: TextStyle(fontSize: 14))),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Empty / Error
// ─────────────────────────────────────────────────────────────
class _EmptyNotesView extends StatelessWidget {
  final Color accentColor;
  const _EmptyNotesView({required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Column(
          children: [
            Icon(Icons.sticky_note_2_outlined,
                size: 48,
                color: AppColors.textMuted.withOpacity(0.4)),
            const SizedBox(height: 12),
            Text('No Notes Yet',
                style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark)),
            const SizedBox(height: 6),
            Text('Tap "+ New Note" to add your first note.',
                style: GoogleFonts.poppins(
                    fontSize: 12, color: AppColors.textMuted)),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline_rounded,
              color: AppColors.error, size: 32),
          const SizedBox(height: 10),
          Text(message,
              style: GoogleFonts.poppins(
                  fontSize: 12, color: AppColors.textMuted),
              textAlign: TextAlign.center),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: onRetry,
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
              decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10)),
              child: Text('Try Again',
                  style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white)),
            ),
          ),
        ],
      ),
    );
  }
}

String _formatDate(DateTime? d) {
  if (d == null) return '';
  final diff = DateTime.now().difference(d).inDays;
  if (diff == 0) return 'Today';
  if (diff == 1) return 'Yesterday';
  if (diff < 7) return '$diff days ago';
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
  return '${months[d.month - 1]} ${d.day}';
}