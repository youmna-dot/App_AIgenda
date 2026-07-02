// lib/features/task/presentation/screens/create_task_screen.dart
//
// Matches: "AIGENDA - Create Task". Handles BOTH create and edit
// (pass `existingTask` to edit an existing task in place).
//
// See task_ui_mapper.dart for the full list of UI/backend mapping
// decisions. Screen-specific ones:
//   • STATUS row: locked to "To Do" on create — `createTask` has no status
//     parameter, the backend always creates tasks as To Do. On edit it's
//     shown read-only too; use the status button on Task Details to
//     actually transition status (keeps one source of truth for the
//     allowed transitions instead of duplicating that logic here).
//   • SUBTASKS: drafted locally while creating, then persisted with one
//     `SubTaskCubit.createSubTask` call per item, right after the task
//     itself is created via `createTaskAndReturn` (that's the only
//     create-task method that returns the new task's id).
//   • ATTACHMENTS: decorative drop-zone only — no attachment
//     endpoint/model exists in the provided logic files.
//   • "Save as Draft": backend has no draft concept, so this button is
//     disabled with an explanatory snackbar rather than silently behaving
//     like a normal save.
//   • Some TaskCubit methods (assignTask/unassignTask/updateTask) swallow
//     errors internally (emit TaskError, don't rethrow) unlike
//     `createTaskAndReturn` which does rethrow. We add a BlocListener on
//     TaskCubit so those silent failures still surface as a snackbar.

import 'package:ajenda_app/config/dependency_injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../workspace/data/models/member_model.dart';
import '../../../workspace/logic/member_cubit/member_cubit.dart';
import '../../../workspace/logic/member_cubit/member_state.dart';
import '../../data/models/task_model.dart';
import '../../enums/task_priority.dart';
import '../../enums/task_status.dart';
import '../../logic/subtask_cubit/subtask_cubit.dart';
import '../../logic/task_cubit/task_cubit.dart';
import '../../logic/task_cubit/task_state.dart';
import '../utils/task_ui_mapper.dart';
import '../widgets/member_avatar.dart';

class CreateTaskScreen extends StatefulWidget {
  final int workspaceId;
  final String spaceId;
  final TaskModel? existingTask; // non-null => edit mode

  const CreateTaskScreen({
    super.key,
    required this.workspaceId,
    required this.spaceId,
    this.existingTask,
  });

  bool get isEdit => existingTask != null;

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _DraftSubtask {
  final TextEditingController controller;
  _DraftSubtask(String initial) : controller = TextEditingController(text: initial);
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  late final TaskCubit _taskCubit;
  late final SubTaskCubit _subTaskCubit;
  late final MembersCubit _membersCubit;

  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _memberSearchCtrl = TextEditingController();

  // Category chips — UI-only, TaskModel has no field for this. Never sent.
  final List<String> _categories = ['Marketing Ops', 'Development', 'Design'];
  String? _selectedCategory;

  final Set<String> _selectedAssigneeEmails = {};

  TaskPriority _priority = TaskPriority.high;

  DateTime? _startDate; // UI-only — TaskModel has no startDate, never sent.
  DateTime? _dueDate;
  TimeOfDay? _dueTime;

  final List<_DraftSubtask> _draftSubtasks = [];

  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _taskCubit = getIt<TaskCubit>();
    _subTaskCubit = getIt<SubTaskCubit>(param1: _taskCubit);
    _membersCubit = getIt<MembersCubit>()..getMembers(widget.workspaceId);

    final existing = widget.existingTask;
    if (existing != null) {
      _titleCtrl.text = existing.title;
      _descCtrl.text = existing.description ?? '';
      _priority = existing.priority == TaskPriority.none
          ? TaskPriority.low
          : existing.priority;
      _dueDate = existing.dueDate;
      if (existing.dueDate != null) {
        _dueTime = TimeOfDay.fromDateTime(existing.dueDate!);
      }
      _selectedAssigneeEmails.addAll(existing.assignees);
    } else {
      _selectedCategory = _categories.first;
      _dueTime = const TimeOfDay(hour: 17, minute: 0);
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _memberSearchCtrl.dispose();
    for (final d in _draftSubtasks) {
      d.controller.dispose();
    }
    _taskCubit.close();
    _subTaskCubit.close();
    _membersCubit.close();
    super.dispose();
  }

  DateTime? get _combinedDueDate {
    if (_dueDate == null) return null;
    final t = _dueTime ?? const TimeOfDay(hour: 17, minute: 0);
    return DateTime(
        _dueDate!.year, _dueDate!.month, _dueDate!.day, t.hour, t.minute);
  }

  Future<void> _pickDate({required bool isStart}) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: (isStart ? _startDate : _dueDate) ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );
    if (picked == null) return;
    setState(() {
      if (isStart) {
        _startDate = picked;
      } else {
        _dueDate = picked;
      }
    });
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _dueTime ?? const TimeOfDay(hour: 17, minute: 0),
    );
    if (picked != null) setState(() => _dueTime = picked);
  }

  Future<void> _submit() async {
    final title = _titleCtrl.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Task title is required')));
      return;
    }

    setState(() => _saving = true);
    try {
      if (widget.isEdit) {
        final taskId = widget.existingTask!.id;
        await _taskCubit.updateTask(
          workspaceId: widget.workspaceId,
          spaceId: widget.spaceId,
          taskId: taskId,
          title: title,
          description:
              _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
          priority: _priority.toInt(),
          dueDate: _combinedDueDate,
        );

        // Keep assignees in sync (add newly-selected, remove unselected).
        final before = widget.existingTask!.assignees.toSet();
        final toAdd = _selectedAssigneeEmails.difference(before);
        final toRemove = before.difference(_selectedAssigneeEmails);
        for (final email in toAdd) {
          await _taskCubit.assignTask(
            workspaceId: widget.workspaceId,
            spaceId: widget.spaceId,
            taskId: taskId,
            email: email,
          );
        }
        for (final email in toRemove) {
          await _taskCubit.unassignTask(
            workspaceId: widget.workspaceId,
            spaceId: widget.spaceId,
            taskId: taskId,
            email: email,
          );
        }
      } else {
        // 1) create the task and get its real id back
        final created = await _taskCubit.createTaskAndReturn(
          workspaceId: widget.workspaceId,
          spaceId: widget.spaceId,
          title: title,
          description:
              _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
          priority: _priority.toInt(),
          dueDate: _combinedDueDate,
        );

        // 2) assign selected members
        for (final email in _selectedAssigneeEmails) {
          await _taskCubit.assignTask(
            workspaceId: widget.workspaceId,
            spaceId: widget.spaceId,
            taskId: created.id,
            email: email,
          );
        }

        // 3) persist any subtasks drafted in the form
        for (final draft in _draftSubtasks) {
          final subtaskTitle = draft.controller.text.trim();
          if (subtaskTitle.isEmpty) continue;
          await _subTaskCubit.createSubTask(
            workspaceId: widget.workspaceId,
            spaceId: widget.spaceId,
            taskId: created.id,
            title: subtaskTitle,
          );
        }
      }

      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to save task: $e')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TaskUiMapper.screenBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
        title: Text(widget.isEdit ? 'Edit Task' : 'Create Task'),
      ),
      body: BlocListener<TaskCubit, TaskState>(
        bloc: _taskCubit,
        listener: (context, state) {
          // Some TaskCubit methods (assign/unassign/update) swallow errors
          // internally instead of rethrowing — this catches those too.
          if (state is TaskError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              _card([
                TextField(
                  controller: _titleCtrl,
                  style:
                      const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  decoration: const InputDecoration(
                      hintText: 'Task Title', border: InputBorder.none),
                ),
                TextField(
                  controller: _descCtrl,
                  minLines: 2,
                  maxLines: 4,
                  decoration: const InputDecoration(
                      hintText: 'Add a description...', border: InputBorder.none),
                ),
                const Divider(height: 24),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final c in _categories)
                      ChoiceChip(
                        label: Text(c),
                        selected: _selectedCategory == c,
                        onSelected: (_) => setState(() => _selectedCategory = c),
                        selectedColor: const Color(0xFFE4DBFF),
                        labelStyle: TextStyle(
                          color: _selectedCategory == c
                              ? TaskUiMapper.brandPurple
                              : Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ActionChip(
                      label: const Icon(Icons.add, size: 18),
                      onPressed: _promptNewCategory,
                    ),
                  ],
                ),
              ]),
              _sectionLabel('ASSIGN TO'),
              _card([
                TextField(
                  controller: _memberSearchCtrl,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Search members',
                    border: InputBorder.none,
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 8),
                BlocBuilder<MembersCubit, MembersState>(
                  bloc: _membersCubit,
                  builder: (context, state) {
                    if (state is MembersLoading) {
                      return const Padding(
                        padding: EdgeInsets.all(12),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    if (state is MembersError) {
                      return Text(state.message,
                          style: const TextStyle(color: Colors.red));
                    }
                    if (state is MembersSuccess) {
                      final query = _memberSearchCtrl.text.trim().toLowerCase();
                      final members = query.isEmpty
                          ? state.members
                          : state.members
                              .where((m) =>
                                  m.fullName.toLowerCase().contains(query) ||
                                  m.email.toLowerCase().contains(query))
                              .toList();
                      if (members.isEmpty) {
                        return const Text('No members found',
                            style: TextStyle(color: Colors.black54));
                      }
                      return SizedBox(
                        height: 84,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: members.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 14),
                          itemBuilder: (context, i) => _memberTile(members[i]),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ]),
              _sectionLabel('PRIORITY'),
              _card([
                Row(
                  children: [
                    for (final p in TaskUiMapper.selectablePriorities)
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _priority = p),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color:
                                  _priority == p ? Colors.white : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: _priority == p
                                    ? TaskUiMapper.priorityColor(p)
                                    : const Color(0xFFE0E0E8),
                              ),
                              boxShadow: _priority == p
                                  ? [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(0.06),
                                          blurRadius: 6)
                                    ]
                                  : null,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              TaskUiMapper.priorityLabel(p),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12.5,
                                color: _priority == p
                                    ? TaskUiMapper.priorityColor(p)
                                    : Colors.black54,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ]),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionLabel('START DATE'),
                        _dateField(
                            value: _startDate,
                            onTap: () => _pickDate(isStart: true)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionLabel('DUE DATE'),
                        _dateField(
                            value: _dueDate,
                            onTap: () => _pickDate(isStart: false)),
                      ],
                    ),
                  ),
                ],
              ),
              _sectionLabel('DUE TIME'),
              InkWell(
                onTap: _pickTime,
                child: _card([
                  Row(
                    children: [
                      const Icon(Icons.access_time,
                          size: 18, color: TaskUiMapper.brandPurple),
                      const SizedBox(width: 8),
                      Text(
                        _dueTime == null ? 'Select time' : _dueTime!.format(context),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ]),
              ),
              _statusSection(),
              _subtasksSection(),
              _sectionLabel('ATTACHMENTS'),
              _attachmentsPlaceholder(),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saving ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TaskUiMapper.brandPurple,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape:
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: _saving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2),
                        )
                      : Text(
                          widget.isEdit ? 'Save Changes' : 'Create Task',
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
              if (!widget.isEdit) ...[
                const SizedBox(height: 8),
                Center(
                  child: TextButton(
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Drafts aren't supported by the server yet")),
                    ),
                    child: const Text('Save as Draft',
                        style: TextStyle(color: Colors.black38)),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _memberTile(MemberModel m) {
    final selected = _selectedAssigneeEmails.contains(m.email);
    return GestureDetector(
      onTap: () => setState(() {
        if (selected) {
          _selectedAssigneeEmails.remove(m.email);
        } else {
          _selectedAssigneeEmails.add(m.email);
        }
      }),
      child: SizedBox(
        width: 64,
        child: Column(
          children: [
            Stack(
              children: [
                MemberAvatar(label: m.fullName, radius: 22),
                if (selected)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                          color: TaskUiMapper.brandPurple, shape: BoxShape.circle),
                      child: const Icon(Icons.check, size: 12, color: Colors.white),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              m.fullName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            ),
            // Real backend field (isOwner) used instead of fabricated job
            // titles like "Lead / Dev / Manager" from the mockup.
            Text(
              m.isOwner ? 'Owner' : 'Member',
              style: const TextStyle(fontSize: 9.5, color: Colors.black45),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusSection() {
    final current = widget.existingTask?.status ?? TaskStatus.todo;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('STATUS'),
        _card([
          Row(
            children: TaskStatus.values
                .where((s) => s != TaskStatus.cancelled)
                .map((s) {
              final isCurrent = s == current;
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: isCurrent
                        ? TaskUiMapper.statusColor(s)
                        : const Color(0xFFF0F0F5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    TaskUiMapper.statusLabel(s),
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: isCurrent ? Colors.white : Colors.black38,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 6),
          Text(
            widget.isEdit
                ? 'Change status from the Task Details screen.'
                : 'New tasks always start as "To Do" — change status after creating it.',
            style: const TextStyle(fontSize: 10.5, color: Colors.black38),
          ),
        ]),
      ],
    );
  }

  Widget _subtasksSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('SUBTASKS'),
        _card([
          for (int i = 0; i < _draftSubtasks.length; i++)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  const Icon(Icons.radio_button_unchecked,
                      size: 18, color: Colors.black26),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _draftSubtasks[i].controller,
                      decoration:
                          const InputDecoration(border: InputBorder.none, isDense: true),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline,
                        size: 18, color: Colors.redAccent),
                    onPressed: () => setState(() {
                      _draftSubtasks[i].controller.dispose();
                      _draftSubtasks.removeAt(i);
                    }),
                  ),
                ],
              ),
            ),
          TextButton.icon(
            onPressed: () => setState(() => _draftSubtasks.add(_DraftSubtask(''))),
            icon: const Icon(Icons.add_circle_outline, color: TaskUiMapper.brandPurple),
            label:
                const Text('Add New Item', style: TextStyle(color: TaskUiMapper.brandPurple)),
          ),
          if (widget.isEdit)
            const Padding(
              padding: EdgeInsets.only(top: 4),
              child: Text(
                'Manage existing subtasks from the Task Details screen.',
                style: TextStyle(fontSize: 10.5, color: Colors.black38),
              ),
            ),
        ]),
      ],
    );
  }

  Widget _attachmentsPlaceholder() {
    return InkWell(
      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("File attachments aren't supported by the backend yet")),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFD8D8E4)),
        ),
        child: const Column(
          children: [
            Icon(Icons.cloud_upload_outlined, color: TaskUiMapper.brandPurple, size: 28),
            SizedBox(height: 8),
            Text('Upload files or drag & drop', style: TextStyle(color: Colors.black45)),
          ],
        ),
      ),
    );
  }

  Widget _dateField({required DateTime? value, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: _card([
        Row(
          children: [
            const Icon(Icons.calendar_today_outlined,
                size: 16, color: TaskUiMapper.brandPurple),
            const SizedBox(width: 8),
            Text(
              value == null ? 'Select' : _formatDate(value),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ]),
    );
  }

  Future<void> _promptNewCategory() async {
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('New category'),
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
    if (name != null && name.isNotEmpty) {
      setState(() {
        _categories.add(name);
        _selectedCategory = name;
      });
    }
  }

  Widget _sectionLabel(String text) => Padding(
        padding: const EdgeInsets.only(top: 18, bottom: 8, left: 4),
        child: Text(
          text,
          style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.black45,
              letterSpacing: 0.5),
        ),
      );

  Widget _card(List<Widget> children) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        margin: const EdgeInsets.only(bottom: 2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 3))
          ],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
      );

  static String _formatDate(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[d.month - 1]} ${d.day}';
  }
}
