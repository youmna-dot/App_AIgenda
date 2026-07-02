// lib/features/task/presentation/screens/tasks_list_screen.dart
//
// Matches: "AIGENDA - Tasks List" (+ In Progress / To Do / Completed
// variants).
//
// Integration notes:
//   • Tabs filter CLIENT-SIDE over whatever `TaskCubit.getTasks()` returns.
//     `FilterRequest`'s actual query-param surface isn't part of the
//     provided logic bundle, so rather than guess at a `status` filter key
//     that might not exist, we fetch once and filter locally — always
//     correct, just slightly more bandwidth on large spaces.
//   • The "Reviewing" pill shown on one mockup card does not exist in
//     `TaskStatus` and is never produced here — see task_ui_mapper.dart.
//   • The screen header shows the real Space name (via `SpaceCubit`)
//     instead of a hardcoded title.

import 'package:ajenda_app/config/dependency_injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../space/logic/space_cubit/space_cubit.dart';
import '../../../space/logic/space_cubit/space_state.dart';
import '../../data/models/task_model.dart';
import '../../enums/task_status.dart';
import '../../logic/task_cubit/task_cubit.dart';
import '../../logic/task_cubit/task_state.dart';
import '../utils/task_ui_mapper.dart';
import '../widgets/task_card.dart';
import 'create_task_screen.dart';
import 'task_details_screen.dart';

class _TabDef {
  final String label;
  final TaskStatus? status; // null == "All"
  const _TabDef(this.label, this.status);
}

const List<_TabDef> _tabs = [
  _TabDef('All', null),
  _TabDef('In Progress', TaskStatus.inProgress),
  _TabDef('To Do', TaskStatus.todo),
  _TabDef('Completed', TaskStatus.done),
];

class TasksListScreen extends StatefulWidget {
  final int workspaceId;
  final String spaceId;

  const TasksListScreen({
    super.key,
    required this.workspaceId,
    required this.spaceId,
  });

  @override
  State<TasksListScreen> createState() => _TasksListScreenState();
}

class _TasksListScreenState extends State<TasksListScreen> {
  late final TaskCubit _taskCubit;
  late final SpaceCubit _spaceCubit;
  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();
    _taskCubit = getIt<TaskCubit>()
      ..getTasks(widget.workspaceId, widget.spaceId);
    _spaceCubit = getIt<SpaceCubit>()
      ..getSpaceById(widget.workspaceId, widget.spaceId);
  }

  @override
  void dispose() {
    _taskCubit.close();
    _spaceCubit.close();
    super.dispose();
  }

  Future<void> _refresh() =>
      _taskCubit.getTasks(widget.workspaceId, widget.spaceId);

  Future<void> _openCreateTask() async {
    final created = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => CreateTaskScreen(
          workspaceId: widget.workspaceId,
          spaceId: widget.spaceId,
        ),
      ),
    );
    if (created == true) _refresh();
  }

  Future<void> _openDetails(TaskModel task) async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => TaskDetailsScreen(
          workspaceId: widget.workspaceId,
          spaceId: widget.spaceId,
          taskId: task.id,
        ),
      ),
    );
    if (changed == true) _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TaskUiMapper.screenBg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildTabs(),
            const SizedBox(height: 8),
            Expanded(
              child: BlocBuilder<TaskCubit, TaskState>(
                bloc: _taskCubit,
                builder: (context, state) {
                  if (state is TaskError) {
                    return _ErrorView(message: state.message, onRetry: _refresh);
                  }
                  if (state is TasksSuccess) {
                    final tab = _tabs[_tabIndex];
                    final tasks = tab.status == null
                        ? state.data.items
                        : state.data.items
                            .where((t) => t.status == tab.status)
                            .toList();

                    if (tasks.isEmpty) {
                      return _EmptyView(label: tab.label, onAdd: _openCreateTask);
                    }

                    return RefreshIndicator(
                      onRefresh: _refresh,
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
                        itemCount: tasks.length,
                        itemBuilder: (context, i) => TaskCard(
                          task: tasks[i],
                          onTap: () => _openDetails(tasks[i]),
                        ),
                      ),
                    );
                  }
                  // TaskLoading / TaskInitial / anything else
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openCreateTask,
        backgroundColor: TaskUiMapper.brandPurple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 4),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: TaskUiMapper.brandPurple),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: BlocBuilder<SpaceCubit, SpaceState>(
              bloc: _spaceCubit,
              builder: (context, state) {
                final name =
                    state is SpaceDetailSuccess ? state.space.name : '...';
                return Text(
                  name,
                  style:
                      const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  overflow: TextOverflow.ellipsis,
                );
              },
            ),
          ),
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _tabs.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final selected = i == _tabIndex;
          return ChoiceChip(
            label: Text(_tabs[i].label),
            selected: selected,
            onSelected: (_) => setState(() => _tabIndex = i),
            selectedColor: TaskUiMapper.brandPurple,
            backgroundColor: const Color(0xFFEDEDF5),
            labelStyle: TextStyle(
              color: selected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w600,
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          );
        },
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  final String label;
  final VoidCallback onAdd;
  const _EmptyView({required this.label, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('No tasks in "$label" yet',
              style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: const Text('Add a task'),
          ),
        ],
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red)),
          ),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
