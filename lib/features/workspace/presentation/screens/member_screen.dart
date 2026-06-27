// presentation/screens/member_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/dependency_injection.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_values.dart';
import '../../logic/member_cubit/member_cubit.dart';
import '../../logic/member_cubit/member_state.dart';
import '../widgets/member_screen_widgets/invite_fab.dart';
import '../widgets/member_screen_widgets/invite_sheet.dart';
import '../widgets/member_screen_widgets/member_header.dart';
import '../widgets/member_screen_widgets/members_empty_state.dart';
import '../widgets/member_screen_widgets/members_error_view.dart';
import '../widgets/member_screen_widgets/members_list.dart';
import '../widgets/member_screen_widgets/members_loading_view.dart';
import '../../../../features/roles/utils/role_permissions_mapper.dart';

class MembersScreen extends StatelessWidget {
  final int workspaceId;
  final String workspaceName;

  /// بيتبعت من WorkspaceDashboardScreen عن طريق isOwnedByCurrentUser
  final bool isCurrentUserOwner;

  const MembersScreen({
    super.key,
    required this.workspaceId,
    required this.workspaceName,
    required this.isCurrentUserOwner,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<MembersCubit>()..getMembers(workspaceId),
      child: _MembersView(
        workspaceId: workspaceId,
        workspaceName: workspaceName,
        isCurrentUserOwner: isCurrentUserOwner,
      ),
    );
  }
}

class _MembersView extends StatelessWidget {
  final int workspaceId;
  final String workspaceName;
  final bool isCurrentUserOwner;

  const _MembersView({
    required this.workspaceId,
    required this.workspaceName,
    required this.isCurrentUserOwner,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F2FA),
      body: Stack(
        children: [
          const _BackgroundBlobs(),
          SafeArea(
            child: Column(
              children: [
                MemberHeader(workspaceName: workspaceName),
                Expanded(child: _buildBody(context)),
              ],
            ),
          ),
        ],
      ),
      // FAB يظهر بس للـ Owner
      floatingActionButton: isCurrentUserOwner
          ? Builder(
        builder: (ctx) => InviteFab(
          onTap: () => _showInviteSheet(ctx),
        ),
      )
          : null,
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocBuilder<MembersCubit, MembersState>(
      builder: (context, state) {
        return switch (state) {
          MembersLoading() => const MembersLoadingView(),
          MembersError(:final message) => MembersErrorView(message: message),
          MembersSuccess(:final members) when members.isEmpty =>
              MembersEmptyState(
                // زر الدعوة في الـ empty state يظهر بس للـ owner
                onInvite: isCurrentUserOwner ? () => _showInviteSheet(context) : null,
              ),
          MembersSuccess(:final members) => MembersList(
            members: members,
            workspaceId: workspaceId,
            // بس الـ owner يشوف زرار الـ permissions لكل member
            isCurrentUserOwner: isCurrentUserOwner,
          ),
          _ => const SizedBox.shrink(),
        };
      },
    );
  }

  void _showInviteSheet(BuildContext context) {
    final cubit = context.read<MembersCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => InviteSheet(
        // الكيوبيت بيتنادى هنا بس — InviteSheet مش عارفة عنه
        onInvite: (email, role) => cubit.addMember(
          workspaceId,
          email,
          permissions: RolePermissionsMapper.map(role),
        ),
      ),
    );
  }
}

class _BackgroundBlobs extends StatelessWidget {
  const _BackgroundBlobs();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -60,
          right: -40,
          child: _Blob(size: AppValues.blobSizeLg, color: AppColors.primary.withOpacity(0.18)),
        ),
        Positioned(
          bottom: 100,
          left: -60,
          child: _Blob(size: 40, color: AppColors.gradientBlue.withOpacity(0.12)),
        ),
      ],
    );
  }
}

class _Blob extends StatelessWidget {
  final double size;
  final Color color;
  const _Blob({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, Colors.transparent]),
      ),
    );
  }
}