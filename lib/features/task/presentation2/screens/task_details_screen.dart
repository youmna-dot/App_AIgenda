// lib/features/task/presentation/screens/task_details_screen.dart
//
// Matches: "AIGENDA - Task Details".
//
// Screen-specific integration notes (see task_ui_mapper.dart for the rest):
//   • The pill under the task title (e.g. "Marketing Ops" in the mockup)
//     shows the task's real Space name/color (via `SpaceCubit`) instead of
//     a fabricated "category" — `TaskModel` has no category field.
//   • IMPORTANT cubit quirk: `TaskCubit.updateTaskStatus`, `deleteTask`,
//     `restoreTask`, `assignTask`, and `unassignTask` all internally call
//     `getTasks()` afterward (a *list* refresh), not `getTaskById()`. Left
//     alone, that would flip this screen's state to `TasksSuccess`, which
//     this screen doesn't render. So every mutation here is followed by an
//     explicit `getTaskById()` call to bring the detail view back.
//     (`SubTaskCubit` doesn't have this problem — it already calls
//     `taskCubit.getTaskById()` internally after every subtask action.)
//   • Bottom button label/action adapts to the current status:
//       To Do -> "Start Task" -> In Progress
//       In Progress -> "Mark as Completed" -> Completed
//       Completed -> "Reopen Task" -> To Do
//       Cancelled -> "Restore Task" (uses the existing `restoreTask` repo
//       method, which otherwise has no UI entry point in the mockups)
//   • Attachments renders as an empty/collapsed section — no attachment
//     endpoint/model exists in the provided logic files.

import 'package:ajenda_app/config/dependency_injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../space/logic/space_cubit/space_cubit.dart';
import '../../../space/logic/space_cubit/space_state.dart';
import '../../../workspace/data/models/member_model.dart';
import '../../../workspace/logic/member_cubit/member_cubit.dart';
import '../../../workspace/logic/member_cubit/member_state.dart';
import '../../data/models/task_model.dart';
import '../../enums/task_priority.dart';
import '../../enums/task_status.dart';
import '../../logic/subtask_cubit/subtask_cubit.dart';
import '../../logic/subtask_cubit/subtask_state.dart';
import '../../logic/task_cubit/task_cubit.dart';
import '../../logic/task_cubit/task_state.dart';
import '../utils/task_ui_mapper.dart';
import '../widgets/member_avatar.dart';
import 'create_task_screen.dart';

class TaskDetailsScreen extends StatefulWidget {
  final int workspaceId;
  final String spaceId;
  final String taskId;

  const TaskDetailsScreen({
    super.key,
    required this.workspaceId,
    required this.spaceId,
    required this.taskId,
  });

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  late final TaskCubit _taskCubit;
  late final SubTaskCubit _subTaskCubit;
  late final SpaceCubit _spaceCubit;
  late final MembersCubit _membersCubit;

  bool _changed = false;

  @override
  void initState() {
    super.initState();
    _taskCubit = getIt<TaskCubit>()
      ..getTaskById(widget.workspaceId, widget.spaceId, widget.taskId);
    _subTaskCubit = getIt<SubTaskCubit>(param1: _taskCubit);
    _spaceCubit = getIt<SpaceCubit>()
      ..getSpaceById(widget.workspaceId, widget.spaceId);
    _membersCubit = getIt<MembersCubit>()..getMembers(widget.workspaceId);
  }

  @override
  void dispose() {
    _taskCubit.close();
    _subTaskCubit.close();
    _spaceCubit.close();
    _membersCubit.close();
    super.dispose();
  }

  void _refreshTask() =>
      _taskCubit.getTaskById(widget.workspaceId, widget.spaceId, widget.taskId);

  Future<void> _advanceStatus(TaskModel task) async {
    final TaskStatus? next = switch (task.status) {
      TaskStatus.todo => TaskStatus.inProgress,
      TaskStatus.inProgress => TaskStatus.done,
      TaskStatus.done => TaskStatus.todo, // reopen
      TaskStatus.cancelled => null, // handled by _restore instead
    };
    if (next == null) return;
    _changed = true;
    await _taskCubit.updateTaskStatus(
      workspaceId: widget.workspaceId,
      spaceId: widget.spaceId,
      taskId: task.id,
      status: next.toInt(),
    );
    _refreshTask(); // see file header: updateTaskStatus refreshes the LIST, not this detail view
  }

  Future<void> _restore(TaskModel task) async {
    _changed = true;
    await _taskCubit.restoreTask(widget.workspaceId, widget.spaceId, task.id);
    _refreshTask();
  }

  Future<void> _delete(TaskModel task) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete task?'),
        content: Text('"${task.title}" will be deleted.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    await _taskCubit.deleteTask(widget.workspaceId, widget.spaceId, task.id);
    if (mounted) Navigator.pop(context, true);
  }

  Future<void> _edit(TaskModel task) async {
    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => CreateTaskScreen(
          workspaceId: widget.workspaceId,
          spaceId: widget.spaceId,
          existingTask: task,
        ),
      ),
    );
    if (saved == true) {
      _changed = true;
      _refreshTask();
    }
  }

  Future<void> _addSubtask() async {
    final controller = TextEditingController();
    final title = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('New subtask'),
        content: TextField(controller: controller, autofocus: true),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Add'),
          ),
        ],
      ),
    );
    if (title == null || title.isEmpty) return;
    _changed = true;
    // SubTaskCubit refreshes this screen's TaskCubit internally — no
    // manual _refreshTask() needed here.
    await _subTaskCubit.createSubTask(
      workspaceId: widget.workspaceId,
      spaceId: widget.spaceId,
      taskId: widget.taskId,
      title: title,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) Navigator.pop(context, _changed);
      },
      child: Scaffold(
        backgroundColor: TaskUiMapper.screenBg,
        body: SafeArea(
          child: MultiBlocListener(
            listeners: [
              BlocListener<SubTaskCubit, SubTaskState>(
                bloc: _subTaskCubit,
                listener: (context, state) {
                  if (state is SubTaskError) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(state.message)));
                  }
                },
              ),
            ],
            child: BlocBuilder<TaskCubit, TaskState>(
              bloc: _taskCubit,
              builder: (context, state) {
                if (state is TaskDetailSuccess) {
                  return _buildBody(state.task);
                }
                if (state is TaskError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(state.message,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red)),
                    ),
                  );
                }
                // TaskLoading / TaskInitial / stray TasksSuccess (see header note)
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(TaskModel task) {
    return Column(
      children: [
        _appBar(task),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              Text(task.title,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              BlocBuilder<SpaceCubit, SpaceState>(
                bloc: _spaceCubit,
                builder: (context, state) {
                  if (state is! SpaceDetailSuccess) return const SizedBox.shrink();
                  final space = state.space;
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: space.color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      space.name,
                      style: TextStyle(
                          color: space.color,
                          fontWeight: FontWeight.w600,
                          fontSize: 12),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              _infoCard(task),
              const SizedBox(height: 16),
              _descriptionTile(task),
              const SizedBox(height: 12),
              _subtasksTile(task),
              const SizedBox(height: 12),
              _attachmentsTile(),
            ],
          ),
        ),
        _bottomActionButton(task),
      ],
    );
  }

  Widget _appBar(TaskModel task) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 8, 0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, _changed),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => _showActions(task),
          ),
        ],
      ),
    );
  }

  void _showActions(TaskModel task) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Edit task'),
              onTap: () {
                Navigator.pop(context);
                _edit(task);
              },
            ),
            if (task.status == TaskStatus.cancelled)
              ListTile(
                leading: const Icon(Icons.restore),
                title: const Text('Restore task'),
                onTap: () {
                  Navigator.pop(context);
                  _restore(task);
                },
              ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text('Delete task', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _delete(task);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(TaskModel task) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: _labelValue('STATUS', _statusChip(task.status))),
              Expanded(child: _labelValue('PRIORITY', _priorityChip(task.priority))),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _labelValue(
                  'DUE DATE',
                  Text(
                    task.dueDate == null ? 'No due date' : _formatDate(task.dueDate!),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              Expanded(child: _labelValue('ASSIGNED', _assigneesRow(task))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _labelValue(String label, Widget value) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 10.5, color: Colors.black38, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          value,
        ],
      );

  Widget _statusChip(TaskStatus s) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              width: 8,
              height: 8,
              decoration:
                  BoxDecoration(color: TaskUiMapper.statusColor(s), shape: BoxShape.circle)),
          const SizedBox(width: 6),
          Text(TaskUiMapper.statusLabel(s), style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      );

  Widget _priorityChip(TaskPriority p) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.flag, size: 14, color: TaskUiMapper.priorityColor(p)),
          const SizedBox(width: 4),
          Text(TaskUiMapper.priorityLabel(p), style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      );

  Widget _assigneesRow(TaskModel task) {
    if (task.assignees.isEmpty) {
      return const Text('Unassigned', style: TextStyle(color: Colors.black45));
    }
    return BlocBuilder<MembersCubit, MembersState>(
      bloc: _membersCubit,
      builder: (context, state) {
        final members = state is MembersSuccess ? state.members : <MemberModel>[];
        String labelFor(String email) {
          for (final m in members) {
            if (m.email == email) return m.fullName;
          }
          return email;
        }

        final shown = task.assignees.take(3).toList();
        final extra = task.assignees.length > 3 ? 1 : 0;
        return SizedBox(
          height: 26,
          width: 26.0 + (shown.length - 1 + extra) * 18.0,
          child: Stack(
            children: [
              for (int i = 0; i < shown.length; i++)
                Positioned(
                  left: i * 18.0,
                  child: MemberAvatar(label: labelFor(shown[i]), radius: 13),
                ),
              if (extra == 1)
                Positioned(
                  left: shown.length * 18.0,
                  child: CircleAvatar(
                    radius: 13,
                    backgroundColor: const Color(0xFFEDEDF5),
                    child: Text('+${task.assignees.length - 3}',
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _descriptionTile(TaskModel task) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
        backgroundColor: Colors.white,
        collapsedBackgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        leading: const Icon(Icons.notes),
        title: const Text('Description', style: TextStyle(fontWeight: FontWeight.w600)),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                (task.description ?? '').isEmpty ? 'No description' : task.description!,
                style: const TextStyle(color: Colors.black54),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _subtasksTile(TaskModel task) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        initiallyExpanded: true,
        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
        backgroundColor: Colors.white,
        collapsedBackgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        leading: const Icon(Icons.checklist_rtl),
        title: Text('Subtasks (${task.subTasks.length})',
            style: const TextStyle(fontWeight: FontWeight.w600)),
        children: [
          for (final sub in task.subTasks)
            ListTile(
              dense: true,
              leading: Checkbox(
                value: sub.isCompleted,
                activeColor: TaskUiMapper.brandPurple,
                onChanged: (_) {
                  _changed = true;
                  _subTaskCubit.updateSubTaskStatus(
                    workspaceId: widget.workspaceId,
                    spaceId: widget.spaceId,
                    taskId: task.id,
                    subTaskId: sub.id,
                    isCompleted: !sub.isCompleted,
                  );
                },
              ),
              title: Text(
                sub.title,
                style: TextStyle(
                  decoration: sub.isCompleted ? TextDecoration.lineThrough : null,
                  color: sub.isCompleted ? Colors.black38 : Colors.black87,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline, size: 18, color: Colors.black26),
                onPressed: () {
                  _changed = true;
                  _subTaskCubit.deleteSubTask(
                    workspaceId: widget.workspaceId,
                    spaceId: widget.spaceId,
                    taskId: task.id,
                    subTaskId: sub.id,
                  );
                },
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: _addSubtask,
                icon: const Icon(Icons.add, size: 18, color: TaskUiMapper.brandPurple),
                label: const Text('Add subtask', style: TextStyle(color: TaskUiMapper.brandPurple)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _attachmentsTile() {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
        backgroundColor: Colors.white,
        collapsedBackgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        leading: const Icon(Icons.attach_file),
        title: const Text('Attachments', style: TextStyle(fontWeight: FontWeight.w600)),
        children: const [
          Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Not supported by the backend yet.',
                  style: TextStyle(color: Colors.black38)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomActionButton(TaskModel task) {
    late String label;
    late Color color;
    late IconData icon;
    VoidCallback? onTap;

    switch (task.status) {
      case TaskStatus.todo:
        label = 'Start Task';
        color = const Color(0xFF3B82F6);
        icon = Icons.play_circle_outline;
        onTap = () => _advanceStatus(task);
        break;
      case TaskStatus.inProgress:
        label = 'Mark as Completed';
        color = TaskUiMapper.brandPurple;
        icon = Icons.check_circle_outline;
        onTap = () => _advanceStatus(task);
        break;
      case TaskStatus.done:
        label = 'Reopen Task';
        color = const Color(0xFF9CA3AF);
        icon = Icons.replay;
        onTap = () => _advanceStatus(task);
        break;
      case TaskStatus.cancelled:
        label = 'Restore Task';
        color = const Color(0xFF9CA3AF);
        icon = Icons.restore;
        onTap = () => _restore(task);
        break;
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: onTap,
          icon: Icon(icon, color: Colors.white),
          label: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
      ),
    );
  }

  static String _formatDate(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }
}
