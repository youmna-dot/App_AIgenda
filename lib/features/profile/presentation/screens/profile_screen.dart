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
                      onConnectApps: () => context.push(RouteNames.connectApps),
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
  final VoidCallback onConnectApps;

  const _ActionsCard({
    required this.onEditProfile,
    required this.onSignOut,
    required this.onConnectApps,
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
            icon: Icons.link_rounded,
            iconColor: AppColors.primary,
            label: 'Connect Apps',
            onTap: onConnectApps,
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF0EEF8), indent: 56),
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















// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:google_fonts/google_fonts.dart';

// import '../../../../../config/routes/route_names.dart';
// import '../../../../../core/constants/app_colors.dart';
// import '../../../../../core/constants/app_text_styles.dart';
// import '../../../../../core/constants/app_values.dart';
// import '../../../../core/constants/app_icons.dart';
// import '../../../../core/storage/secure_storage_service.dart';
// import '../../../auth/presentation/widgets/auth_helpers.dart';
// import '../../logic/profile_cubit/profile_cubit.dart';
// import '../../logic/profile_cubit/profile_state.dart';
// import '../profile_widgets/profile_menu_card.dart';
// import '../profile_widgets/shared_profile_widgets.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<ProfileCubit>().getProfile();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F3FF),
//       body: BlocConsumer<ProfileCubit, ProfileState>(
//         listener: (context, state) {
//           if (state is ProfileError) showAuthError(context, state.errMessage);
//         },
//         builder: (context, state) {
//           if (state is ProfileLoading) {
//             return const Center(
//               child: CircularProgressIndicator(
//                 valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7C5CBF)),
//                 strokeWidth: 2.5,
//               ),
//             );
//           }

//           final profile = context.read<ProfileCubit>().currentProfile;
//           final firstName = profile?.firstName ?? '';
//           final lastName = profile?.secondName ?? '';
//           final email = profile?.email ?? '';
//           final initials = [
//             if (firstName.isNotEmpty) firstName[0],
//             if (lastName.isNotEmpty) lastName[0],
//           ].join().toUpperCase();
//           final fullName = '$firstName $lastName'.trim();

//           return SafeArea(
//             child: SingleChildScrollView(
//               physics: const BouncingScrollPhysics(),
//               child: Column(
//                 children: [
//                   GestureDetector(onTap: () => context.pop(), child: backBtn()),
//                   _buildTopBar(context),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     child: ProfileCard(
//                       initials: initials.isEmpty ? 'U' : initials,
//                       fullName: fullName.isEmpty ? 'User' : fullName,
//                       email: email,
//                       imageUrl: profile?.profileImage,
//                     ),
//                   ),
//                   const SizedBox(height: 6),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const SectionLabel(label: 'Account'),
//                         MenuCard(
//                           items: [
//                             MenuItem(
//                               icon: AppIcons.person,
//                               iconBg: const Color(0xFFEDE6FF),
//                               iconColor: const Color(0xFF7C5CBF),
//                               label: 'Edit Profile',
//                               sub: 'Update your info',
//                               onTap: () async {
//                                 await context.push(RouteNames.editProfile);
//                                 if (mounted)
//                                   context.read<ProfileCubit>().refreshProfile();
//                               },
//                             ),
//                             MenuItem(
//                               icon: AppIcons.lockFilled,
//                               iconBg: const Color(0xFFE6F4FF),
//                               iconColor: const Color(0xFF3B7ADE),
//                               label: 'Change Password',
//                               sub: 'Keep your account safe',
//                               onTap: () =>
//                                   context.push(RouteNames.changePassword),
//                             ),
//                           ],
//                         ),
//                         const SectionLabel(label: 'Preferences'),
//                         MenuCard(
//                           items: [
//                             MenuItem(
//                               icon: AppIcons.darkMode,
//                               iconBg: const Color(0xFFE6FFEF),
//                               iconColor: const Color(0xFF1D9E75),
//                               label: 'Dark Mode',
//                               sub: 'Switch appearance',
//                               trailing: ToggleSwitch(
//                                 value: false,
//                                 onChanged: (_) {},
//                               ),
//                             ),
//                             MenuItem(
//                               icon: AppIcons.notifications,
//                               iconBg: const Color(0xFFFFF8E1),
//                               iconColor: const Color(0xFFFFB300),
//                               label: 'Notifications',
//                               sub: 'Reminders and alerts',
//                               onTap: () {},
//                             ),
//                             MenuItem(
//                               icon: AppIcons.star,
//                               iconBg: const Color(0xFFFFEBEE),
//                               iconColor: const Color(0xFFE53935),
//                               label: 'Rate AI-Genda',
//                               sub: 'Share your feedback',
//                               onTap: () {},
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 14),
//                         SignOutButton(onTap: () => _showLogoutDialog(context)),
//                         const SizedBox(height: 20),
//                         Center(
//                           child: Column(
//                             children: [
//                               Text(
//                                 'Powered by',
//                                 style: GoogleFonts.poppins(
//                                   fontSize: 10,
//                                   color: const Color(0xFFC0BCDA),
//                                 ),
//                               ),
//                               ListTile(
//                                 leading: const Icon(Icons.link_rounded),
//                                 title: const Text('Connect Apps'),
//                                 trailing: const Icon(Icons.chevron_right_rounded),
//                                 onTap: () => context.push(RouteNames.connectApps),
//                               ),

//                               Text(
//                                 'ByteVerse',
//                                 style: GoogleFonts.poppins(
//                                   fontSize: 13,
//                                   fontWeight: FontWeight.w700,
//                                   color: const Color(0xFF7C5CBF),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(height: 12),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildTopBar(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           const SizedBox(width: 36),
//           Text(
//             'Profile',
//             style: GoogleFonts.poppins(
//               fontSize: 17,
//               fontWeight: FontWeight.w700,
//               color: const Color(0xFF1E0F5C),
//             ),
//           ),
//           Container(
//             width: 36,
//             height: 36,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: const Color(0xFFE8E4F5), width: 1.2),
//             ),
//             child: const Icon(
//               AppIcons.settings,
//               color: Color(0xFF7C5CBF),
//               size: 18,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showLogoutDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         title: Text(
//           'Log Out',
//           style: GoogleFonts.poppins(
//             fontWeight: FontWeight.w700,
//             color: const Color(0xFF1E0F5C),
//           ),
//         ),
//         content: Text(
//           'Are you sure you want to log out?',
//           style: GoogleFonts.poppins(
//             fontSize: 13,
//             color: const Color(0xFF8A84A3),
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text(
//               'Cancel',
//               style: GoogleFonts.poppins(color: const Color(0xFF8A84A3)),
//             ),
//           ),
//           TextButton(
//             onPressed: () async {
//               Navigator.pop(context);
//               await SecureStorageService().clearAll();
//               if (context.mounted) context.go(RouteNames.login);
//             },
//             child: Text(
//               'Log Out',
//               style: GoogleFonts.poppins(
//                 color: const Color(0xFFE53935),
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }