// lib/features/workspace/presentation/screens/workspaces_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../config/dependency_injection.dart';
import '../../../../config/routes/route_names.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_values.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../logic/workspace_cubit/workspace_cubit.dart';
import '../../logic/workspace_cubit/workspace_state.dart';
import '../widgets/workspaces_screen_widgets/sheets/ws_create_sheet.dart';
import '../widgets/workspaces_screen_widgets/ws_list.dart';
import '../widgets/workspaces_screen_widgets/ws_screen_extras.dart';

class WorkspacesScreen extends StatelessWidget {
  const WorkspacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<WorkspaceCubit>()..getWorkspaces(),
      child: const _WorkspaceBody(),
    );
  }
}

class _WorkspaceBody extends StatefulWidget {
  const _WorkspaceBody();

  @override
  State<_WorkspaceBody> createState() => _WorkspaceBodyState();
}

class _WorkspaceBodyState extends State<_WorkspaceBody> {
  int _navIndex = 3;

  void _openCreateSheet(BuildContext context) {
    final cubit = context.read<WorkspaceCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (_) =>
          BlocProvider.value(value: cubit, child: const WsCreateSheet()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<WorkspaceCubit, WorkspaceState>(
          builder: (ctx, state) {
            // ── Loading ──────────────────────────────
            if (state is WorkspaceLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                  strokeWidth: 2.5,
                ),
              );
            }

            // ── Error ────────────────────────────────
            if (state is WorkspaceError) {
              return WsErrorView(
                message: state.message,
                onRetry: () =>
                    ctx.read<WorkspaceCubit>().getWorkspaces(),
              );
            }

            // ── Empty ────────────────────────────────
            if (state is WorkspacesSuccess &&
                state.data.items.isEmpty) {
              return CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                      child: _WsScreenHeader(
                    onCreateTap: () => _openCreateSheet(ctx),
                  )),
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: WsEmptyView()
                    ),
                  
                ],
              );
            }

            // ── Success ──────────────────────────────
            if (state is WorkspacesSuccess) {
              final cubit = ctx.read<WorkspaceCubit>();
              final items = state.data.items;

              return CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: _WsScreenHeader(
                      onCreateTap: () => _openCreateSheet(ctx),
                    ),
                  ),
                  const SliverToBoxAdapter(
                      child: SizedBox(height: 4)),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppValues.horizontalPadding,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (_, i) => Padding(
                          padding:
                              const EdgeInsets.only(bottom: 14),
                          child: WsListItem(
                            workspace: items[i],
                            onDelete: (id) =>
                                cubit.deleteWorkspace(id),
                            onLeave: (id, email) =>
                                cubit.leaveWorkspace(id, email),
                            onEdit: ({
                              required workspaceId,
                              required name,
                              required description,
                              required iconCode,
                              required visibility,
                            }) =>
                                cubit.editWorkspace(
                                  workspaceId: workspaceId,
                                  name: name,
                                  description: description,
                                  iconCode: iconCode,
                                  visibility: visibility,
                                ),
                          ),
                        ),
                        childCount: items.length,
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(
                      child: SizedBox(height: 100)),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
      floatingActionButton: AppBottomNav.fab(onTap: () {}),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AppBottomNav(
        currentIndex: _navIndex,
        onTap: (i) => setState(() => _navIndex = i),
        onHomeTap: () => context.go(RouteNames.home),
        onWorkspacesTap: () {},
        onProfileTap: () => context.go(RouteNames.profile),
      ),
    );
  }
}

class _WsScreenHeader extends StatelessWidget {
  final VoidCallback onCreateTap;

  const _WsScreenHeader({required this.onCreateTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppValues.horizontalPadding,
        AppValues.paddingLg,
        AppValues.horizontalPadding,
        20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Title + subtitle ──────────────────────
          Text(
            'Workspaces',
            style: GoogleFonts.outfit(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
              letterSpacing: -0.5,
              height: 1.1,
            ),
          ),
          Text(
            'Manage your high-agency environments.',
            style: GoogleFonts.outfit(
              fontSize: 13,
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 20),

          // ── Create workspace button ───────────────
          GestureDetector(
            onTap: onCreateTap,
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                gradient: AppColors.appPurpleGradient,
                borderRadius:
                    BorderRadius.circular(AppValues.pillRadius),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.appPurpleDark.withOpacity(0.30),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppColors.white.withOpacity(0.20),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.add_rounded,
                      color: AppColors.white,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Create workspace',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}