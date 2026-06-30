// lib/features/profile/presentation/screens/profile_screen.dart

import 'package:ajenda_app/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../config/routes/route_names.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_icons.dart';
import '../../../../../core/storage/secure_storage_service.dart';
import '../../../../../core/widgets/app_bottom_nav.dart';
import '../../../auth/presentation/widgets/auth_helpers.dart';
import '../../logic/profile_cubit/profile_cubit.dart';
import '../../logic/profile_cubit/profile_state.dart';
import '../profile_widgets/profile_action_row.dart';
import '../profile_widgets/profile_avatar.dart';
import '../profile_widgets/profile_hero.dart';
import '../profile_widgets/profile_logout_sheet.dart';
import '../profile_widgets/profile_personal_info_card.dart';
import '../profile_widgets/profile_stats_card.dart';
import '../profile_widgets/profile_top_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const int _navIndex = 4;

  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().getProfile();
  }

  void _showLogoutSheet(BuildContext context, dynamic profile) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ProfileLogoutSheet(
        fullName: profile?.fullName ?? 'User',
        email: profile?.email ?? '',
        imageUrl: profile?.profileImage,
        initials: profile?.initials ?? 'U',
        onSignOut: () async {
          Navigator.pop(context);
          await SecureStorageService().clearAll();
          if (context.mounted) context.go(RouteNames.login);
        },
        onStayLoggedIn: () => Navigator.pop(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileError) showAuthError(context, state.errMessage);
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                strokeWidth: 2.5,
              ),
            );
          }

          final profile = context.read<ProfileCubit>().currentProfile;

          return SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const ProfileTopBar(),
                  ProfileAvatar(
                    imageUrl: profile?.profileImage,
                    initials: profile?.initials ?? 'U',
                    size: 100,
                  ),
                  const SizedBox(height: 14),
                  ProfileHero(profile: profile),
                  const SizedBox(height: 28),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ProfileStatsCard(
                      workspacesCount: 12,
                      spacesCount: 34,
                      tasksCount: 148,
                      notesCount: 56,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Personal Information',
                          style: AppTextStyles.profileSectionTitle,
                        ),
                        const SizedBox(height: 12),
                        ProfilePersonalInfoCard(profile: profile),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _ActionsCard(
                      onEditProfile: () async {
                        await context.push(RouteNames.editProfile);
                        if (mounted) {
                          context.read<ProfileCubit>().refreshProfile();
                        }
                      },
                      onSignOut: () => _showLogoutSheet(context, profile),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: AppBottomNav.fab(onTap: () {}),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AppBottomNav(
        currentIndex: _navIndex,
        onTap: (_) {},
        onHomeTap: () => context.go(RouteNames.home),
        onWorkspacesTap: () => context.go(RouteNames.workspaces),
        onProfileTap: () {},
      ),
    );
  }
}

class _ActionsCard extends StatelessWidget {
  final VoidCallback onEditProfile;
  final VoidCallback onSignOut;

  const _ActionsCard({
    required this.onEditProfile,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          ProfileActionRow(
            icon: AppIcons.edit,
            iconColor: AppColors.primary,
            label: 'Edit Profile',
            onTap: onEditProfile,
          ),
          const Divider(
            height: 1,
            thickness: 1,
            color: Color(0xFFF0EEF8),
            indent: 56,
          ),
          ProfileActionRow(
            icon: AppIcons.logout,
            iconColor: AppColors.error,
            label: 'Sign Out',
            isDestructive: true,
            onTap: onSignOut,
          ),
        ],
      ),
    );
  }
}
