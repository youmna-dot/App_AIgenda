// presentation/screens/member_screen_widgets/member_card.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../config/routes/route_names.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_values.dart';
import '../../../data/models/member_model.dart';
import 'permission_badge.dart';

class MemberCard extends StatelessWidget {
  final MemberModel member;
  final int workspaceId;
  final int index;
  final bool isCurrentUserOwner;

  const MemberCard({
    super.key,
    required this.member,
    required this.workspaceId,
    required this.index,
    required this.isCurrentUserOwner,
  });

  static const _avatarGradients = [
    [AppColors.gradientPurple, AppColors.gradientBlue],
    [AppColors.accentGreen, Color(0xFF0D9488)],
    [AppColors.instructionPink, AppColors.roleCustom],
    [AppColors.accentOrange, AppColors.accentRed],
    [Color(0xFF0EA5E9), AppColors.gradientPurple],
    [Color(0xFF059669), Color(0xFF0D9488)],
  ];

  List<Color> get _gradient =>
      _avatarGradients[index % _avatarGradients.length];

  String get _initials {
    final parts = member.fullName.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return member.fullName.isNotEmpty ? member.fullName[0].toUpperCase() : '?';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppValues.radiusXl),
        border: Border.all(color: AppColors.cardBorder),
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
            _MemberAvatar(initials: _initials, gradient: _gradient),
            const SizedBox(width: 14),
            Expanded(child: _MemberInfo(member: member)),
            if (isCurrentUserOwner && !member.isOwner)
              _EditPermissionsButton(
                gradient: _gradient,
                onTap: () => context.push(
                  RouteNames.permissions,
                  extra: {
                    'workspaceId': workspaceId,
                    'userId': member.userId,
                    'permissions': member.permissions,
                    'canUserModify': isCurrentUserOwner,
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Avatar 
class _MemberAvatar extends StatelessWidget {
  final String initials;
  final List<Color> gradient;

  const _MemberAvatar({required this.initials, required this.gradient});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppValues.memberAvatarSize,
      height: AppValues.memberAvatarSize,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: gradient[0].withOpacity(0.35),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          initials,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}

// Member Info 
class _MemberInfo extends StatelessWidget {
  final MemberModel member;

  const _MemberInfo({required this.member});

  @override
  Widget build(BuildContext context) {
    return Column(
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
                  color: AppColors.textDark,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (member.isOwner) ...[
              const SizedBox(width: 6),
              const _OwnerBadge(),
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
          PermissionBadge(count: member.permissions.length),
        ],
      ],
    );
  }
}

// Owner Badge
class _OwnerBadge extends StatelessWidget {
  const _OwnerBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFD700), Color(0xFFFF9500)],
        ),
        borderRadius: BorderRadius.circular(AppValues.paddingXs),
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
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}

// Edit Permissions Button
class _EditPermissionsButton extends StatelessWidget {
  final List<Color> gradient;
  final VoidCallback onTap;

  const _EditPermissionsButton({
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              gradient[0].withOpacity(0.12),
              gradient[1].withOpacity(0.12),
            ],
          ),
          borderRadius: BorderRadius.circular(11),
          border: Border.all(color: gradient[0].withOpacity(0.2)),
        ),
        child: Icon(Icons.tune_rounded, color: gradient[0], size: AppValues.iconSizeMd),
      ),
    );
  }
}