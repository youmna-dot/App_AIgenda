// features/workspace/presentation/widgets/member_screen_widgets/members_list.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../config/routes/route_names.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../data/models/member_model.dart';

/// Pure widget — بتستقبل members وcallbacks.
/// الـ permissions button يظهر بس لما isCurrentUserOwner = true
/// وبس على members مش owners.
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
        // زرار الـ permissions يظهر بس لو:
        // 1. اليوزر الحالي هو الـ owner
        // 2. الكارد مش بتاع الـ owner نفسه
        showPermissionsButton:
        isCurrentUserOwner && !members[index].isOwner,
      ),
    );
  }
}

class _MemberCard extends StatelessWidget {
  final MemberModel member;
  final int workspaceId;
  final int index;
  final bool showPermissionsButton;

  const _MemberCard({
    required this.member,
    required this.workspaceId,
    required this.index,
    required this.showPermissionsButton,
  });

  static const _avatarGradients = [
    [Color(0xFF6C4AB6), Color(0xFF4A90E2)],
    [Color(0xFF1D9E75), Color(0xFF0D9488)],
    [Color(0xFFE11D8E), Color(0xFF7C3AED)],
    [Color(0xFFF59E0B), Color(0xFFEF4444)],
    [Color(0xFF0EA5E9), Color(0xFF6C4AB6)],
    [Color(0xFF059669), Color(0xFF0D9488)],
  ];

  List<Color> get _gradient =>
      _avatarGradients[index % _avatarGradients.length];

  String get _initials {
    final parts = member.fullName.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return member.fullName.isNotEmpty
        ? member.fullName[0].toUpperCase()
        : '?';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEAE6F4)),
        boxShadow: [
          BoxShadow(
            color: _gradient[0].withOpacity(0.08),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: _gradient[0].withOpacity(0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  _initials,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          member.fullName,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF15073A),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (member.isOwner) ...[
                        const SizedBox(width: 6),
                        _OwnerBadge(),
                      ],
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    member.email,
                    style: GoogleFonts.poppins(
                      fontSize: 11.5,
                      color: AppColors.textMuted,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (member.permissions.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    _PermissionBadge(count: member.permissions.length),
                  ],
                ],
              ),
            ),

            // Permissions Button — Owner بس، وليس على الـ owner نفسه
            if (showPermissionsButton)
              GestureDetector(
                onTap: () => context.push(
                  RouteNames.permissions,
                  extra: {
                    'workspaceId': workspaceId,
                    'userId': member.userId,
                    'permissions': member.permissions,
                    'canUserModify': true,
                  },
                ),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      _gradient[0].withOpacity(0.12),
                      _gradient[1].withOpacity(0.12),
                    ]),
                    borderRadius: BorderRadius.circular(11),
                    border: Border.all(color: _gradient[0].withOpacity(0.2)),
                  ),
                  child: Icon(
                    Icons.tune_rounded,
                    color: _gradient[0],
                    size: 18,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _OwnerBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFD700), Color(0xFFFF9500)],
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFB300).withOpacity(0.35),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, color: Colors.white, size: 10),
          const SizedBox(width: 3),
          Text(
            'Owner',
            style: GoogleFonts.poppins(
              fontSize: 9.5,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _PermissionBadge extends StatelessWidget {
  final int count;
  const _PermissionBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.shield_outlined,
            size: 11,
            color: AppColors.primary.withOpacity(0.8),
          ),
          const SizedBox(width: 4),
          Text(
            '$count permissions',
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}