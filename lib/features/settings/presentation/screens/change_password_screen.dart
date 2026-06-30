// lib/features/profile/presentation/screens/change_password_screen.dart

import 'package:ajenda_app/features/profile/logic/profile_cubit/profile_cubit.dart';
import 'package:ajenda_app/features/profile/logic/profile_cubit/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_values.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../auth/presentation/widgets/auth_helpers.dart';
import '../../../settings/presentation/widgets/info_banner.dart';
import '../../../settings/presentation/widgets/password_field.dart';
import '../../../settings/presentation/widgets/settings_app_bar.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey         = GlobalKey<FormState>();
  final _currentPassCtrl = TextEditingController();
  final _newPassCtrl     = TextEditingController();
  final _confirmPassCtrl = TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew     = true;
  bool _obscureConfirm = true;
  bool _isSuccess      = false;

  @override
  void dispose() {
    _currentPassCtrl.dispose();
    _newPassCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  String? _validateNewPassword(String? v) {
    if (v == null || v.isEmpty) return 'Enter a new password';
    if (v.length < 8) return 'At least 8 characters';
    if (!v.contains(RegExp(r'[A-Z]'))) return 'Add uppercase letter (A-Z)';
    if (!v.contains(RegExp(r'[a-z]'))) return 'Add lowercase letter (a-z)';
    if (!v.contains(RegExp(r'[0-9]'))) return 'Add a number (0-9)';
    if (!v.contains(RegExp(r'[!@#\$%^&*()_+\-=\[\]{}|;:,.<>?]'))) {
      return r'Add a special character e.g. !@#$%';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ChangePasswordSuccess) setState(() => _isSuccess = true);
          if (state is ChangePasswordFailure) {
            showAuthError(context, state.errMessage);
          }
        },
        builder: (context, state) {
          final isLoading = state is ChangePasswordLoading;

          return SafeArea(
            child: _isSuccess
                ? _SuccessView(onDone: () => context.pop())
                : Column(
                    children: [
                      SettingsAppBar(
                        title: 'Change Password',
                        onBack: () => context.pop(),
                      ),
                      const Divider(height: 1, color: AppColors.cardBorder),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppValues.horizontalPadding,
                            vertical: AppValues.paddingXl,
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding:
                                      const EdgeInsets.all(AppValues.paddingLg),
                                  decoration: BoxDecoration(
                                    color:  AppColors.primary.withOpacity(0.07),
                                    borderRadius: BorderRadius.circular(
                                      AppValues.radiusXl,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      PasswordField(
                                        label: 'Current Password',
                                        controller: _currentPassCtrl,
                                        obscure: _obscureCurrent,
                                        onToggle: () => setState(() =>
                                            _obscureCurrent = !_obscureCurrent),
                                        validator: (v) =>
                                            (v == null || v.isEmpty)
                                                ? 'Enter your current password'
                                                : null,
                                      ),
                                      const SizedBox(
                                        height: AppValues.paddingMd,
                                      ),
                                      PasswordField(
                                        label: 'New Password',
                                        controller: _newPassCtrl,
                                        obscure: _obscureNew,
                                        onToggle: () => setState(
                                          () => _obscureNew = !_obscureNew,
                                        ),
                                        validator: _validateNewPassword,
                                      ),
                                      const SizedBox(
                                        height: AppValues.paddingMd,
                                      ),
                                      PasswordField(
                                        label: 'Confirm New Password',
                                        controller: _confirmPassCtrl,
                                        obscure: _obscureConfirm,
                                        onToggle: () => setState(() =>
                                            _obscureConfirm = !_obscureConfirm),
                                        validator: (v) =>
                                            v != _newPassCtrl.text
                                                ? "Passwords don't match"
                                                : null,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: AppValues.paddingMd),
                                const InfoBanner(
                                  text: r'Must have: A-Z · a-z · 0-9 · special char (!@#$%)',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          AppValues.horizontalPadding,
                          0,
                          AppValues.horizontalPadding,
                          AppValues.paddingXl +
                              MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: PrimaryButton(
                          text: 'Update Password',
                          isLoading: isLoading,
                          trailingWidget: isLoading
                              ? null
                              : const Icon(
                                  Icons.arrow_forward_rounded,
                                  color: AppColors.white,
                                  size: 18,
                                ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<ProfileCubit>().changePassword(
                                    currentPassword: _currentPassCtrl.text,
                                    newPassword: _newPassCtrl.text,
                                  );
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: AppValues.paddingMd),
                    ],
                  ),
          );
        },
      ),
    );
  }
}

class _SuccessView extends StatelessWidget {
  final VoidCallback onDone;

  const _SuccessView({required this.onDone});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SettingsAppBar(title: 'Change Password', onBack: onDone),
        const Divider(height: 1, color: AppColors.cardBorder),
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.accentGreen.withOpacity(0.07),
                        ),
                      ),
                      Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.accentGreen.withOpacity(0.12),
                        ),
                      ),
                      Container(
                        width: 72,
                        height: 72,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.accentGreen,
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 38,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Password Updated',
                    style: GoogleFonts.outfit(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: AppColors.wsHeading,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Your password has been updated successfully.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      color: AppColors.wsSubtext,
                      height: 1.55,
                    ),
                  ),
                  const SizedBox(height: AppValues.paddingXl),
                  PrimaryButton(text: 'Done', onPressed: onDone),
                  const SizedBox(height: AppValues.paddingMd),
                  Text(
                    'Need help? Contact support@aigenda.ai',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      color: AppColors.wsSubtext,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}