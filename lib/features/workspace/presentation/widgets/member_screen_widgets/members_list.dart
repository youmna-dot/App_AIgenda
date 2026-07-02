// features/workspace/presentation/widgets/member_screen_widgets/members_list.dart

import 'package:ajenda_app/features/workspace/logic/member_cubit/member_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../config/routes/route_names.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../data/models/member_model.dart';

class MembersList extends StatelessWidget {
  final List<MemberModel> members;
  final int workspaceId;
  final bool isCurrentUserOwner;

  const MembersList({
    super.key,
    required this.members,
    required this.workspaceId,
    required this.isCurrentUserOwner,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 120),
      itemCount: members.length,
      itemBuilder: (context, index) => _MemberCard(
        member: members[index],
        workspaceId: workspaceId,
        index: index,
        showActionsButton: isCurrentUserOwner && !members[index].isOwner,
      ),
    );
  }
}
class _MemberCard extends StatelessWidget {
  final MemberModel member;
  final int workspaceId;
  final int index;
  final bool showActionsButton;

  const _MemberCard({
    required this.member,
    required this.workspaceId,
    required this.index,
    required this.showActionsButton,
  });

  String get _initials {
    final parts = member.fullName.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return member.fullName.isNotEmpty
        ? member.fullName[0].toUpperCase()
        : '?';
  }

  String get _roleAndPermissionsLabel {
    final roleLabel = member.isOwner ? 'Owner' : 'Member';
    final count = member.permissions.length;
    return '$roleLabel · $count permission${count == 1 ? '' : 's'}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEAE6F4)),
        boxShadow: [
          BoxShadow(
            color: AppColors.appPurpleDark.withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _MemberAvatar(
            avatarUrl: member.avatarUrl,
            initials: _initials,
          ),
          const SizedBox(width: 14),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.fullName,
                  style: GoogleFonts.poppins(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF15073A),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  _roleAndPermissionsLabel,
                  style: GoogleFonts.poppins(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    color: member.isOwner
                        ? const Color(0xFFFF9500)
                        : AppColors.primary,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Icon(
                      Icons.mail_outline_rounded,
                      size: 13,
                      color: AppColors.textMuted.withOpacity(0.7),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        member.email,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 3-dot actions — Owner بس، وليس على الـ owner نفسه
          if (showActionsButton)
  GestureDetector(
    onTap: () async {
      final cubit = context.read<MembersCubit>();
      await context.push(
        RouteNames.permissions,
        extra: {
          'workspaceId': workspaceId,
          'userId': member.userId,
          'permissions': member.permissions,
          'canUserModify': true,
        },
      );
      cubit.getMembers(workspaceId);
    },
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Icon(
                  Icons.more_vert_rounded,
                  color: AppColors.textDark.withOpacity(0.6),
                  size: 22,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Avatar — صورة حقيقية لو موجودة، وإلا gradient بحروف الاسم ──
// نفس تدرج appPurpleGradient بتاع زرار Invite Member
class _MemberAvatar extends StatelessWidget {
  final String? avatarUrl;
  final String initials;

  const _MemberAvatar({
    required this.avatarUrl,
    required this.initials,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppColors.appPurpleGradient,
        boxShadow: [
          BoxShadow(
            color: AppColors.appPurpleDark.withOpacity(0.30),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipOval(
        child: avatarUrl != null && avatarUrl!.isNotEmpty
            ? Image.network(
                avatarUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _InitialsFallback(initials: initials),
              )
            : _InitialsFallback(initials: initials),
      ),
    );
  }
}

class _InitialsFallback extends StatelessWidget {
  final String initials;

  const _InitialsFallback({required this.initials});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        initials,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
    );
  }
}