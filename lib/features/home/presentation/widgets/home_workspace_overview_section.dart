// lib/features/home/presentation/widgets/home_workspace_overview_section.dart
//
// ✅ workspace name & task count ← WorkspaceCubit (real backend)
// 🟡 progress → mock (TODO: home/summary endpoint)

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_values.dart';
import '../../../workspace/data/models/workspace_model.dart';
import '../../../workspace/logic/workspace_cubit/workspace_cubit.dart';
import '../../../workspace/logic/workspace_cubit/workspace_state.dart';
import '../../../workspace/presentation/widgets/workspaces_screen_widgets/ws_color_service.dart';

class HomeWorkspaceOverviewSection extends StatelessWidget {
  final VoidCallback? onWorkspaceTap;

  const HomeWorkspaceOverviewSection({super.key, this.onWorkspaceTap});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkspaceCubit, WorkspaceState>(
      builder: (ctx, state) {
        if (state is! WorkspacesSuccess) return const SizedBox.shrink();

        final items = state.data.items.take(3).toList();
        if (items.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ─────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppValues.horizontalPadding),
              child: Text(
                'Workspace Overview',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // ── Card ───────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppValues.horizontalPadding),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppValues.radiusXl),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.08),
                    width: 0.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: List.generate(items.length, (i) {
                    final ws = items[i];
                    final isLast = i == items.length - 1;
                    return Column(
                      children: [
                        _WsOverviewRow(workspace: ws),
                        if (!isLast)
                          Divider(
                            height: 1,
                            color: AppColors.primary.withOpacity(0.06),
                            indent: 16,
                            endIndent: 16,
                          ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _WsOverviewRow extends StatelessWidget {
  final WorkspaceModel workspace;
  const _WsOverviewRow({required this.workspace});

  @override
  Widget build(BuildContext context) {
    // 🟡 mock — TODO: replace with summary API
    const mockProgress = 0.64;
    const mockHighCount = 2;
    const mockDueSoon = 3;

    return FutureBuilder<Color>(
      future: WsColorService.load(workspace.id),
      initialData: AppColors.primary,
      builder: (_, snap) {
        final color = snap.data ?? AppColors.primary;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Name + badges row ─────────────────────
              Row(
                children: [
                  Expanded(
                    child: Text(
                      workspace.name,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // High badge — بالأحمر زي الصورة
                  _Badge(
                    label: '$mockHighCount High',
                    color: AppColors.error,
                  ),
                  const SizedBox(width: 5),
                  // Active badge — بالأزرق
                  _Badge(
                    label: '${workspace.numberOfTasks} Active',
                    color: AppColors.primary,
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // ── Progress bar + % ──────────────────────
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${(mockProgress * 100).toInt()}% Complete',
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 5),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: mockProgress,
                            backgroundColor: color.withOpacity(0.12),
                            color: color,
                            minHeight: 6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  // Due soon badge — زي الصورة على اليمين
                  _Badge(
                    label: '$mockDueSoon Due soon',
                    color: AppColors.textMuted,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}