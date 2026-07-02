// lib/features/workspace/presentation/screens/space_detail_screen.dart

// lib/features/space/presentation/screens/space_detail_screen.dart

import 'package:ajenda_app/features/task/presentation/screens/tasks_list_view.dart';
import 'package:ajenda_app/features/task/presentation/widgets/tasks_widgets/create_task_sheet.dart';
import 'package:ajenda_app/features/task/presentation/widgets/tasks_widgets/kanban/kanban_board.dart';
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

// import '../../../task/presentation/screens/tasks_list_view.dart';
import '../../data/models/space_model.dart';
import '../utils/space_color_service.dart';
import '../widgets/space_details/space_detail_header.dart';

import '../../../task/logic/task_cubit/task_cubit.dart';
import '../../../task/logic/task_cubit/task_state.dart';
import '../../../task/logic/subtask_cubit/subtask_cubit.dart';
// import '../../../task/presentation/widgets/tasks_widgets/create_task_sheet.dart';
// import '../../../task/presentation/widgets/tasks_widgets/kanban/kanban_board.dart';
import '../../../task/enums/task_priority.dart';
import '../../../task/enums/task_status.dart';
import '../../../task/data/models/task_model.dart';

import '../widgets/space_details/analytics_tab.dart';

// ── View mode ─────────────────────────────────────────────────
enum _ViewMode { list, board }

class SpaceDetailScreen extends StatelessWidget {
  final int workspaceId;
  final SpaceModel space;
  final bool isCurrentUserOwner;
  final List<String> userPermissions;

  const SpaceDetailScreen({
    super.key,
    required this.workspaceId,
    required this.space,
    required this.isCurrentUserOwner,
    required this.userPermissions,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
          getIt<TaskCubit>()..getTasks(workspaceId, space.id),
        ),
        BlocProvider(
          create: (ctx) =>
              getIt<SubTaskCubit>(param1: ctx.read<TaskCubit>()),
        ),
        BlocProvider(
          create: (_) =>
          getIt<NoteCubit>()..getNotes(workspaceId, space.id),
        ),
      ],
      child: _SpaceDetailBody(
        workspaceId: workspaceId,
        space: space,
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
  final PermissionChecker checker;

  const _SpaceDetailBody({
    required this.workspaceId,
    required this.space,
    required this.checker,
  });

  @override
  State<_SpaceDetailBody> createState() => _SpaceDetailBodyState();
}

class _SpaceDetailBodyState extends State<_SpaceDetailBody>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  late Color _color;
  _ViewMode _viewMode = _ViewMode.list; // ✅ List كـ default

  @override
  void initState() {
    super.initState();
    _color = AppColors.primary;
    _loadColor();
    _tabCtrl = TabController(length: 3, vsync: this);
    _tabCtrl.addListener(() => setState(() {}));
  }

  Future<void> _loadColor() async {
    final c = await SpaceColorService.load(widget.space.id);
    if (mounted) setState(() => _color = c);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  // ── Computed stats helpers ─────────────────────────────────

  int _overdueCount(List<TaskModel> tasks) {
    final now = DateTime.now();
    return tasks
        .where((t) =>
    t.dueDate != null &&
        t.dueDate!.isBefore(now) &&
        t.status != TaskStatus.done)
        .length;
  }

  /// Returns the nearest upcoming due date label
  String? _nextDueLabel(List<TaskModel> tasks) {
    final upcoming = tasks
        .where((t) =>
    t.dueDate != null && t.status != TaskStatus.done)
        .toList()
      ..sort((a, b) => a.dueDate!.compareTo(b.dueDate!));

    if (upcoming.isEmpty) return null;
    final d = upcoming.first.dueDate!;
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[d.month - 1]} ${d.day}';
  }

  String? _nextDueDaysLabel(List<TaskModel> tasks) {
    final upcoming = tasks
        .where((t) =>
    t.dueDate != null && t.status != TaskStatus.done)
        .toList()
      ..sort((a, b) => a.dueDate!.compareTo(b.dueDate!));

    if (upcoming.isEmpty) return null;
    final d = upcoming.first.dueDate!;
    final diff = d.difference(DateTime.now()).inDays;
    if (diff < 0) return 'Overdue';
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Tomorrow';
    return '$diff days';
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

  void _openAddNote(BuildContext context) {
    if (!widget.checker.canCreateNote) return;
    final cubit = context.read<NoteCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (_) => CreateNoteSheet(
        accentColor: _color,
        onCreated: (title, plainText, type, colorIndex) =>
            cubit.createNoteAndReturn(
              workspaceId: widget.workspaceId,
              spaceId: widget.space.id,
              title: title,
              type: type,
              plainText: plainText.isEmpty ? null : plainText,
            ),
      ),
    );
  }

  // ── Unified FAB creation sheet ─────────────────────────────
  // مطابق للـ HTML: FAB دايماً ظاهر ويفتح bottom sheet بـ 4 خيارات
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
        onCreated: (title, plainText, noteType, colorIndex) =>
            cubit.createNoteAndReturn(
              workspaceId: widget.workspaceId,
              spaceId: widget.space.id,
              title: title,
              type: noteType,
              plainText: plainText.isEmpty ? null : plainText,
            ),
      ),
    );
  }

  // ── Space edit/delete ─────────────────────────────────────
  void _onEditSpace() {
    // TODO: open edit space sheet
  }

  void _onDeleteSpace(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        title: Text('Delete Space?',
            style: GoogleFonts.poppins(
                fontSize: 15, fontWeight: FontWeight.w700)),
        content: Text(
          'All tasks and notes inside this space will be permanently deleted. This cannot be undone.',
          style: GoogleFonts.poppins(
              fontSize: 12, color: AppColors.textMuted),
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

  // ── Build ──────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── Header (depends on both task + note state) ──
            _buildHeader(context),

            // ── Underline Tab Bar ───────────────────────────
            _buildTabBar(context),

            // ── Tab Content ─────────────────────────────────
            Expanded(
              child: BlocBuilder<TaskCubit, TaskState>(
                builder: (context, taskState) {
                  final tasks = taskState is TasksSuccess
                      ? taskState.data.items
                      : <TaskModel>[];
                  return TabBarView(
                    controller: _tabCtrl,
                    children: [
                      _buildTasksTab(context, taskState, tasks),
                      _buildNotesTab(),
                      _buildAnalyticsTab(context, taskState),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      // ── Unified FAB ─────────────────────────────────────
      floatingActionButton: _tabCtrl.index != 2
          ? FloatingActionButton(
        heroTag: 'fab_create',
        onPressed: () => _openCreationSheet(context),
        backgroundColor: _color,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14)),
        child:
        const Icon(Icons.add_rounded, color: Colors.white, size: 24),
      )
          : null,
    );
  }

  // ── Header widget ─────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    return BlocBuilder<TaskCubit, TaskState>(
      builder: (ctx, taskState) {
        return BlocBuilder<NoteCubit, NoteState>(
          builder: (ctx2, noteState) {
            final tasks = taskState is TasksSuccess
                ? taskState.data.items
                : <TaskModel>[];
            final doneCount =
                tasks.where((t) => t.status == TaskStatus.done).length;
            final totalTasks = tasks.length;
            final completionPct = totalTasks == 0
                ? 0
                : ((doneCount / totalTasks) * 100).round();

            final notes = noteState is NotesSuccess
                ? noteState.data.items
                : [];
            final pinnedCount =
                notes.where((n) => n.isPinned).length;

            return SpaceDetailHeader(
              spaceName: widget.space.name,
              spaceDescription: widget.space.description ?? '',
              spaceIcon: widget.space.iconCode,
              color: _color,
              completionPct: completionPct,
              taskCount: totalTasks,
              doneCount: doneCount,
              overdueCount: _overdueCount(tasks),
              noteCount: notes.length,
              pinnedNoteCount: pinnedCount,
              nextDueLabel: _nextDueLabel(tasks),
              nextDueDaysLabel: _nextDueDaysLabel(tasks),
              onEdit: _onEditSpace,
              onDelete: () => _onDeleteSpace(context),
            );
          },
        );
      },
    );
  }

  // ── Underline Tab Bar — مطابق للـ HTML ─────────────────────
  Widget _buildTabBar(BuildContext context) {
    return BlocBuilder<TaskCubit, TaskState>(
      builder: (ctx, taskState) {
        return BlocBuilder<NoteCubit, NoteState>(
          builder: (ctx2, noteState) {
            final taskCount = taskState is TasksSuccess
                ? taskState.data.items.length
                : 0;
            final noteCount = noteState is NotesSuccess
                ? noteState.data.items.length
                : 0;

            return Container(
              color: AppColors.white,
              child: TabBar(
                controller: _tabCtrl,
                // ── Underline style ──
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(color: _color, width: 2.5),
                  insets: const EdgeInsets.symmetric(horizontal: 16),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                splashFactory: NoSplash.splashFactory,
                overlayColor:
                MaterialStateProperty.all(Colors.transparent),
                dividerColor:
                AppColors.primary.withOpacity(0.08),
                labelPadding: EdgeInsets.zero,
                labelColor: _color,
                unselectedLabelColor: AppColors.textMuted,
                tabs: [
                  _TabItem(
                    icon: Icons.check_circle_outline_rounded,
                    label: 'Tasks',
                    count: taskCount,
                    isSelected: _tabCtrl.index == 0,
                    activeColor: _color,
                  ),
                  _TabItem(
                    icon: Icons.sticky_note_2_outlined,
                    label: 'Notes',
                    count: noteCount,
                    isSelected: _tabCtrl.index == 1,
                    activeColor: _color,
                  ),
                  _TabItem(
                    icon: Icons.bar_chart_rounded,
                    label: 'Analytics',
                    count: null,
                    isSelected: _tabCtrl.index == 2,
                    activeColor: _color,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ── Tasks Tab ─────────────────────────────────────────────
  Widget _buildTasksTab(
      BuildContext context, TaskState state, List<TaskModel> tasks) {
    if (state is TaskLoading) {
      return Center(
        child: CircularProgressIndicator(color: _color, strokeWidth: 2),
      );
    }
    if (state is TaskError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded,
                color: AppColors.error, size: 32),
            const SizedBox(height: 10),
            Text(state.message,
                style: GoogleFonts.poppins(
                    fontSize: 12, color: AppColors.textMuted),
                textAlign: TextAlign.center),
            const SizedBox(height: 14),
            GestureDetector(
              onTap: () => context
                  .read<TaskCubit>()
                  .getTasks(widget.workspaceId, widget.space.id),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 18, vertical: 9),
                decoration: BoxDecoration(
                    color: _color,
                    borderRadius: BorderRadius.circular(10)),
                child: Text('Retry',
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

    // ── View switcher: List ↔ Board ──────────────────────────
    if (_viewMode == _ViewMode.list) {
      return TasksListView(
        tasks: tasks,
        accentColor: _color,
        workspaceId: widget.workspaceId,
        spaceId: widget.space.id,
        canCreate: widget.checker.canCreateTask,
        onAddTask: () => _openAddTask(context),
        onEdit: (task) {
          // TODO: open EditTaskSheet
        },
        onDelete: (task) => context.read<TaskCubit>().deleteTask(
          widget.workspaceId,
          widget.space.id,
          task.id,
        ),
        onStatusChanged: (task, status) =>
            context.read<TaskCubit>().updateTaskStatus(
              workspaceId: widget.workspaceId,
              spaceId: widget.space.id,
              taskId: task.id,
              status: status.index,
            ),
        // ✅ Switch to Board view
        onViewSwitch: () => setState(() => _viewMode = _ViewMode.board),
      );
    }

    // ── Board view ───────────────────────────────────────────
    return KanbanBoard(
      tasks: tasks,
      accentColor: _color,
      workspaceId: widget.workspaceId,
      spaceId: widget.space.id,
      onAddTask: widget.checker.canCreateTask
          ? () => _openAddTask(context)
          : null,
      onTaskAdded: (title, description, priority, dueDate, subtasks) async {
        final taskCubit = context.read<TaskCubit>();
        final subtaskCubit = context.read<SubTaskCubit>();
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
      onStatusChanged: (task, status) =>
          context.read<TaskCubit>().updateTaskStatus(
            workspaceId: widget.workspaceId,
            spaceId: widget.space.id,
            taskId: task.id,
            status: status,
          ),
      onDelete: (task) => context.read<TaskCubit>().deleteTask(
        widget.workspaceId,
        widget.space.id,
        task.id,
      ),
    );
  }

  // ── Notes Tab ─────────────────────────────────────────────
  Widget _buildNotesTab() {
    return NotesTab(
      workspaceId: widget.workspaceId,
      spaceId: widget.space.id,
      accentColor: _color,
      canCreate: widget.checker.canCreateNote,
      onAddNote: () => _openAddNote(context),
    );
  }

  // ── Analytics Tab ─────────────────────────────────────────
  Widget _buildAnalyticsTab(BuildContext context, TaskState taskState) {
    return BlocBuilder<NoteCubit, NoteState>(
      builder: (ctx, noteState) {
        return AnalyticsTab(
          tasks: taskState is TasksSuccess
              ? taskState.data.items
              : [],
          // notes: noteState is NotesSuccess
          //     ? noteState.data.items
          //     : [],
          accentColor: _color,
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Tab Item Widget — icon + label + optional badge
// مطابق للـ HTML: .tab .tab-badge
// ─────────────────────────────────────────────────────────────
class _TabItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int? count;
  final bool isSelected;
  final Color activeColor;

  const _TabItem({
    required this.icon,
    required this.label,
    required this.count,
    required this.isSelected,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Tab(
      height: 44,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14),
          const SizedBox(width: 4),
          Text(label),
          if (count != null && count! > 0) ...[
            const SizedBox(width: 4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(
                  horizontal: 5, vertical: 1),
              decoration: BoxDecoration(
                color: isSelected
                    ? activeColor
                    : AppColors.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$count',
                style: GoogleFonts.poppins(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: isSelected
                      ? AppColors.white
                      : AppColors.textMuted,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Unified Creation Sheet — مطابق للـ HTML sheet
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
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
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark),
          ),
          const SizedBox(height: 14),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 2.2,
            children: [
              _SheetOption(
                emoji: '✅',
                label: 'New Task',
                desc: 'Add to this space',
                enabled: canCreateTask,
                onTap: onTask,
              ),
              _SheetOption(
                emoji: '📝',
                label: 'Text Note',
                desc: 'Write anything',
                enabled: canCreateNote,
                onTap: () => onNote('Text'),
              ),
              _SheetOption(
                emoji: '🎙️',
                label: 'Voice Note',
                desc: 'Record audio',
                enabled: canCreateNote,
                onTap: () => onNote('Voice'),
              ),
              _SheetOption(
                emoji: '✏️',
                label: 'Draw Note',
                desc: 'Sketch ideas',
                enabled: canCreateNote,
                onTap: () => onNote('HandDraw'),
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
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textMuted)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetOption extends StatelessWidget {
  final String emoji;
  final String label;
  final String desc;
  final bool enabled;
  final VoidCallback onTap;

  const _SheetOption({
    required this.emoji,
    required this.label,
    required this.desc,
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
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(11),
          ),
          padding: const EdgeInsets.symmetric(
              horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(label,
                        style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark)),
                    Text(desc,
                        style: GoogleFonts.poppins(
                            fontSize: 9,
                            color: AppColors.textMuted)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}







/*
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../config/dependency_injection.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_values.dart';
import '../../../../core/constants/app_widget_styles.dart';
import '../../../../core/utils/permission_checker.dart';
import '../../../Note/logic/note_cubit/note_cubit.dart';
import '../../../Note/presentation/widgets/create_note_sheet.dart';
import '../../../Note/presentation/widgets/notes_tab.dart';
import '../../data/models/space_model.dart';
import '../utils/space_color_service.dart';

import '../../../task/logic/task_cubit/task_cubit.dart';
import '../../../task/logic/task_cubit/task_state.dart';
import '../../../task/logic/subtask_cubit/subtask_cubit.dart';
import '../../../task/presentation/widgets/tasks_widgets/create_task_sheet.dart';
import '../../../task/presentation/widgets/tasks_widgets/kanban/kanban_board.dart';

import '../widgets/space_details/analytics_tab.dart';
import '../widgets/space_details/space_detail_header.dart';

class SpaceDetailScreen extends StatelessWidget {
  final int workspaceId;
  final SpaceModel space;
  final bool isCurrentUserOwner;
  final List<String> userPermissions;

  const SpaceDetailScreen({
    super.key,
    required this.workspaceId,
    required this.space,
    required this.isCurrentUserOwner,
    required this.userPermissions,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<TaskCubit>()..getTasks(workspaceId, space.id),
        ),
        BlocProvider(
          create: (ctx) =>
              getIt<SubTaskCubit>(param1: ctx.read<TaskCubit>()),
        ),
        BlocProvider(
          create: (_) =>
          getIt<NoteCubit>()..getNotes(workspaceId, space.id),
        ),
      ],
      child: _SpaceDetailBody(
        workspaceId: workspaceId,
        space: space,
        checker: PermissionChecker(
          isOwner: isCurrentUserOwner,
          permissions: userPermissions,
        ),
      ),
    );
  }
}

class _SpaceDetailBody extends StatefulWidget {
  final int workspaceId;
  final SpaceModel space;
  final PermissionChecker checker;

  const _SpaceDetailBody({
    required this.workspaceId,
    required this.space,
    required this.checker,
  });

  @override
  State<_SpaceDetailBody> createState() => _SpaceDetailBodyState();
}

class _SpaceDetailBodyState extends State<_SpaceDetailBody>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  late Color _color;

  static const _tabData = [
    (icon: Icons.check_circle_outline_rounded, label: 'Tasks'),
    (icon: Icons.sticky_note_2_outlined,       label: 'Notes'),
    (icon: Icons.bar_chart_rounded,            label: 'Analytics'),
  ];

  @override
  void initState() {
    super.initState();
    _color = AppColors.primary;
    _loadColor();
    _tabCtrl = TabController(length: 3, vsync: this);
    _tabCtrl.addListener(() => setState(() {})); // rebuild on tab change
  }

  Future<void> _loadColor() async {
    final c = await SpaceColorService.load(widget.space.id);
    if (mounted) setState(() => _color = c);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  // ── FAB logic ─────────────────────────────────────────────

  /// Tab 0 → Add Task (لو عنده permission)
  /// Tab 1 → Add Note (لو عنده permission)
  /// Tab 2 → Analytics → مفيش FAB
  Widget? _buildFab(BuildContext context) {
    final tabIdx = _tabCtrl.index;

    if (tabIdx == 0 && widget.checker.canCreateTask) {
      return FloatingActionButton(
        heroTag: 'fab_task',
        onPressed: () => _openAddTask(context),
        backgroundColor: _color,
        child: const Icon(Icons.add_rounded, color: Colors.white),
      );
    }

    if (tabIdx == 1 && widget.checker.canCreateNote) {
      return FloatingActionButton(
        heroTag: 'fab_note',
        onPressed: () => _openAddNote(context),
        backgroundColor: _color,
        child: const Icon(Icons.note_add_rounded, color: Colors.white),
      );
    }

    return null; // Analytics tab — no FAB
  }

  void _openAddTask(BuildContext context) {
    final taskCubit    = context.read<TaskCubit>();
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
            spaceId:     widget.space.id,
            title:       title,
            description: description,
            priority:    priority.toInt(),
            dueDate:     dueDate,
          );
          for (final sub in subtasks) {
            await subtaskCubit.createSubTask(
              workspaceId: widget.workspaceId,
              spaceId:     widget.space.id,
              taskId:      newTask.id,
              title:       sub,
            );
          }
        },
      ),
    );
  }

  void _openAddNote(BuildContext context) {
    final cubit = context.read<NoteCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (_) => CreateNoteSheet(
        accentColor: _color,
        // بعد ✅
        onCreated: (title, plainText, type, colorIndex) => cubit.createNoteAndReturn(
          workspaceId: widget.workspaceId,
          spaceId:     widget.space.id,
          title:       title,
          type:        type,
          plainText:   plainText.isEmpty ? null : plainText,
          // colorIndex متاح لو الـ backend هيدعمه بعدين
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned(
            top: -40,
            right: -30,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  _color.withOpacity(0.14),
                  Colors.transparent,
                ]),
              ),
            ),
          ),
          SafeArea(
            child: BlocBuilder<TaskCubit, TaskState>(
              builder: (context, state) {
                final tasks =
                state is TasksSuccess ? state.data.items : <dynamic>[];
                final doneCount =
                    tasks.where((t) => t.status.index == 2).length;

                return Column(
                  children: [
                    SpaceDetailHeader(
                      spaceName:        widget.space.name,
                      spaceDescription: widget.space.description ?? '',
                      spaceIcon:        widget.space.iconCode,
                      color:            _color,
                      taskCount:        tasks.length,
                      noteCount:        0, // TODO: من NoteCubit
                      doneCount:        doneCount,
                    ),

                    // Tab Bar
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: AppValues.horizontalPadding,
                        vertical: AppValues.paddingSm,
                      ),
                      height: AppValues.tabBarHeight,
                      decoration:
                      AppWidgetStyles.pillTabContainer(_color),
                      child: TabBar(
                        controller: _tabCtrl,
                        indicator: AppWidgetStyles.pillTabIndicator(_color),
                        indicatorSize: TabBarIndicatorSize.tab,
                        splashFactory: NoSplash.splashFactory,
                        overlayColor: MaterialStateProperty.all(
                            Colors.transparent),
                        dividerColor: Colors.transparent,
                        labelPadding: EdgeInsets.zero,
                        padding: const EdgeInsets.all(
                            AppValues.tabBarInnerPadding),
                        labelStyle: GoogleFonts.poppins(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700),
                        unselectedLabelStyle: GoogleFonts.poppins(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500),
                        labelColor: Colors.white,
                        unselectedLabelColor: AppColors.textDark,
                        tabs: _tabData
                            .map((t) => Tab(
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(t.icon, size: 15),
                              const SizedBox(width: 5),
                              Text(t.label),
                            ],
                          ),
                        ))
                            .toList(),
                      ),
                    ),

                    // Tab Content
                    Expanded(
                      child: TabBarView(
                        controller: _tabCtrl,
                        children: [
                          // Tab 0: Tasks
                          _buildTasksTab(context, state, tasks),

                          // Tab 1: Notes
                          NotesTab(
                            workspaceId: widget.workspaceId,
                            spaceId:     widget.space.id,
                            accentColor: _color,
                            canCreate:   widget.checker.canCreateNote,
                            // [FIX] الـ "New Note" button في الـ tab نفسه
                            // بيشتغل مع الـ FAB — الاتنين بيعملوا نفس الحاجة
                            onAddNote: () => _openAddNote(context),
                          ),

                          // Tab 2: Analytics
                          AnalyticsTab(
                            tasks: state is TasksSuccess
                                ? state.data.items
                                : [],
                            accentColor: _color,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),

      // [FIX] FAB context-aware — بيتغير حسب الـ active tab
      floatingActionButton: Builder(
        builder: (ctx) => _buildFab(ctx) ?? const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildTasksTab(
      BuildContext context, TaskState state, List tasks) {
    if (state is TaskLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }
    if (state is TaskError) {
      return Center(
        child: Text(state.message,
            style: GoogleFonts.poppins(
                fontSize: 13, color: AppColors.textMuted)),
      );
    }
    if (state is TasksSuccess) {
      return KanbanBoard(
        tasks:       state.data.items,
        accentColor: _color,
        workspaceId: widget.workspaceId,
        spaceId:     widget.space.id,
        onAddTask:   widget.checker.canCreateTask
            ? () => _openAddTask(context)
            : null,
        onTaskAdded: (title, description, priority, dueDate,
            subtasks) async {
          final taskCubit    = context.read<TaskCubit>();
          final subtaskCubit = context.read<SubTaskCubit>();
          final newTask = await taskCubit.createTaskAndReturn(
            workspaceId: widget.workspaceId,
            spaceId:     widget.space.id,
            title:       title,
            description: description,
            priority:    priority.toInt(),
            dueDate:     dueDate,
          );
          for (final sub in subtasks) {
            await subtaskCubit.createSubTask(
              workspaceId: widget.workspaceId,
              spaceId:     widget.space.id,
              taskId:      newTask.id,
              title:       sub,
            );
          }
        },
        onStatusChanged: (task, status) =>
            context.read<TaskCubit>().updateTaskStatus(
              workspaceId: widget.workspaceId,
              spaceId:     widget.space.id,
              taskId:      task.id,
              status:      status,
            ),
        onDelete: (task) => context.read<TaskCubit>().deleteTask(
          widget.workspaceId,
          widget.space.id,
          task.id,
        ),
      );
    }
    return const SizedBox.shrink();
  }
}



 */