
// lib/features/space/presentation/widgets/space_details/tasks_list_view.dart
//
// FIX: أزلنا الـ duplicate import لـ delete_confirm_sheet.dart
//      (كان مستورد مرتين بـ paths مختلفة)
// REDESIGN: مطابق للـ HTML list view
//   • view switcher (List active / Board)
//   • Create button
//   • swipe hint
//   • collapsible status groups
//   • SwipeableTaskRow per task

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_values.dart';
import '../../../../../features/task/data/models/task_model.dart';
import '../../../../../features/task/enums/task_status.dart';
import '../../../../../features/task/presentation/widgets/tasks_widgets/kanban/delete_confirm_sheet.dart';
import '../../../../../features/task/presentation/widgets/tasks_widgets/swipeable_task_row.dart';

// ─────────────────────────────────────────────────────────────
class TasksListView extends StatefulWidget {
  final List<TaskModel> tasks;
  final Color accentColor;
  final int workspaceId;
  final String spaceId;
  final bool canCreate;

  final VoidCallback? onAddTask;
  final void Function(TaskModel task)? onEdit;
  final void Function(TaskModel task)? onDelete;
  final void Function(TaskModel task, TaskStatus status)? onStatusChanged;
  final VoidCallback? onViewSwitch; // → Board view

  const TasksListView({
    super.key,
    required this.tasks,
    required this.accentColor,
    required this.workspaceId,
    required this.spaceId,
    this.canCreate = false,
    this.onAddTask,
    this.onEdit,
    this.onDelete,
    this.onStatusChanged,
    this.onViewSwitch,
  });

  @override
  State<TasksListView> createState() => _TasksListViewState();
}

class _TasksListViewState extends State<TasksListView> {
  // Done group يبدأ collapsed — To Do و In Progress مفتوحين
  final Map<TaskStatus, bool> _collapsed = {
    TaskStatus.todo:       false,
    TaskStatus.inProgress: false,
    TaskStatus.done:       true,
  };

  static const _groups = [
    (status: TaskStatus.todo,       label: 'To Do',       dotColor: AppColors.error),
    (status: TaskStatus.inProgress, label: 'In Progress', dotColor: AppColors.warning),
    (status: TaskStatus.done,       label: 'Done',        dotColor: AppColors.success),
  ];

  List<TaskModel> _tasksFor(TaskStatus s) =>
      widget.tasks.where((t) => t.status == s).toList();

  int get _active =>
      widget.tasks.where((t) => t.status != TaskStatus.done).length;

  int get _doneCount =>
      widget.tasks.where((t) => t.status == TaskStatus.done).length;

  int get _overdue {
    final now = DateTime.now();
    return widget.tasks
        .where((t) =>
    t.dueDate != null &&
        t.dueDate!.isBefore(now) &&
        t.status != TaskStatus.done)
        .length;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildViewSwitcherRow(),
        const SizedBox(height: 10),
        Expanded(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              AppValues.horizontalPadding, 0,
              AppValues.horizontalPadding, 24,
            ),
            children: [
              if (widget.canCreate) ...[
                _buildCreateButton(),
                const SizedBox(height: 8),
              ],
              _buildSwipeHint(),
              const SizedBox(height: 8),
              for (final g in _groups)
                _buildGroup(g.status, g.label, g.dotColor),
            ],
          ),
        ),
      ],
    );
  }

  // ── View Switcher Row ─────────────────────────────────────
  Widget _buildViewSwitcherRow() {
    final overdueText =
    _overdue > 0 ? ' · $_overdue overdue' : '';
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppValues.horizontalPadding, 10,
          AppValues.horizontalPadding, 0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '$_active active · $_doneCount done$overdueText',
              style: GoogleFonts.poppins(
                  fontSize: 10, color: AppColors.textMuted),
            ),
          ),
          // View switcher — مطابق للـ HTML .view-btns
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: AppColors.primary.withOpacity(0.12),
                  width: 0.5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // List — active (purple)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: widget.accentColor,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Text('List',
                      style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white)),
                ),
                // Board — tap to switch
                GestureDetector(
                  onTap: widget.onViewSwitch,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    child: Text('Board',
                        style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textMuted)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Create button ─────────────────────────────────────────
  Widget _buildCreateButton() {
    return GestureDetector(
      onTap: widget.onAddTask,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: widget.accentColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: widget.accentColor.withOpacity(0.28),
                blurRadius: 10,
                offset: const Offset(0, 3)),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_rounded,
                color: AppColors.white, size: 15),
            const SizedBox(width: 6),
            Text('Create New Task',
                style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white)),
          ],
        ),
      ),
    );
  }

  // ── Swipe hint ────────────────────────────────────────────
  Widget _buildSwipeHint() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.swap_horiz_rounded,
            size: 11,
            color: AppColors.textMuted.withOpacity(0.5)),
        const SizedBox(width: 4),
        Text(
          'Swipe left → edit/delete  ·  Swipe right → done',
          style: GoogleFonts.poppins(
              fontSize: 9,
              color: AppColors.textMuted.withOpacity(0.5)),
        ),
      ],
    );
  }

  // ── Status group ──────────────────────────────────────────
  Widget _buildGroup(
      TaskStatus status, String label, Color dotColor) {
    final items = _tasksFor(status);
    final isCollapsed = _collapsed[status] ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Group header (collapsible)
        GestureDetector(
          onTap: () =>
              setState(() => _collapsed[status] = !isCollapsed),
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 7),
            child: Row(
              children: [
                Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                        color: dotColor,
                        shape: BoxShape.circle)),
                const SizedBox(width: 5),
                Text(label,
                    style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark)),
                const SizedBox(width: 5),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 5, vertical: 1),
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(6)),
                  child: Text('${items.length}',
                      style: GoogleFonts.poppins(
                          fontSize: 9,
                          color: AppColors.textMuted)),
                ),
                const Spacer(),
                AnimatedRotation(
                  turns: isCollapsed ? -0.25 : 0,
                  duration: const Duration(milliseconds: 180),
                  child: Icon(Icons.keyboard_arrow_down_rounded,
                      size: 16, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
        ),

        // Group body
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 180),
          crossFadeState: isCollapsed
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          firstChild: Column(
            children: [
              ...items.map((task) => Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: SwipeableTaskRow(
                  key: ValueKey(task.id),
                  task: task,
                  accentColor: widget.accentColor,
                  onDone: () => widget.onStatusChanged?.call(
                    task,
                    task.status == TaskStatus.done
                        ? TaskStatus.todo
                        : TaskStatus.done,
                  ),
                  onEdit: () => widget.onEdit?.call(task),
                  onDelete: () => showDeleteConfirmSheet(
                    context: context,
                    type: DeleteType.task,
                    itemName: task.title,
                    accentColor: widget.accentColor,
                    onConfirm: () => widget.onDelete?.call(task),
                  ),
                ),
              )),
              // Add row for non-done groups
              if (status != TaskStatus.done && widget.canCreate)
                _buildAddRow(),
              const SizedBox(height: 4),
            ],
          ),
          secondChild: const SizedBox.shrink(),
        ),
      ],
    );
  }

  // ── Dashed add row ────────────────────────────────────────
  Widget _buildAddRow() {
    return GestureDetector(
      onTap: widget.onAddTask,
      child: Container(
        height: 34,
        margin: const EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
          border: Border.all(
              color: widget.accentColor.withOpacity(0.20),
              width: 1.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_rounded,
                size: 12, color: AppColors.textMuted),
            const SizedBox(width: 4),
            Text('Add task',
                style: GoogleFonts.poppins(
                    fontSize: 9.5,
                    color: AppColors.textMuted)),
          ],
        ),
      ),
    );
  }
}


// // lib/features/workspace/presentation/widgets/space_details/tasks_list_view.dart
// //
// // REDESIGN — import paths مصلحة + مطابق للـ HTML list view
//
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// import '../../../../../core/constants/app_colors.dart';
// import '../../../../../core/constants/app_values.dart';
//
// // ✅ Fixed imports — relative من workspace/presentation/widgets/space_details/
// import '../../../../../features/task/data/models/task_model.dart';
// import '../../../../../features/task/enums/task_status.dart';
// import '../../../../../features/task/presentation/widgets/tasks_widgets/kanban/delete_confirm_sheet.dart';
// import '../../../../../features/task/presentation/widgets/tasks_widgets/swipeable_task_row.dart';
// import '../widgets/tasks_widgets/kanban/delete_confirm_sheet.dart';
//
// // ─────────────────────────────────────────────────────────────
// class TasksListView extends StatefulWidget {
//   final List<TaskModel> tasks;
//   final Color accentColor;
//   final int workspaceId;
//   final String spaceId;
//   final bool canCreate;
//
//   final VoidCallback? onAddTask;
//   final void Function(TaskModel task)? onEdit;
//   final void Function(TaskModel task)? onDelete;
//   final void Function(TaskModel task, TaskStatus status)? onStatusChanged;
//   final VoidCallback? onViewSwitch; // → Board view
//
//   const TasksListView({
//     super.key,
//     required this.tasks,
//     required this.accentColor,
//     required this.workspaceId,
//     required this.spaceId,
//     this.canCreate = false,
//     this.onAddTask,
//     this.onEdit,
//     this.onDelete,
//     this.onStatusChanged,
//     this.onViewSwitch,
//   });
//
//   @override
//   State<TasksListView> createState() => _TasksListViewState();
// }
//
// class _TasksListViewState extends State<TasksListView> {
//   final Map<TaskStatus, bool> _collapsed = {
//     TaskStatus.todo:       false,
//     TaskStatus.inProgress: false,
//     TaskStatus.done:       true,
//   };
//
//   static const _groups = [
//     (status: TaskStatus.todo,       label: 'To Do',       dotColor: AppColors.error),
//     (status: TaskStatus.inProgress, label: 'In Progress',  dotColor: AppColors.warning),
//     (status: TaskStatus.done,       label: 'Done',         dotColor: AppColors.success),
//   ];
//
//   List<TaskModel> _tasksFor(TaskStatus s) =>
//       widget.tasks.where((t) => t.status == s).toList();
//
//   int get _active   => widget.tasks.where((t) => t.status != TaskStatus.done).length;
//   int get _doneCount => widget.tasks.where((t) => t.status == TaskStatus.done).length;
//   int get _overdue {
//     final now = DateTime.now();
//     return widget.tasks.where((t) =>
//     t.dueDate != null &&
//         t.dueDate!.isBefore(now) &&
//         t.status != TaskStatus.done
//     ).length;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         _buildViewSwitcherRow(),
//         const SizedBox(height: 10),
//         Expanded(
//           child: ListView(
//             physics: const BouncingScrollPhysics(),
//             padding: const EdgeInsets.fromLTRB(
//               AppValues.horizontalPadding, 0,
//               AppValues.horizontalPadding, 24,
//             ),
//             children: [
//               if (widget.canCreate) ...[
//                 _buildCreateButton(),
//                 const SizedBox(height: 8),
//               ],
//               _buildSwipeHint(),
//               const SizedBox(height: 8),
//               for (final g in _groups)
//                 _buildGroup(g.status, g.label, g.dotColor),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildViewSwitcherRow() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: AppValues.horizontalPadding),
//       child: Row(
//         children: [
//           Expanded(
//             child: Text(
//               '$_active active · $_doneCount done${_overdue > 0 ? ' · $_overdue overdue' : ''}',
//               style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textMuted),
//             ),
//           ),
//           Container(
//             decoration: BoxDecoration(
//               color: AppColors.background,
//               borderRadius: BorderRadius.circular(8),
//               border: Border.all(color: AppColors.primary.withOpacity(0.12), width: 0.5),
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: widget.accentColor,
//                     borderRadius: BorderRadius.circular(7),
//                   ),
//                   child: Text('List',
//                       style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.white)),
//                 ),
//                 GestureDetector(
//                   onTap: widget.onViewSwitch,
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                     child: Text('Board',
//                         style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textMuted)),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCreateButton() {
//     return GestureDetector(
//       onTap: widget.onAddTask,
//       child: Container(
//         height: 40,
//         decoration: BoxDecoration(
//           color: widget.accentColor,
//           borderRadius: BorderRadius.circular(10),
//           boxShadow: [
//             BoxShadow(color: widget.accentColor.withOpacity(0.28), blurRadius: 10, offset: const Offset(0, 3)),
//           ],
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.add_rounded, color: AppColors.white, size: 15),
//             const SizedBox(width: 6),
//             Text('Create New Task',
//                 style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.white)),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSwipeHint() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Icon(Icons.swap_horiz_rounded, size: 11, color: AppColors.textMuted.withOpacity(0.6)),
//         const SizedBox(width: 4),
//         Text(
//           'Swipe task left to edit/delete · right to done',
//           style: GoogleFonts.poppins(fontSize: 9, color: AppColors.textMuted.withOpacity(0.6)),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildGroup(TaskStatus status, String label, Color dotColor) {
//     final items      = _tasksFor(status);
//     final isCollapsed = _collapsed[status] ?? false;
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         GestureDetector(
//           onTap: () => setState(() => _collapsed[status] = !isCollapsed),
//           behavior: HitTestBehavior.opaque,
//           child: Padding(
//             padding: const EdgeInsets.symmetric(vertical: 7),
//             child: Row(
//               children: [
//                 Container(width: 7, height: 7,
//                     decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle)),
//                 const SizedBox(width: 5),
//                 Text(label, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textDark)),
//                 const SizedBox(width: 5),
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
//                   decoration: BoxDecoration(color: Colors.black.withOpacity(0.06), borderRadius: BorderRadius.circular(6)),
//                   child: Text('${items.length}', style: GoogleFonts.poppins(fontSize: 9, color: AppColors.textMuted)),
//                 ),
//                 const Spacer(),
//                 AnimatedRotation(
//                   turns: isCollapsed ? -0.25 : 0,
//                   duration: const Duration(milliseconds: 180),
//                   child: Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: AppColors.textMuted),
//                 ),
//               ],
//             ),
//           ),
//         ),
//
//         AnimatedCrossFade(
//           duration: const Duration(milliseconds: 180),
//           crossFadeState: isCollapsed ? CrossFadeState.showSecond : CrossFadeState.showFirst,
//           firstChild: Column(
//             children: [
//               ...items.map((task) => Padding(
//                 padding: const EdgeInsets.only(bottom: 5),
//                 child: SwipeableTaskRow(
//                   key: ValueKey(task.id),
//                   task: task,
//                   accentColor: widget.accentColor,
//                   onDone: () => widget.onStatusChanged?.call(
//                     task,
//                     task.status == TaskStatus.done ? TaskStatus.todo : TaskStatus.done,
//                   ),
//                   onEdit: () => widget.onEdit?.call(task),
//                   onDelete: () => showDeleteConfirmSheet(
//                     context: context,
//                     type: DeleteType.task,
//                     itemName: task.title,
//                     accentColor: widget.accentColor,
//                     onConfirm: () => widget.onDelete?.call(task),
//                   ),
//                 ),
//               )),
//               if (status != TaskStatus.done && widget.canCreate)
//                 _buildAddRow(),
//               const SizedBox(height: 4),
//             ],
//           ),
//           secondChild: const SizedBox.shrink(),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildAddRow() {
//     return GestureDetector(
//       onTap: widget.onAddTask,
//       child: Container(
//         height: 34,
//         margin: const EdgeInsets.only(bottom: 5),
//         decoration: BoxDecoration(
//           border: Border.all(color: widget.accentColor.withOpacity(0.20), width: 1.5),
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.add_rounded, size: 12, color: AppColors.textMuted),
//             const SizedBox(width: 4),
//             Text('Add task', style: GoogleFonts.poppins(fontSize: 9.5, color: AppColors.textMuted)),
//           ],
//         ),
//       ),
//     );
//   }
// }