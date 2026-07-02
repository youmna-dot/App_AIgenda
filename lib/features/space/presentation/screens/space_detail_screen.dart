// lib/features/space/presentation/screens/space_detail_screen.dart
//
// REDESIGN — Space Overview page (زي الصورة)
// اتشال الـ TabBar (Tasks/Notes/Analytics) خالص.
// اتشالت جزئية الـ Team (مفيهاش endpoint حاليًا).
// دلوقتي صفحة واحدة سكرول: Header+Stats → Tasks preview → Notes preview
// كل section فيه "View all" بيودّي لشاشة كاملة.

import 'package:ajenda_app/features/space/presentation/utils/note_color_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../config/dependency_injection.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_values.dart';
import '../../../../core/utils/permission_checker.dart';

import '../../../Note/logic/note_cubit/note_cubit.dart';
import '../../../Note/logic/note_cubit/note_state.dart';
import '../../../Note/presentation/widgets/create_note_sheet.dart';
import '../../../Note/presentation/widgets/notes_tab.dart';
import '../../../Note/data/models/note_model.dart';

import '../../data/models/space_model.dart';
import '../utils/space_color_service.dart';
import '../widgets/space_details/space_detail_header.dart';
import '../widgets/space_details/overview/section_header_link.dart';
import '../widgets/space_details/overview/task_preview_card.dart';
import '../widgets/space_details/overview/note_preview_card.dart';

import '../../../task/logic/task_cubit/task_cubit.dart';
import '../../../task/logic/task_cubit/task_state.dart';
import '../../../task/logic/subtask_cubit/subtask_cubit.dart';
import '../../../task/presentation/screens/tasks_list_view.dart';
import '../../../task/presentation/widgets/tasks_widgets/create_task_sheet.dart';
import '../../../task/enums/task_status.dart';
import '../../../task/data/models/task_model.dart';

// ─────────────────────────────────────────────────────────────

class SpaceDetailScreen extends StatelessWidget {
  final int workspaceId;
  final SpaceModel space;
  final bool isCurrentUserOwner;
  final List<String> userPermissions;

  /// ✅ Real data — لازم تتبعت من مكان فتح الشاشة (مثلاً workspace.numberOfMembers)
  /// (لسه مستخدمة بس في كارت TEAM في الـ stats row فوق)
  final int teamCount;

  const SpaceDetailScreen({
    super.key,
    required this.workspaceId,
    required this.space,
    required this.isCurrentUserOwner,
    required this.userPermissions,
    this.teamCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<TaskCubit>()..getTasks(workspaceId, space.id),
        ),
        BlocProvider(
          create: (ctx) => getIt<SubTaskCubit>(param1: ctx.read<TaskCubit>()),
        ),
        BlocProvider(
          create: (_) => getIt<NoteCubit>()..getNotes(workspaceId, space.id),
        ),
      ],
      child: _SpaceDetailBody(
        workspaceId: workspaceId,
        space: space,
        teamCount: teamCount,
        checker: PermissionChecker(
          isOwner: isCurrentUserOwner,
          permissions: userPermissions,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────

class _SpaceDetailBody extends StatefulWidget {
  final int workspaceId;
  final SpaceModel space;
  final int teamCount;
  final PermissionChecker checker;

  const _SpaceDetailBody({
    required this.workspaceId,
    required this.space,
    required this.teamCount,
    required this.checker,
  });

  @override
  State<_SpaceDetailBody> createState() => _SpaceDetailBodyState();
}

class _SpaceDetailBodyState extends State<_SpaceDetailBody> {
  late Color _color;

  @override
  void initState() {
    super.initState();
    _color = AppColors.primary;
    _loadColor();
  }

  Future<void> _loadColor() async {
    final c = await SpaceColorService.load(widget.space.id);
    if (mounted) setState(() => _color = c);
  }

  // ── Task actions ───────────────────────────────────────────

  void _openAddTask(BuildContext context) {
    if (!widget.checker.canCreateTask) return;
    final taskCubit = context.read<TaskCubit>();
    final subtaskCubit = context.read<SubTaskCubit>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (_) => CreateTaskSheet(
        accentColor: _color,
        onCreated: (title, description, priority, dueDate, subtasks) async {
          final newTask = await taskCubit.createTaskAndReturn(
            workspaceId: widget.workspaceId,
            spaceId: widget.space.id,
            title: title,
            description: description,
            priority: priority.toInt(),
            dueDate: dueDate,
          );
          for (final sub in subtasks) {
            await subtaskCubit.createSubTask(
              workspaceId: widget.workspaceId,
              spaceId: widget.space.id,
              taskId: newTask.id,
              title: sub,
            );
          }
        },
      ),
    );
  }

  // ── Note actions ───────────────────────────────────────────

  void _openAddNoteWithType(BuildContext context, String type) {
    if (!widget.checker.canCreateNote) return;
    final cubit = context.read<NoteCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (_) => CreateNoteSheet(
        accentColor: _color,
        onCreated: (title, plainText, noteType, colorIndex) async {
          final newNote = await cubit.createNoteAndReturn(
            workspaceId: widget.workspaceId,
            spaceId: widget.space.id,
            title: title,
            type: noteType,
            plainText: plainText.isEmpty ? null : plainText,
          );
          // نخزّن اللون اللي اليوزر اختاره مربوط بالنوت اللي اتعملت فعلاً
          await NoteColorService.save(newNote.id, colorIndex);
        },
      ),
    );
  }

  // ── Unified FAB creation sheet ─────────────────────────────
  void _openCreationSheet(BuildContext context) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) => _CreationSheet(
        accentColor: _color,
        canCreateTask: widget.checker.canCreateTask,
        canCreateNote: widget.checker.canCreateNote,
        onTask: () {
          Navigator.pop(sheetCtx);
          _openAddTask(context);
        },
        onNote: (type) {
          Navigator.pop(sheetCtx);
          _openAddNoteWithType(context, type);
        },
      ),
    );
  }

  // ── Space edit/delete ─────────────────────────────────────
  void _onEditSpace() {
    // TODO: open edit space sheet (EditSpaceSheet)
  }

  void _onDeleteSpace(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Delete Space?',
            style:
                GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700)),
        content: Text(
          'All tasks and notes inside this space will be permanently deleted. This cannot be undone.',
          style:
              GoogleFonts.poppins(fontSize: 12, color: AppColors.textMuted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: GoogleFonts.poppins(
                    fontSize: 13, color: AppColors.textMuted)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: call SpaceCubit.deleteSpace
            },
            child: Text('Delete',
                style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  // ── Preview helpers ─────────────────────────────────────────

  List<TaskModel> _previewTasks(List<TaskModel> tasks) {
    final notDone = tasks.where((t) => t.status != TaskStatus.done).toList();
    final done = tasks.where((t) => t.status == TaskStatus.done).toList();
    return [...notDone, ...done].take(3).toList();
  }

  List<NoteModel> _previewNotes(List<NoteModel> notes) {
    final pinned = notes.where((n) => n.isPinned).toList();
    final rest = notes.where((n) => !n.isPinned).toList();
    return [...pinned, ...rest].take(2).toList();
  }

  // ── View all navigation ─────────────────────────────────────

  void _openAllTasks(BuildContext context) {
    final taskCubit = context.read<TaskCubit>();
    final subtaskCubit = context.read<SubTaskCubit>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: taskCubit),
            BlocProvider.value(value: subtaskCubit),
          ],
          child: _AllTasksScreen(
            workspaceId: widget.workspaceId,
            space: widget.space,
            checker: widget.checker,
            accentColor: _color,
            onAddTask: () => _openAddTask(context),
          ),
        ),
      ),
    );
  }

  void _openAllNotes(BuildContext context) {
    final noteCubit = context.read<NoteCubit>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: noteCubit,
          child: _AllNotesScreen(
            workspaceId: widget.workspaceId,
            space: widget.space,
            checker: widget.checker,
            accentColor: _color,
          ),
        ),
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<TaskCubit, TaskState>(
          builder: (context, taskState) {
            final tasks =
                taskState is TasksSuccess ? taskState.data.items : <TaskModel>[];

            return BlocBuilder<NoteCubit, NoteState>(
              builder: (context, noteState) {
                final notes =
                    noteState is NotesSuccess ? noteState.data.items : <NoteModel>[];

                return SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 110),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context, tasks, notes),
                      const SizedBox(height: AppValues.paddingXl),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppValues.horizontalPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTasksSection(context, taskState, tasks),
                            const SizedBox(height: AppValues.paddingXl),
                            _buildNotesSection(context, noteState, notes),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab_create',
        onPressed: () => _openCreationSheet(context),
        backgroundColor: _color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 24),
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────
  Widget _buildHeader(
      BuildContext context, List<TaskModel> tasks, List<NoteModel> notes) {
    final doneCount = tasks.where((t) => t.status == TaskStatus.done).length;
    final totalTasks = tasks.length;
    final completionPct =
        totalTasks == 0 ? 0 : ((doneCount / totalTasks) * 100).round();
    final pinnedCount = notes.where((n) => n.isPinned).length;

    return SpaceDetailHeader(
      spaceName: widget.space.name,
      spaceDescription: widget.space.description ?? '',
      spaceIcon: widget.space.iconCode,
      color: _color,
      completionPct: completionPct,
      taskCount: totalTasks,
      doneCount: doneCount,
      noteCount: notes.length,
      pinnedNoteCount: pinnedCount,
      teamCount: widget.teamCount,
      onEdit: _onEditSpace,
      onDelete: () => _onDeleteSpace(context),
    );
  }

  // ── Tasks section ─────────────────────────────────────────
  Widget _buildTasksSection(
      BuildContext context, TaskState state, List<TaskModel> tasks) {
    final preview = _previewTasks(tasks);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeaderLink(
          title: 'Tasks',
          onViewAll: () => _openAllTasks(context),
        ),
        const SizedBox(height: AppValues.paddingMd),
        if (state is TaskLoading)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: CircularProgressIndicator(color: _color, strokeWidth: 2),
            ),
          )
        else if (preview.isEmpty)
          _EmptyHint(
            text: 'No tasks yet. Tap + to add one.',
            color: _color,
          )
        else
          ...preview.asMap().entries.map(
                (e) => TaskPreviewCard(
                  task: e.value,
                  index: e.key,
                  accentColor: _color,
                  onToggle: () {
                    final next = e.value.status == TaskStatus.done
                        ? TaskStatus.todo
                        : TaskStatus.done;
                    context.read<TaskCubit>().updateTaskStatus(
                          workspaceId: widget.workspaceId,
                          spaceId: widget.space.id,
                          taskId: e.value.id,
                          status: next.index,
                        );
                  },
                ),
              ),
      ],
    );
  }

  // ── Notes section ─────────────────────────────────────────
  Widget _buildNotesSection(
      BuildContext context, NoteState state, List<NoteModel> notes) {
    final preview = _previewNotes(notes);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeaderLink(
          title: 'Notes',
          onViewAll: () => _openAllNotes(context),
        ),
        const SizedBox(height: AppValues.paddingMd),
        if (state is NoteLoading)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: CircularProgressIndicator(color: _color, strokeWidth: 2),
            ),
          )
        else if (preview.isEmpty)
          _EmptyHint(
            text: 'No notes yet. Tap + to add one.',
            color: _color,
          )
        else
          ...preview.map(
            (n) => NotePreviewCard(
              note: n,
              accentColor: _color,
            ),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Empty state hint — نص بسيط لما القسم يكون فاضي
// ─────────────────────────────────────────────────────────────
class _EmptyHint extends StatelessWidget {
  final String text;
  final Color color;

  const _EmptyHint({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppValues.radiusLg + 4),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: GoogleFonts.poppins(fontSize: 12.5, color: AppColors.textMuted),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// "View all" — Full Tasks screen
// ─────────────────────────────────────────────────────────────
class _AllTasksScreen extends StatelessWidget {
  final int workspaceId;
  final SpaceModel space;
  final PermissionChecker checker;
  final Color accentColor;
  final VoidCallback onAddTask;

  const _AllTasksScreen({
    required this.workspaceId,
    required this.space,
    required this.checker,
    required this.accentColor,
    required this.onAddTask,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _SimpleHeader(title: '${space.name} · Tasks'),
            Expanded(
              child: BlocBuilder<TaskCubit, TaskState>(
                builder: (context, state) {
                  final tasks =
                      state is TasksSuccess ? state.data.items : <TaskModel>[];
                  if (state is TaskLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                          color: accentColor, strokeWidth: 2),
                    );
                  }
                  return TasksListView(
                    tasks: tasks,
                    accentColor: accentColor,
                    workspaceId: workspaceId,
                    spaceId: space.id,
                    canCreate: checker.canCreateTask,
                    onAddTask: onAddTask,
                    onEdit: (task) {
                      // TODO: open EditTaskSheet
                    },
                    onDelete: (task) => context.read<TaskCubit>().deleteTask(
                          workspaceId,
                          space.id,
                          task.id,
                        ),
                    onStatusChanged: (task, status) =>
                        context.read<TaskCubit>().updateTaskStatus(
                              workspaceId: workspaceId,
                              spaceId: space.id,
                              taskId: task.id,
                              status: status.index,
                            ),
                    onViewSwitch: () {},
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// "View all" — Full Notes screen
// ─────────────────────────────────────────────────────────────
class _AllNotesScreen extends StatelessWidget {
  final int workspaceId;
  final SpaceModel space;
  final PermissionChecker checker;
  final Color accentColor;

  const _AllNotesScreen({
    required this.workspaceId,
    required this.space,
    required this.checker,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _SimpleHeader(title: '${space.name} · Notes'),
            Expanded(
              child: NotesTab(
                workspaceId: workspaceId,
                spaceId: space.id,
                accentColor: accentColor,
                canCreate: checker.canCreateNote,
                onAddNote: () {
                  final cubit = context.read<NoteCubit>();
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    useSafeArea: true,
                    builder: (_) => CreateNoteSheet(
                      accentColor: accentColor,
                      onCreated: (title, plainText, type, colorIndex) async {
                        final newNote = await cubit.createNoteAndReturn(
                          workspaceId: workspaceId,
                          spaceId: space.id,
                          title: title,
                          type: type,
                          plainText: plainText.isEmpty ? null : plainText,
                        );
                        await NoteColorService.save(newNote.id, colorIndex);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Simple header للـ "View all" screens — back دائري + title
// ─────────────────────────────────────────────────────────────
class _SimpleHeader extends StatelessWidget {
  final String title;

  const _SimpleHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppValues.horizontalPadding, 14, AppValues.horizontalPadding, 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.14),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back_rounded,
                  color: AppColors.primary, size: 19),
            ),
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Unified Creation Sheet — FAB → Task / Note options
// ✅ عدّلنا الشيت بحيث تبقى كارت واحدة للـ Task وكارت واحدة للـ Note
//    (اختيار نوع النوت Text/Voice/Draw بقى جوه شاشة إنشاء النوت نفسها)
// ─────────────────────────────────────────────────────────────
class _CreationSheet extends StatelessWidget {
  final Color accentColor;
  final bool canCreateTask;
  final bool canCreateNote;
  final VoidCallback onTask;
  final void Function(String type) onNote;

  const _CreationSheet({
    required this.accentColor,
    required this.canCreateTask,
    required this.canCreateNote,
    required this.onTask,
    required this.onNote,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                  color: AppColors.cardBorder,
                  borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Create in this space',
            style: GoogleFonts.poppins(
                fontSize: 19,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark),
          ),
          const SizedBox(height: 14),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.55,
            children: [
              _SheetOption(
                icon: Icons.task_alt_rounded,
                label: 'New Task',
                desc: 'Add to this space',
                tint: accentColor,
                enabled: canCreateTask,
                onTap: onTask,
              ),
              _SheetOption(
                icon: Icons.notes_rounded,
                label: 'New Note',
                desc: 'Text, voice or draw',
                tint: const Color.fromARGB(255, 24, 109, 165),
                enabled: canCreateNote,
                onTap: () => onNote('Text'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text('Cancel',
                    style: GoogleFonts.poppins(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final String desc;
  final Color tint;
  final bool enabled;
  final VoidCallback onTap;

  const _SheetOption({
    required this.icon,
    required this.label,
    required this.desc,
    required this.tint,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.45,
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [tint.withOpacity(0.16), AppColors.white],
            ),
            borderRadius: BorderRadius.circular(AppValues.radiusLg + 4),
            border: Border.all(color: tint.withOpacity(0.18)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: tint,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(icon, color: AppColors.white, size: 20),
              ),
              const SizedBox(height: 10),
              Text(label,
                  style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark)),
              const SizedBox(height: 2),
              Text(desc,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                      fontSize: 11, color: AppColors.black.withOpacity(0.55))),
            ],
          ),
        ),
      ),
    );
  }
}