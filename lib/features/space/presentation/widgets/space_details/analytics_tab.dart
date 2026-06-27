// lib/features/workspace/presentation/widgets/space_details/analytics_tab.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_values.dart';
import 'widgets/analytics/section_header.dart';
import 'widgets/analytics/progress_row.dart';
import 'widgets/analytics/priority_chip.dart';
import 'widgets/analytics/stat_tile.dart';
import 'widgets/analytics/ring_painter.dart';
import '../../../../task/data/models/task_model.dart';
import '../../../../task/enums/task_status.dart';
import '../../../../task/enums/task_priority.dart';

class AnalyticsTab extends StatelessWidget {
  final List<TaskModel> tasks;
  final Color accentColor;

  const AnalyticsTab({
    super.key,
    required this.tasks,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final total = tasks.length;
    final done = tasks.where((t) => t.status == TaskStatus.done).length;
    final inProgress = tasks.where((t) => t.status == TaskStatus.inProgress).length;
    final todo = tasks.where((t) => t.status == TaskStatus.todo).length;
    final high = tasks.where((t) => t.priority == TaskPriority.high).length;
    final medium = tasks.where((t) => t.priority == TaskPriority.medium).length;
    final low = tasks.where((t) => t.priority == TaskPriority.low).length;
    final completion = total == 0 ? 0.0 : done / total;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(AppValues.horizontalPadding, 0, AppValues.horizontalPadding, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Progress Overview', icon: Icons.trending_up_rounded),
          SizedBox(height: AppValues.paddingSm),
          Container(
            padding: EdgeInsets.all(AppValues.paddingXl - 4),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppValues.radiusXl),
              border: Border.all(color: accentColor.withOpacity(0.1)),
              boxShadow: [
                BoxShadow(
                  color: accentColor.withOpacity(0.07),
                  blurRadius: 14, offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 100, height: 100,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CustomPaint(
                        size: const Size(100, 100),
                        painter: RingPainter(
                          progress: completion,
                          color: accentColor,
                          strokeWidth: 10,
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('${(completion * 100).toInt()}%',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: accentColor,
                            ),
                          ),
                          Text('Done',
                            style: GoogleFonts.poppins(
                              fontSize: 10, color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppValues.paddingXl - 4),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProgressRow(label: 'To Do', value: todo, total: total, color: AppColors.error),
                      const SizedBox(height: AppValues.paddingSm - 2),
                      ProgressRow(label: 'In Progress', value: inProgress, total: total, color: AppColors.warning),
                      const SizedBox(height: AppValues.paddingSm - 2),
                      ProgressRow(label: 'Done', value: done, total: total, color: AppColors.success),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppValues.paddingXl),
          const SectionHeader(title: 'Priority Distribution', icon: Icons.flag_rounded),
          const SizedBox(height: AppValues.paddingSm),
          Row(
            children: [
              PriorityChip(label: 'High', count: high, color: AppColors.error, total: total),
              const SizedBox(width: AppValues.paddingSm - 2),
              PriorityChip(label: 'Medium', count: medium, color: AppColors.warning, total: total),
              const SizedBox(width: AppValues.paddingSm - 2),
              PriorityChip(label: 'Low', count: low, color: AppColors.success, total: total),
            ],
          ),
          const SizedBox(height: AppValues.paddingXl),
          const SectionHeader(title: 'Activity This Week', icon: Icons.calendar_today_rounded),
          const SizedBox(height: AppValues.paddingSm),
          Container(
            padding: const EdgeInsets.all(AppValues.paddingLg),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppValues.radiusXl),
              border: Border.all(color: accentColor.withOpacity(0.1)),
              boxShadow: [
                BoxShadow(
                  color: accentColor.withOpacity(0.07),
                  blurRadius: 14, offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                    .asMap()
                    .entries
                    .map((e) {
                      final intensity = (e.key * 7) % 5;
                      return Column(
                        children: [
                          Container(
                            width: 32, height: 32,
                            decoration: BoxDecoration(
                              color: intensity == 0
                                ? AppColors.background
                                : accentColor.withOpacity(intensity * 0.2),
                              borderRadius: BorderRadius.circular(AppValues.radiusXs),
                            ),
                            child: intensity > 2
                              ? Icon(Icons.check_rounded,
                                  size: AppValues.iconSize - 6, color: accentColor)
                              : null,
                          ),
                          const SizedBox(height: 4),
                          Text(e.value,
                            style: GoogleFonts.poppins(
                              fontSize: 9, color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                ),
                const SizedBox(height: AppValues.paddingSm - 2),
                Text('Coming soon — real data from API',
                  style: GoogleFonts.poppins(
                    fontSize: 11, color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppValues.paddingXl),
          const SectionHeader(title: 'Quick Stats', icon: Icons.bar_chart_rounded),
          const SizedBox(height: AppValues.paddingSm),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: AppValues.paddingSm,
            mainAxisSpacing: AppValues.paddingSm,
            childAspectRatio: 1.6,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              StatTile(icon: Icons.task_alt_rounded, value: '$total', label: 'Total Tasks', color: accentColor),
              StatTile(icon: Icons.check_circle_rounded, value: '$done', label: 'Completed', color: AppColors.success),
              StatTile(icon: Icons.timelapse_rounded, value: '$inProgress', label: 'In Progress', color: AppColors.warning),
              StatTile(icon: Icons.pending_rounded, value: '$todo', label: 'Pending', color: AppColors.error),
            ],
          ),
        ],
      ),
    );
  }
}

// // lib/features/worksspace/presentation/widgets/space_detail/analytics_tab.dart

// import 'dart:math' as math;
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../../../../../core/constants/app_colors.dart';
// import '../../../../../core/constants/app_values.dart';
// import 'task_card.dart';

// class AnalyticsTab extends StatelessWidget {
//   final List<TaskModel> tasks_widgets;
//   final Color accentColor;

//   const AnalyticsTab({
//     super.key,
//     required this.tasks_widgets,
//     required this.accentColor,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final total = tasks_widgets.length;
//     final done = tasks_widgets.where((t) => t.status == TaskStatus.done).length;
//     final inProgress = tasks_widgets.where((t) => t.status == TaskStatus.inProgress).length;
//     final todo = tasks_widgets.where((t) => t.status == TaskStatus.todo).length;
//     final high = tasks_widgets.where((t) => t.priority == TaskPriority.high).length;
//     final medium = tasks_widgets.where((t) => t.priority == TaskPriority.medium).length;
//     final low = tasks_widgets.where((t) => t.priority == TaskPriority.low).length;
//     final completion = total == 0 ? 0.0 : done / total;

//     return SingleChildScrollView(
//       padding: const EdgeInsets.fromLTRB(AppValues.horizontalPadding, 0, AppValues.horizontalPadding, 100),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _SectionHeader(title: 'Progress Overview', icon: Icons.trending_up_rounded),
//           const SizedBox(height: AppValues.paddingSm),
//           Container(
//             padding: const EdgeInsets.all(AppValues.paddingXl - 4),
//             decoration: BoxDecoration(
//               color: AppColors.white,
//               borderRadius: BorderRadius.circular(AppValues.radiusXl),
//               border: Border.all(color: accentColor.withOpacity(0.1)),
//               boxShadow: [
//                 BoxShadow(
//                     color: accentColor.withOpacity(0.07),
//                     blurRadius: 14, offset: const Offset(0, 4)),
//               ],
//             ),
//             child: Row(
//               children: [
//                 SizedBox(
//                   width: 100, height: 100,
//                   child: Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       CustomPaint(
//                         size: const Size(100, 100),
//                         painter: _RingPainter(
//                           progress: completion,
//                           color: accentColor,
//                           strokeWidth: 10,
//                         ),
//                       ),
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text('${(completion * 100).toInt()}%',
//                               style: GoogleFonts.poppins(
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.w800,
//                                   color: accentColor)),
//                           Text('Done',
//                               style: GoogleFonts.poppins(
//                                   fontSize: 10, color: AppColors.textMuted)),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(width: AppValues.paddingXl - 4),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _ProgressRow(label: 'To Do', value: todo,
//                           total: total, color: AppColors.error),
//                       const SizedBox(height: AppValues.paddingSm - 2),
//                       _ProgressRow(label: 'In Progress', value: inProgress,
//                           total: total, color: AppColors.warning),
//                       const SizedBox(height: AppValues.paddingSm - 2),
//                       _ProgressRow(label: 'Done', value: done,
//                           total: total, color: AppColors.success),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: AppValues.paddingXl),

//           _SectionHeader(title: 'Priority Distribution', icon: Icons.flag_rounded),
//           const SizedBox(height: AppValues.paddingSm),
//           Row(
//             children: [
//               _PriorityChip(label: 'High', count: high,
//                   color: AppColors.error, total: total),
//               const SizedBox(width: AppValues.paddingSm - 2),
//               _PriorityChip(label: 'Medium', count: medium,
//                   color: AppColors.warning, total: total),
//               const SizedBox(width: AppValues.paddingSm - 2),
//               _PriorityChip(label: 'Low', count: low,
//                   color: AppColors.success, total: total),
//             ],
//           ),

//           const SizedBox(height: AppValues.paddingXl),

//           _SectionHeader(title: 'Activity This Week', icon: Icons.calendar_today_rounded),
//           const SizedBox(height: AppValues.paddingSm),
//           Container(
//             padding: const EdgeInsets.all(AppValues.paddingLg),
//             decoration: BoxDecoration(
//               color: AppColors.white,
//               borderRadius: BorderRadius.circular(AppValues.radiusXl),
//               border: Border.all(color: accentColor.withOpacity(0.1)),
//               boxShadow: [
//                 BoxShadow(
//                     color: accentColor.withOpacity(0.07),
//                     blurRadius: 14, offset: const Offset(0, 4)),
//               ],
//             ),
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
//                       .asMap()
//                       .entries
//                       .map((e) {
//                     final intensity = math.Random(e.key * 7).nextInt(5);
//                     return Column(
//                       children: [
//                         Container(
//                           width: 32, height: 32,
//                           decoration: BoxDecoration(
//                             color: intensity == 0
//                                 ? AppColors.background
//                                 : accentColor.withOpacity(intensity * 0.2),
//                             borderRadius: BorderRadius.circular(AppValues.radiusXs),
//                           ),
//                           child: intensity > 2
//                               ? Icon(Icons.check_rounded,
//                                   size: AppValues.iconSize - 6, color: accentColor)
//                               : null,
//                         ),
//                         const SizedBox(height: 4),
//                         Text(e.value,
//                             style: GoogleFonts.poppins(
//                                 fontSize: 9, color: AppColors.textMuted)),
//                       ],
//                     );
//                   }).toList(),
//                 ),
//                 const SizedBox(height: AppValues.paddingSm - 2),
//                 Text('Coming soon — real data from API',
//                     style: GoogleFonts.poppins(
//                         fontSize: 11, color: AppColors.textMuted)),
//               ],
//             ),
//           ),

//           const SizedBox(height: AppValues.paddingXl),

//           _SectionHeader(title: 'Quick Stats', icon: Icons.bar_chart_rounded),
//           const SizedBox(height: AppValues.paddingSm),
//           GridView.count(
//             crossAxisCount: 2,
//             crossAxisSpacing: AppValues.paddingSm,
//             mainAxisSpacing: AppValues.paddingSm,
//             childAspectRatio: 1.6,
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             children: [
//               _StatTile(icon: Icons.task_alt_rounded, value: '$total',
//                   label: 'Total Tasks', color: accentColor),
//               _StatTile(icon: Icons.check_circle_rounded, value: '$done',
//                   label: 'Completed', color: AppColors.success),
//               _StatTile(icon: Icons.timelapse_rounded, value: '$inProgress',
//                   label: 'In Progress', color: AppColors.warning),
//               _StatTile(icon: Icons.pending_rounded, value: '$todo',
//                   label: 'Pending', color: AppColors.error),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _SectionHeader extends StatelessWidget {
//   final String title;
//   final IconData icon;
//   const _SectionHeader({required this.title, required this.icon});

//   @override
//   Widget build(BuildContext context) => Row(
//         children: [
//           Icon(icon, size: AppValues.iconSize - 4, color: AppColors.primary),
//           const SizedBox(width: AppValues.paddingXs),
//           Text(title,
//               style: GoogleFonts.poppins(
//                   fontSize: 15, fontWeight: FontWeight.w700,
//                   color: AppColors.textDark)),
//         ],
//       );
// }

// class _ProgressRow extends StatelessWidget {
//   final String label;
//   final int value;
//   final int total;
//   final Color color;

//   const _ProgressRow({
//     required this.label, required this.value,
//     required this.total, required this.color,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final pct = total == 0 ? 0.0 : value / total;
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(label,
//                 style: GoogleFonts.poppins(
//                     fontSize: 11, color: AppColors.textSecondary,
//                     fontWeight: FontWeight.w500)),
//             Text('$value',
//                 style: GoogleFonts.poppins(
//                     fontSize: 11, fontWeight: FontWeight.w700, color: color)),
//           ],
//         ),
//         const SizedBox(height: 4),
//         ClipRRect(
//           borderRadius: BorderRadius.circular(4),
//           child: LinearProgressIndicator(
//             value: pct, minHeight: 5,
//             backgroundColor: color.withOpacity(0.1),
//             color: color,
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _PriorityChip extends StatelessWidget {
//   final String label;
//   final int count;
//   final Color color;
//   final int total;

//   const _PriorityChip({
//     required this.label, required this.count,
//     required this.color, required this.total,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final pct = total == 0 ? 0 : ((count / total) * 100).toInt();
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.all(AppValues.paddingLg - 6),
//         decoration: BoxDecoration(
//           color: color.withOpacity(0.07),
//           borderRadius: BorderRadius.circular(AppValues.radiusLg + 2),
//           border: Border.all(color: color.withOpacity(0.15)),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               width: 28, height: 28,
//               decoration: BoxDecoration(
//                 color: color.withOpacity(0.15),
//                 borderRadius: BorderRadius.circular(AppValues.radiusXs),
//               ),
//               child: Icon(Icons.flag_rounded, color: color, size: AppValues.iconSize - 5),
//             ),
//             const SizedBox(height: AppValues.paddingSm - 2),
//             Text('$count',
//                 style: GoogleFonts.poppins(
//                     fontSize: 22, fontWeight: FontWeight.w800, color: color)),
//             Text(label,
//                 style: GoogleFonts.poppins(
//                     fontSize: 11, color: AppColors.textMuted)),
//             Text('$pct%',
//                 style: GoogleFonts.poppins(
//                     fontSize: 10, color: color.withOpacity(0.7),
//                     fontWeight: FontWeight.w600)),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _StatTile extends StatelessWidget {
//   final IconData icon;
//   final String value;
//   final String label;
//   final Color color;

//   const _StatTile({
//     required this.icon, required this.value,
//     required this.label, required this.color,
//   });

//   @override
//   Widget build(BuildContext context) => Container(
//         padding: const EdgeInsets.all(AppValues.paddingLg - 6),
//         decoration: BoxDecoration(
//           color: AppColors.white,
//           borderRadius: BorderRadius.circular(AppValues.radiusLg),
//           border: Border.all(color: color.withOpacity(0.1)),
//           boxShadow: [
//             BoxShadow(
//                 color: color.withOpacity(0.06),
//                 blurRadius: 10, offset: const Offset(0, 3)),
//           ],
//         ),
//         child: Row(
//           children: [
//             Container(
//               width: 36, height: 36,
//               decoration: BoxDecoration(
//                 color: color.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(AppValues.radiusSm - 2),
//               ),
//               child: Icon(icon, color: color, size: AppValues.iconSize - 2),
//             ),
//             const SizedBox(width: AppValues.paddingSm - 2),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(value,
//                     style: GoogleFonts.poppins(
//                         fontSize: 20, fontWeight: FontWeight.w800,
//                         color: AppColors.textDark, height: 1)),
//                 Text(label,
//                     style: GoogleFonts.poppins(
//                         fontSize: 10, color: AppColors.textMuted)),
//               ],
//             ),
//           ],
//         ),
//       );
// }

// class _RingPainter extends CustomPainter {
//   final double progress;
//   final Color color;
//   final double strokeWidth;

//   const _RingPainter({
//     required this.progress, required this.color, required this.strokeWidth,
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     final center = Offset(size.width / 2, size.height / 2);
//     final radius = (size.width - strokeWidth) / 2;
//     canvas.drawCircle(center, radius,
//         Paint()
//           ..color = color.withOpacity(0.1)
//           ..strokeWidth = strokeWidth
//           ..style = PaintingStyle.stroke
//           ..strokeCap = StrokeCap.round);
//     canvas.drawArc(
//         Rect.fromCircle(center: center, radius: radius),
//         -math.pi / 2,
//         2 * math.pi * progress.clamp(0.0, 1.0),
//         false,
//         Paint()
//           ..color = color
//           ..strokeWidth = strokeWidth
//           ..style = PaintingStyle.stroke
//           ..strokeCap = StrokeCap.round);
//   }

//   @override
//   bool shouldRepaint(_RingPainter old) =>
//       old.progress != progress || old.color != color;
// }
