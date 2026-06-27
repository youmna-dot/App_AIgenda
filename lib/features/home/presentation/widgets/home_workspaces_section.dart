// lib/features/home/presentation/widgets/home_workspaces_section.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_values.dart';
import '../../../../core/theme/app_icons.dart' as theme_icons;
import '../../../workspace/data/models/workspace_model.dart';
import '../../../workspace/logic/workspace_cubit/workspace_cubit.dart';
import '../../../workspace/logic/workspace_cubit/workspace_state.dart';
import '../../../workspace/presentation/widgets/workspaces_screen_widgets/ws_color_service.dart';
import '../../../workspace/presentation/widgets/workspaces_screen_widgets/ws_screen_extras.dart';

class HomeWorkspacesSection extends StatelessWidget {
  final String seeAllLabel;
  final VoidCallback? onSeeAll;
  final VoidCallback? onCreateNew;
  final void Function(WorkspaceModel workspace)? onWorkspaceTap;

  const HomeWorkspacesSection({
    super.key,
    this.seeAllLabel = 'See all',
    this.onSeeAll,
    this.onCreateNew,
    this.onWorkspaceTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Section header ──────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppValues.horizontalPadding),
          child: Row(
            children: [
              Text(
                'Recent Workspaces',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onSeeAll,
                child: Text(
                  seeAllLabel,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // ── List / states ───────────────────────────────
        BlocBuilder<WorkspaceCubit, WorkspaceState>(
          builder: (ctx, state) {
            if (state is WorkspaceLoading) {
              return const SizedBox(
                height: 110,
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                    strokeWidth: 2,
                  ),
                ),
              );
            }

            if (state is WorkspaceError) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppValues.horizontalPadding),
                child: SizedBox(
                  height: 90,
                  child: WsErrorView(
                    message: state.message,
                    onRetry: () =>
                        ctx.read<WorkspaceCubit>().getWorkspaces(),
                  ),
                ),
              );
            }

            if (state is WorkspacesSuccess) {
              final items = state.data.items.take(5).toList();

              if (items.isEmpty) {
                return _EmptyWorkspaceCard(onTap: onCreateNew);
              }

              return SizedBox(
                height: 110,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppValues.horizontalPadding),
                  itemCount: items.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(width: 10),
                  itemBuilder: (_, i) => _HomeWsCard(
                    workspace: items[i],
                    onTap: () => onWorkspaceTap?.call(items[i]),
                  ),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}

// ── Single workspace card ─────────────────────────────────────
class _HomeWsCard extends StatelessWidget {
  final WorkspaceModel workspace;
  final VoidCallback onTap;

  const _HomeWsCard({required this.workspace, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // ✅ استخدام الأيقون الحقيقية بتاعة الـ workspace
    final emoji = theme_icons.AppIcons.displayFromCode(workspace.iconCode);

    return FutureBuilder<Color>(
      future: WsColorService.load(workspace.id),
      initialData: AppColors.primary,
      builder: (_, snap) {
        final color = snap.data ?? AppColors.primary;

        return GestureDetector(
          onTap: onTap,
          child: Container(
            width: 130,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppValues.radiusXl),
              border: Border.all(
                  color: color.withOpacity(0.15), width: 0.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ أيقون الـ workspace الحقيقية في container ملون
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      emoji,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  workspace.name,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                // Accent underline
                Container(
                  height: 2.5,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ── Empty workspace prompt ────────────────────────────────────
class _EmptyWorkspaceCard extends StatelessWidget {
  final VoidCallback? onTap;
  const _EmptyWorkspaceCard({this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppValues.horizontalPadding),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 90,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppValues.radiusXl),
            border: Border.all(
                color: AppColors.primary.withOpacity(0.15), width: 0.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add_circle_outline_rounded,
                    color: AppColors.primary, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Create your first workspace',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}