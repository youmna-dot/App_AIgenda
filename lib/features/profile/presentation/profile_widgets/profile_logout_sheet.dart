import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';
import 'profile_avatar.dart';

class ProfileLogoutSheet extends StatelessWidget {
  final String fullName;
  final String email;
  final String? imageUrl;
  final String initials;
  final VoidCallback onSignOut;
  final VoidCallback onStayLoggedIn;

  const ProfileLogoutSheet({
    super.key,
    required this.fullName,
    required this.email,
    required this.initials,
    required this.onSignOut,
    required this.onStayLoggedIn,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFEBE8FA),
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SheetHandle(),
          const SizedBox(height: 28),
          _WaveIcon(),
          const SizedBox(height: 20),
          Text('Leaving already?', style: AppTextStyles.profileLogoutTitle),
          const SizedBox(height: 12),
          Text(
            "You're about to sign out of your AIGENDA account. Your workspaces, notes and tasks will remain securely synced. You can sign in again anytime.",
            textAlign: TextAlign.center,
            style: AppTextStyles.profileLogoutBody,
          ),
          const SizedBox(height: 24),
          _UserCard(fullName: fullName, email: email, imageUrl: imageUrl, initials: initials),
          const SizedBox(height: 24),
          _SignOutButton(onTap: onSignOut),
          const SizedBox(height: 12),
          _StayLoggedInButton(onTap: onStayLoggedIn),
        ],
      ),
    );
  }
}

class _SheetHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.25),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class _WaveIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.12),
        shape: BoxShape.circle,
      ),
      child: const Center(child: Text('👋', style: TextStyle(fontSize: 28))),
    );
  }
}

class _UserCard extends StatelessWidget {
  final String fullName;
  final String email;
  final String? imageUrl;
  final String initials;

  const _UserCard({
    required this.fullName,
    required this.email,
    required this.imageUrl,
    required this.initials,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          ProfileAvatar(imageUrl: imageUrl, initials: initials, size: 48),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(fullName, style: AppTextStyles.profileLogoutUserName),
                const SizedBox(height: 2),
                Text(email, style: AppTextStyles.profileLogoutUserEmail),
              ],
            ),
          ),
          Icon(Icons.verified_user_outlined, color: Colors.grey.shade400, size: 22),
        ],
      ),
    );
  }
}

class _SignOutButton extends StatelessWidget {
  final VoidCallback onTap;

  const _SignOutButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 54,
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text('Sign Out', style: AppTextStyles.profileSignOutButton),
          ],
        ),
      ),
    );
  }
}

class _StayLoggedInButton extends StatelessWidget {
  final VoidCallback onTap;

  const _StayLoggedInButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 54,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: AppColors.primary, width: 1.5),
        ),
        child: Center(child: Text('Stay Logged In', style: AppTextStyles.profileStayButton)),
      ),
    );
  }
}