// lib/features/home/presentation/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/route_names.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../workspace/data/models/workspace_model.dart';
import '../../../workspace/logic/workspace_cubit/workspace_cubit.dart';
import '../../../workspace/presentation/widgets/workspaces_screen_widgets/sheets/ws_create_sheet.dart';
import '../widgets/home_ai_insight_card.dart';
import '../widgets/home_due_today_section.dart';
import '../widgets/home_header.dart';
import '../widgets/home_recent_notes_section.dart';
import '../widgets/home_workspace_overview_section.dart';
import '../widgets/home_workspaces_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _firstName = '';
  // Home screen دايماً index 0
  int _navIndex = 0;

  static const _mockDueItems = [
    DueTodayItem(
      time: '10:00 AM',
      title: 'Stakeholder Review',
      subtitle: 'Presenting the final design tokens and style guide.',
      isHighPriority: true,
    ),
    DueTodayItem(
      time: '02:30 PM',
      title: 'Refine Animation Specs',
      subtitle: 'Documenting the 4cx grid and spacing rules.',
      isHighPriority: false,
    ),
  ];

  static const _mockNotes = [
    HomeNotePreview(
      title: 'Architecture Ideas',
      preview: 'Discussing the serverless deployment and the migration plan for Q3…',
      color: Color(0xFF6C4AB6),
      timeAgo: '5 hours ago',
    ),
    HomeNotePreview(
      title: 'Meeting Minutes',
      preview: 'The team agreed to pilot the mobile dashboard to validate our KPIs.',
      color: Color(0xFF1D9E75),
      timeAgo: 'Yesterday',
    ),
    HomeNotePreview(
      title: 'Sprint Retro',
      preview: 'Velocity improved by 20%. Need to address backlog grooming next.',
      color: Color(0xFF4A90E2),
      timeAgo: '2 days ago',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadUser();
    context.read<WorkspaceCubit>().getWorkspaces();
  }

  Future<void> _loadUser() async {
    final name = await SecureStorageService().getFirstName();
    if (mounted) setState(() => _firstName = name ?? '');
  }

  void _openCreateWorkspace() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (_) => BlocProvider.value(
        value: context.read<WorkspaceCubit>(),
        child: const WsCreateSheet(),
      ),
    );
  }

  void _navigateToWorkspace(WorkspaceModel ws) {
    context.push(
      RouteNames.workspaceDashboard,
      extra: {
        'workspaceId': ws.id,
        'workspaceName': ws.name,
        'workspaceDescription': ws.description,
        'numberOfMembers': ws.numberOfMembers,
        'isCurrentUserOwner': ws.isOwnedByCurrentUser,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 16),
                child: HomeHeader(
                  firstName: _firstName,
                  hasNotification: true,
                  onNotificationTap: () {},
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: HomeAiInsightCard(
                focusScore: 82,
                dueToday: 3,
                highPriority: 1,
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
            SliverToBoxAdapter(
              child: HomeWorkspacesSection(
                onSeeAll: () => context.go(RouteNames.workspaces),
                onCreateNew: _openCreateWorkspace,
                onWorkspaceTap: _navigateToWorkspace,
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
            SliverToBoxAdapter(
              child: HomeDueTodaySection(
                items: _mockDueItems,
                onViewAll: () => context.go(RouteNames.workspaces),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
            const SliverToBoxAdapter(
              child: HomeWorkspaceOverviewSection(),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
            SliverToBoxAdapter(
              child: HomeRecentNotesSection(
                notes: _mockNotes,
                onViewAll: () {},
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
      floatingActionButton: AppBottomNav.fab(onTap: () {}),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AppBottomNav(
        currentIndex: _navIndex,
        onTap: (i) => setState(() => _navIndex = i),
        onHomeTap: () {},
        // context.go عشان تمسح الـ stack وترجع لـ Home نظيف
        onWorkspacesTap: () => context.go(RouteNames.workspaces),
        onProfileTap: () => context.go(RouteNames.profile),
      ),
    );
  }
}