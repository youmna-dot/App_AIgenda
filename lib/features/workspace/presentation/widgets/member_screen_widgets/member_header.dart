// presentation/screens/member_screen_widgets/member_header.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_values.dart';
import '../../../logic/member_cubit/member_cubit.dart';
import '../../../logic/member_cubit/member_state.dart';

class MemberHeader extends StatelessWidget {
  final String workspaceName;

  const MemberHeader({super.key, required this.workspaceName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppValues.paddingLg,
        AppValues.paddingMd,
        AppValues.paddingLg,
        AppValues.paddingLg,
      ),
      child: Row(
        children: [
          const _BackButton(),
          const SizedBox(width: 14),
          Expanded(child: _WorkspaceTitle(name: workspaceName)),
          const _MemberCountBadge(),
        ],
      ),
    );
  }
}

// Back Button 
class _BackButton extends StatelessWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pop(),
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: AppColors.cardBorder),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: AppColors.primary,
          size: 17,
        ),
      ),
    );
  }
}

// Workspace Title + Subtitle 
class _WorkspaceTitle extends StatelessWidget {
  final String name;

  const _WorkspaceTitle({required this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
            letterSpacing: -0.3,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          'Team Members',
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }
}

// Member Count Badge
class _MemberCountBadge extends StatelessWidget {
  const _MemberCountBadge();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MembersCubit, MembersState>(
      builder: (_, state) {
        if (state is! MembersSuccess) return const SizedBox.shrink();
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.people_alt_rounded, color: Colors.white, size: 14),
              const SizedBox(width: 5),
              Text(
                '${state.members.length}',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}