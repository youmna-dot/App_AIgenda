// lib/features/workspace/presentation/widgets/space_details/create_task_sheet.dart
//
// FIX 8: onCreated كان ValueChanged<TaskModel>
//         دلوقتي typed callback: (title, description, priority, dueDate)
//         الـ TaskModel بيتبني في الكيوبيت مش في الـ sheet
//
// FIX 9: Priority selector كان بيلف على TaskPriority.values كلهم (5 قيم:
//        none, low, medium, high, critical)، بس شرط الـ label كان بيغطي
//        3 حالات بس فـ "none" و "critical" كانوا بيطلعوا "High" برضه —
//        ده اللي كان بيسبب تكرار كلمة High. دلوقتي بنلف على الـ 3
//        المطلوبين بس (low, medium, high) صراحةً.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_values.dart';

import '../../../enums/task_priority.dart';
import '../../../enums/task_status.dart';
import 'task_card.dart';

class CreateTaskSheet extends StatefulWidget {
  final Color accentColor;
  final TaskStatus initialStatus;

  final void Function(
      String title,
      String description,
      TaskPriority priority,
      DateTime? dueDate,
      List<String> subtasks,

      ) onCreated;

  const CreateTaskSheet({
    super.key,
    required this.accentColor,
    required this.onCreated,
    this.initialStatus = TaskStatus.todo,
  });

  @override
  State<CreateTaskSheet> createState() => _CreateTaskSheetState();
}

class _CreateTaskSheetState extends State<CreateTaskSheet> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _subtaskCtrl = TextEditingController();

  TaskStatus _status = TaskStatus.todo;
  TaskPriority _priority = TaskPriority.medium;
  DateTime? _dueDate;
  final List<String> _subtasks = [];

  // FIX 9: الأولويات المعروضة فى الـ selector — 3 بس، صراحةً،
  // بدل ما نلف على TaskPriority.values كله (اللي فيه none و critical كمان).
  static const List<TaskPriority> _selectablePriorities = [
    TaskPriority.low,
    TaskPriority.medium,
    TaskPriority.high,
  ];

  Color get _accent => widget.accentColor;

  @override
  void initState() {
    super.initState();
    _status = widget.initialStatus;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _subtaskCtrl.dispose();
    super.dispose();
  }

  void _addSubtask() {
    if (_subtaskCtrl.text.trim().isEmpty) return;
    setState(() {
      _subtasks.add(_subtaskCtrl.text.trim());
      _subtaskCtrl.clear();
    });
  }

  void _create() {
    if (_titleCtrl.text.trim().isEmpty) return;

    // [FIX] بنبعت البيانات الخام — الكيوبيت هو اللي يبني TaskModel ويبعته للـ API
    // في _create():
    widget.onCreated(
      _titleCtrl.text.trim(),
      _descCtrl.text.trim(),
      _priority,
      _dueDate,
      List.from(_subtasks), 
    );
    Navigator.pop(context);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (_, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(primary: _accent),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppValues.radiusCard - 4)),
      ),
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppValues.horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.cardBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppValues.paddingLg - 2),

            // Title row
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: _accent.withOpacity(0.12),
                    borderRadius:
                    BorderRadius.circular(AppValues.radiusSm - 1),
                  ),
                  child: Icon(Icons.task_alt_rounded,
                      color: _accent, size: AppValues.iconSize),
                ),
                const SizedBox(width: AppValues.paddingSm - 1),
                Text('Create Task',
                    style: GoogleFonts.poppins(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark)),
              ],
            ),
            const SizedBox(height: AppValues.paddingLg - 4),
            Divider(height: 1, color: _accent.withOpacity(0.12)),
            const SizedBox(height: AppValues.paddingLg - 4),

            // Task Title
            _Label('Task Title '),
            const SizedBox(height: AppValues.paddingXs - 2),
            _Field(
                ctrl: _titleCtrl,
                hint: 'What needs to be done?',
                accent: _accent),
            const SizedBox(height: AppValues.paddingLg - 6),

            // Description
            _Label('Description'),
            const SizedBox(height: AppValues.paddingXs - 2),
            _Field(
                ctrl: _descCtrl,
                hint: 'Add more details...',
                accent: _accent,
                maxLines: 3),
            const SizedBox(height: AppValues.paddingLg - 6),

            // Priority
            _Label('Priority'),
            const SizedBox(height: AppValues.paddingXs),
            Container(
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.roleViewer.withOpacity(0.10),
                borderRadius:
                BorderRadius.circular(AppValues.radiusSm),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Row(
                // FIX 9: بنلف على الـ 3 المسموحين بس بدل TaskPriority.values
                children: _selectablePriorities.map((p) {
                  final isSelected = _priority == p;
                  final label = p == TaskPriority.low
                      ? 'Low'
                      : p == TaskPriority.medium
                      ? 'Medium'
                      : 'High';
                  final color = p == TaskPriority.low
                      ? AppColors.success
                      : p == TaskPriority.medium
                      ? AppColors.warning
                      : AppColors.error;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () =>
                          setState(() => _priority = p),
                      child: AnimatedContainer(
                        duration: AppValues.animFast,
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? color
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(
                              AppValues.radiusSm - 3),
                        ),
                        child: Center(
                          child: Text(label,
                              style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? AppColors.white
                                      : AppColors
                                      .textSecondary)),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: AppValues.paddingLg - 6),

            // Due Date
            _Label('Due Date'),
            const SizedBox(height: AppValues.paddingXs),
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                height: 46,
                decoration: BoxDecoration(
                  color: AppColors.roleViewer.withOpacity(0.10),
                  borderRadius:
                  BorderRadius.circular(AppValues.radiusSm),
                  border: Border.all(
                    color: _dueDate != null
                        ? _accent
                        : AppColors.cardBorder,
                    width: _dueDate != null ? 1.5 : 1,
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: AppValues.paddingSm + 1),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today_rounded,
                        size: AppValues.iconSize - 2,
                        color: _dueDate != null
                            ? _accent
                            : AppColors.textMuted),
                    const SizedBox(
                        width: AppValues.paddingSm - 2),
                    Text(
                      _dueDate != null
                          ? '${_dueDate!.day} / ${_dueDate!.month} / ${_dueDate!.year}'
                          : 'Select due date',
                      style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: _dueDate != null
                              ? AppColors.textDark
                              : AppColors.textHint),
                    ),
                    const Spacer(),
                    if (_dueDate != null)
                      GestureDetector(
                        onTap: () =>
                            setState(() => _dueDate = null),
                        child: Icon(Icons.close_rounded,
                            size: AppValues.iconSize - 4,
                            color: AppColors.textMuted),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppValues.paddingLg - 6),

            // Subtasks
            Row(
              children: [
                _Label('Subtasks'),
                const Spacer(),
                Text('${_subtasks.length} added',
                    style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: AppColors.primary)),
              ],
            ),
            const SizedBox(height: AppValues.paddingXs),
            Row(
              children: [
                Expanded(
                  child: _Field(
                    ctrl: _subtaskCtrl,
                    hint: 'Add a subtask...',
                    accent: _accent,
                    onSubmitted: (_) => _addSubtask(),
                  ),
                ),
                const SizedBox(width: AppValues.paddingXs),
                GestureDetector(
                  onTap: _addSubtask,
                  child: Container(
                    height: 44,
                    width: 44,
                    decoration: BoxDecoration(
                      color: _accent,
                      borderRadius: BorderRadius.circular(
                          AppValues.radiusSm),
                      boxShadow: [
                        BoxShadow(
                          color: _accent.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.add_rounded,
                        color: AppColors.white,
                        size: AppValues.iconSize),
                  ),
                ),
              ],
            ),
            if (_subtasks.isNotEmpty) ...[
              const SizedBox(height: AppValues.paddingSm - 2),
              ...List.generate(
                _subtasks.length,
                    (i) => Padding(
                  padding: const EdgeInsets.only(
                      bottom: AppValues.paddingXs - 2),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppValues.paddingSm,
                        vertical: AppValues.paddingSm - 2),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(
                          AppValues.radiusSm - 2),
                      border:
                      Border.all(color: AppColors.cardBorder),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.drag_indicator_rounded,
                            size: AppValues.iconSize - 4,
                            color: AppColors.textMuted
                                .withOpacity(0.5)),
                        const SizedBox(
                            width: AppValues.paddingXs - 2),
                        Expanded(
                          child: Text(_subtasks[i],
                              style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: AppColors.textDark)),
                        ),
                        GestureDetector(
                          onTap: () => setState(
                                  () => _subtasks.removeAt(i)),
                          child: Icon(Icons.close_rounded,
                              size: AppValues.iconSize - 6,
                              color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: AppValues.paddingXl - 2),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: AppValues.buttonHeight - 8,
                      decoration: BoxDecoration(
                        color: AppColors.roleViewer.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(
                            AppValues.radiusMd - 1),
                        border: Border.all(
                            color: _accent.withOpacity(0.2)),
                      ),
                      child: Center(
                        child: Text('Cancel',
                            style: GoogleFonts.poppins(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppValues.paddingSm),
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: _create,
                    child: Container(
                      height: AppValues.buttonHeight - 8,
                      decoration: BoxDecoration(
                        color: _accent,
                        borderRadius: BorderRadius.circular(
                            AppValues.radiusMd - 1),
                        boxShadow: [
                          BoxShadow(
                            color: _accent.withOpacity(0.35),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text('Create Task',
                            style: GoogleFonts.poppins(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: AppColors.white)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);
  @override
  Widget build(BuildContext context) => Text(text,
      style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textDark));
}

class _Field extends StatelessWidget {
  final TextEditingController ctrl;
  final String hint;
  final Color accent;
  final int maxLines;
  final ValueChanged<String>? onSubmitted;

  const _Field({
    required this.ctrl,
    required this.hint,
    required this.accent,
    this.maxLines = 1,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) => TextField(
    controller: ctrl,
    maxLines: maxLines,
    onSubmitted: onSubmitted,
    style: GoogleFonts.poppins(
        fontSize: 13, color: AppColors.textDark),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.poppins(
          fontSize: 13, color: AppColors.roleViewer),
      filled: true,
      fillColor: AppColors.roleViewer.withOpacity(0.10),
      contentPadding: const EdgeInsets.symmetric(
          horizontal: 13, vertical: 12),
      border: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(AppValues.radiusSm - 1),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(AppValues.radiusSm - 1),
        borderSide:
        BorderSide(color: AppColors.cardBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(AppValues.radiusSm - 1),
        borderSide: BorderSide(color: accent, width: 1.5),
      ),
    ),
  );
}