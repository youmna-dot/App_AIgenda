// lib/features/workspace/presentation/screens/workspace_dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../config/dependency_injection.dart';
import '../../../../config/routes/route_names.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_values.dart';
import '../../../../core/utils/permission_checker.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../space/data/models/space_model.dart';
import '../../../space/logic/space_cubit/space_cubit.dart';
import '../../../space/logic/space_cubit/space_state.dart';
import '../../../space/presentation/utils/space_color_service.dart';
import '../../../space/presentation/widgets/space_details/edit_space_sheet.dart';
import '../../../space/presentation/widgets/space_details/empty_spaces.dart';
import '../../logic/current_user_permissions_cubit/current_user_permissions_cubit.dart';
import '../../logic/workspace_cubit/workspace_cubit.dart';
import '../../logic/workspace_cubit/workspace_state.dart';
import '../widgets/workspace_dash_widgets/create_space_sheet.dart';
import '../widgets/workspace_dash_widgets/dash_header.dart';
import '../widgets/workspace_dash_widgets/header_actions_sheet.dart';
import '../widgets/workspace_dash_widgets/space_card.dart';
import '../widgets/workspace_dash_widgets/summary_card.dart';

class WorkspaceDashboardScreen extends StatelessWidget {
  final int workspaceId;
  final String workspaceName;
  final String workspaceDescription;
  final int numberOfMembers;
  final bool isCurrentUserOwner;

  const WorkspaceDashboardScreen({
    super.key,
    required this.workspaceId,
    required this.workspaceName,
    this.workspaceDescription = '',
    required this.numberOfMembers,
    required this.isCurrentUserOwner,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<WorkspaceCubit>()..getDashboard(workspaceId),
        ),
        BlocProvider(
          create: (_) => getIt<SpaceCubit>()..getSpaces(workspaceId),
        ),
        BlocProvider(
          create: (_) => getIt<CurrentUserPermissionsCubit>()
            ..load(workspaceId, isOwner: isCurrentUserOwner),
        ),
      ],
      child: _DashboardBody(
        workspaceId: workspaceId,
        workspaceName: workspaceName,
        workspaceDescription: workspaceDescription,
        numberOfMembers: numberOfMembers,
        isCurrentUserOwner: isCurrentUserOwner,
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// _DashboardBody
// ══════════════════════════════════════════════════════════════
class _DashboardBody extends StatefulWidget {
  final int workspaceId;
  final String workspaceName;
  final String workspaceDescription;
  final int numberOfMembers;
  final bool isCurrentUserOwner;

  const _DashboardBody({
    required this.workspaceId,
    required this.workspaceName,
    required this.workspaceDescription,
    required this.numberOfMembers,
    required this.isCurrentUserOwner,
  });

  @override
  State<_DashboardBody> createState() => _DashboardBodyState();
}

class _DashboardBodyState extends State<_DashboardBody> {
  final Map<String, Color> _colorMap = {};
  final Set<String> _loadedIds = {};
  int _navIndex = 2;

  // ── Color helpers ─────────────────────────────────────────
  Future<void> _loadColors(List<SpaceModel> spaces) async {
    final newSpaces =
        spaces.where((s) => !_loadedIds.contains(s.id)).toList();
    if (newSpaces.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    final updates = <String, Color>{};

    for (final space in newSpaces) {
      final savedIdx = prefs.getInt('space_color_${space.id}');
      final colorIdx = savedIdx ??
          space.id.hashCode.abs() % SpaceColorService.palette.length;
      updates[space.id] = SpaceColorService.palette[colorIdx];
      _loadedIds.add(space.id);
    }

    if (mounted && updates.isNotEmpty) {
      setState(() => _colorMap.addAll(updates));
    }
  }

  Future<void> _reloadColor(String spaceId) async {
    final prefs = await SharedPreferences.getInstance();
    final savedIdx = prefs.getInt('space_color_$spaceId');
    final colorIdx = savedIdx ??
        spaceId.hashCode.abs() % SpaceColorService.palette.length;
    if (mounted) {
      setState(
          () => _colorMap[spaceId] = SpaceColorService.palette[colorIdx]);
    }
  }

  Color _colorFor(SpaceModel space) =>
      _colorMap[space.id] ??
      SpaceColorService.palette[
          space.id.hashCode.abs() % SpaceColorService.palette.length];

  // ── Header menu ───────────────────────────────────────────
  void _openHeaderMenu(BuildContext context, PermissionChecker checker) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => HeaderActionsSheet(
        workspaceName: widget.workspaceName,
        isOwner: widget.isCurrentUserOwner,
        canManageMembers: checker.canManageMembers,
        onManageMembers: () => context.push(
          RouteNames.members,
          extra: {
            'workspaceId': widget.workspaceId,
            'workspaceName': widget.workspaceName,
            'isCurrentUserOwner': widget.isCurrentUserOwner,
          },
        ),
        onDelete: () {
          // TODO: delete workspace
        },
        onLeave: () {
          // TODO: leave workspace
        },
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentUserPermissionsCubit, List<String>>(
      builder: (context, permissions) {
        final checker = PermissionChecker(
          isOwner: widget.isCurrentUserOwner,
          permissions: permissions,
        );

        return Scaffold(
          backgroundColor: AppColors.background,
          extendBody: true,
          body: SafeArea(
            bottom: false,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // ── Header ───────────────────────────
                SliverToBoxAdapter(
                  child: DashHeader(
                    workspaceName: widget.workspaceName,
                    numberOfMembers: widget.numberOfMembers,
                    onBack: () => context.pop(),
                    onMoreTap: () => _openHeaderMenu(context, checker),
                  ),
                ),

                // ── Summary Card ──────────────────────
                SliverToBoxAdapter(
                  child: BlocBuilder<WorkspaceCubit, WorkspaceState>(
                    builder: (context, state) {
                      final stats = state is WorkspaceDashboardSuccess
                          ? state.dashboard.stats
                          : null;
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(
                          AppValues.horizontalPadding,
                          0,
                          AppValues.horizontalPadding,
                          20,
                        ),
                        child: SummaryCard(
                          totalTasks: stats?.totalTasks ?? 0,
                          activeSpaces: stats?.activeSpaces ?? 0,
                          productivityScore:
                              stats?.productivityScore.toDouble() ?? 0,
                        ),
                      );
                    },
                  ),
                ),

                // ── Spaces header row ─────────────────
                SliverToBoxAdapter(
                  child: BlocBuilder<SpaceCubit, SpaceState>(
                    builder: (context, state) {
                      final count = state is SpacesSuccess
                          ? state.data.items.length
                          : 0;
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(
                          AppValues.horizontalPadding,
                          0,
                          AppValues.horizontalPadding,
                          12,
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Spaces',
                              style: GoogleFonts.outfit(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textDark,
                                letterSpacing: -0.3,
                              ),
                            ),
                            if (count > 0) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.10),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '$count',
                                  style: GoogleFonts.outfit(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                            const Spacer(),
                            if (checker.canCreateSpace)
                              GestureDetector(
                                onTap: () => _openCreateSheet(context),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.add_circle_outline_rounded,
                                      size: 16,
                                      color: AppColors.primary,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      'New Space',
                                      style: GoogleFonts.outfit(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // ── Space cards ───────────────────────
                BlocBuilder<SpaceCubit, SpaceState>(
                  builder: (context, state) {
                    if (state is SpaceLoading) {
                      return const SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(32),
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      );
                    }

                    if (state is SpaceError) {
                      return SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Text(
                              state.message,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ),
                        ),
                      );
                    }

                    if (state is SpacesSuccess) {
                      final spaces = state.data.items;

                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _loadColors(spaces);
                      });

                      if (spaces.isEmpty) {
                        return SliverToBoxAdapter(
                          child: EmptySpaces(
                            onCreateTap: checker.canCreateSpace
                                ? () => _openCreateSheet(context)
                                : null,
                          ),
                        );
                      }

                      return SliverPadding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppValues.horizontalPadding,
                        ),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (_, i) => Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: SpaceCard(
                                space: spaces[i],
                                color: _colorFor(spaces[i]),
                                onEdit: checker.canEditSpace
                                    ? () => _openEditSheet(
                                        context, spaces[i])
                                    : null,
                                onDelete: checker.canDeleteSpace
                                    ? () => _confirmDeleteSpace(
                                        context, spaces[i])
                                    : null,
                                onTap: () => context.push(
                                  RouteNames.spaceDetail,
                                  extra: {
                                    'workspaceId': widget.workspaceId,
                                    'space': spaces[i],
                                    'isCurrentUserOwner':
                                        widget.isCurrentUserOwner,
                                    'userPermissions': permissions,
                                  },
                                ),
                              ),
                            ),
                            childCount: spaces.length,
                          ),
                        ),
                      );
                    }

                    return const SliverToBoxAdapter(
                        child: SizedBox.shrink());
                  },
                ),

                const SliverToBoxAdapter(
                    child: SizedBox(height: 100)),
              ],
            ),
          ),
          floatingActionButton: AppBottomNav.fab(onTap: () {}),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: AppBottomNav(
            currentIndex: _navIndex,
            onTap: (i) => setState(() => _navIndex = i),
            onHomeTap: () => context.go(RouteNames.home),
            onWorkspacesTap: () => context.pop(),
            onProfileTap: () => context.go(RouteNames.profile),
          ),
        );
      },
    );
  }

  // ── Sheet helpers ─────────────────────────────────────────
  void _openCreateSheet(BuildContext context) {
    final cubit = context.read<SpaceCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (sheetContext) => CreateSpaceSheet(
        onCreated: (name, description, iconCode, isPublic,
            colorIndex) async {
          await cubit.createSpace(
            workspaceId: widget.workspaceId,
            name: name,
            description: description,
            iconCode: iconCode,
            isPublic: isPublic,
          );
          if (sheetContext.mounted) {
            final state = cubit.state;
            if (state is SpacesSuccess &&
                state.data.items.isNotEmpty) {
              final createdId = state.data.items.first.id;
              await SpaceColorService.save(createdId, colorIndex);
              await _reloadColor(createdId);
            }
          }
        },
      ),
    );
  }

  void _openEditSheet(BuildContext context, SpaceModel space) async {
    final prefs = await SharedPreferences.getInstance();
    final savedIdx = prefs.getInt('space_color_${space.id}');
    final colorIdx = savedIdx ??
        space.id.hashCode.abs() % SpaceColorService.palette.length;
    if (!context.mounted) return;

    final cubit = context.read<SpaceCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (_) => EditSpaceSheet(
        space: space,
        initialColorIndex: colorIdx,
        onSaved: (name, description, iconCode, isPublic,
            colorIndex) async {
          await cubit.updateSpace(
            workspaceId: widget.workspaceId,
            spaceId: space.id,
            name: name,
            description: description,
            iconCode: iconCode,
            isPublic: isPublic,
          );
          await SpaceColorService.save(space.id, colorIndex);
          await _reloadColor(space.id);
        },
      ),
    );
  }

  void _confirmDeleteSpace(BuildContext context, SpaceModel space) {
    final cubit = context.read<SpaceCubit>();
    showDialog(
      context: context,
      builder: (d) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppValues.radiusCard),
        ),
        backgroundColor: AppColors.white,
        title: Text(
          'Delete Space?',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        content: Text(
          '"${space.name}" will be permanently deleted.',
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: AppColors.textMuted,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(d).pop(),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                  fontSize: 13, color: AppColors.textMuted),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(d).pop();
              setState(() => _colorMap.remove(space.id));
              _loadedIds.remove(space.id);
              cubit.deleteSpace(widget.workspaceId, space.id);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.error,
                borderRadius:
                    BorderRadius.circular(AppValues.radiusSm),
              ),
              child: Text(
                'Delete',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}