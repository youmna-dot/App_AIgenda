// presentation/widgets/member_screen_widgets/invite_sheet.dart

import 'package:ajenda_app/features/roles/models/workspce_role.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_values.dart';
import 'inline_role_picker.dart';

/// Pure sheet — لا يعرف عن MembersCubit.
/// المسؤولية كلها على MembersScreen اللي بتفتحها.
class InviteSheet extends StatefulWidget {
  /// الـ screen بتمرر الـ callback ده، وهي اللي بتكلم الكيوبيت.
  final Future<void> Function(String email, WorkspaceRole role) onInvite;

  const InviteSheet({super.key, required this.onInvite});

  @override
  State<InviteSheet> createState() => _InviteSheetState();
}

class _InviteSheetState extends State<InviteSheet> {
  final _emailController = TextEditingController();
  bool _isLoading = false;
  String? _error;
  WorkspaceRole _selectedRole = WorkspaceRole.viewer;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendInvitation() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      setState(() => _error = 'Enter an email address.');
      return;
    }
    if (!email.contains('@')) {
      setState(() => _error = 'Enter a valid email address.');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    // الكيوبيت بيتنادى من الـ screen، مش من هنا
    await widget.onInvite(email, _selectedRole);

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + AppValues.paddingLg,
        left: AppValues.paddingXl,
        right: AppValues.paddingXl,
        top: AppValues.paddingMd,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SheetHandle(),
          const SizedBox(height: 20),
          const _SheetTitle(),
          const SizedBox(height: 24),
          _EmailField(
            controller: _emailController,
            hasError: _error != null,
            onSubmitted: (_) => _sendInvitation(),
          ),
          if (_error != null) ...[
            const SizedBox(height: 8),
            _ErrorMessage(message: _error!),
          ],
          const SizedBox(height: 20),
          Text(
            'Member Role',
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.wsHeading,
            ),
          ),
          const SizedBox(height: 10),
          InlineRolePicker(
            selected: _selectedRole,
            onChanged: (role) => setState(() => _selectedRole = role),
          ),
          const SizedBox(height: 20),
          _SubmitButton(isLoading: _isLoading, onTap: _sendInvitation),
        ],
      ),
    );
  }
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 36,
        height: 4,
        decoration: BoxDecoration(
          color: AppColors.wsHandleBar,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

class _SheetTitle extends StatelessWidget {
  const _SheetTitle();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            gradient: AppColors.appPurpleGradient,
            borderRadius: BorderRadius.circular(13),
            boxShadow: [
              BoxShadow(
                color: AppColors.appPurpleDark.withOpacity(0.30),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(Icons.person_add_rounded, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 13),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Invite Member',
              style: GoogleFonts.poppins(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.wsHeading,
                letterSpacing: -0.2,
              ),
            ),
            Text(
              "They'll receive an email invite.",
              style: GoogleFonts.poppins(fontSize: 11.5, color: AppColors.primary),
            ),
          ],
        ),
      ],
    );
  }
}

class _EmailField extends StatelessWidget {
  final TextEditingController controller;
  final bool hasError;
  final ValueChanged<String> onSubmitted;

  const _EmailField({
    required this.controller,
    required this.hasError,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email Address',
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.wsHeading,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppValues.radiusMd),
            border: Border.all(
              color: hasError
                  ? AppColors.error.withOpacity(0.5)
                  : AppColors.primary.withOpacity(0.2),
            ),
          ),
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.emailAddress,
            autofocus: true,
            style: GoogleFonts.poppins(fontSize: 14, color: AppColors.wsHeading),
            decoration: InputDecoration(
              hintText: 'member@example.com',
              hintStyle: GoogleFonts.poppins(fontSize: 13, color: AppColors.textHint),
              prefixIcon: Icon(
                Icons.email_outlined,
                color: AppColors.primary,
                size: AppValues.iconSizeMd,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppValues.paddingMd,
                vertical: AppValues.paddingMd,
              ),
            ),
            onSubmitted: onSubmitted,
          ),
        ),
      ],
    );
  }
}

class _ErrorMessage extends StatelessWidget {
  final String message;
  const _ErrorMessage({required this.message});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.error_outline_rounded, color: AppColors.error, size: 14),
        const SizedBox(width: 5),
        Text(
          message,
          style: GoogleFonts.poppins(fontSize: 11.5, color: AppColors.error),
        ),
      ],
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTap;
  const _SubmitButton({required this.isLoading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: AnimatedContainer(
        duration: AppValues.animFast,
        height: AppValues.inviteFabHeight,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: isLoading
              ? const LinearGradient(colors: [AppColors.grey, AppColors.grey])
              : AppColors.appPurpleGradient,
          borderRadius: BorderRadius.circular(AppValues.pillRadius),
          boxShadow: isLoading
              ? []
              : [
            BoxShadow(
              color: AppColors.appPurpleDark.withOpacity(0.30),
              blurRadius: 18,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
          )
              : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.send_rounded, color: Colors.white, size: 17),
              const SizedBox(width: 8),
              Text(
                'Send Invitation',
                style: GoogleFonts.outfit(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}