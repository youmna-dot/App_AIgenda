// lib/features/settings/presentation/screens/change_email_screen.dart

import 'package:ajenda_app/features/profile/logic/profile_cubit/profile_cubit.dart';
import 'package:ajenda_app/features/profile/logic/profile_cubit/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../config/routes/route_names.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_icons.dart';
import '../../../../../core/constants/app_values.dart';
import '../../../../../core/widgets/primary_button.dart';
import '../../../auth/presentation/widgets/auth_helpers.dart';
import '../widgets/info_banner.dart';
import '../widgets/settings_app_bar.dart';

class ChangeEmailScreen extends StatefulWidget {
  const ChangeEmailScreen({super.key});

  @override
  State<ChangeEmailScreen> createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends State<ChangeEmailScreen> {
  final _formKey      = GlobalKey<FormState>();
  final _newEmailCtrl = TextEditingController();

  @override
  void dispose() {
    _newEmailCtrl.dispose();
    super.dispose();
  }

  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Enter a new email address';
    final emailRegex = RegExp(r'^[\w\.\-]+@[\w\-]+\.\w{2,}$');
    if (!emailRegex.hasMatch(v.trim())) return 'Enter a valid email address';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ChangeEmailCodeSent) {
            context.push(
              RouteNames.verifyEmail,
              extra: {
                'newEmail': _newEmailCtrl.text.trim(),
                'id': state.id,
              },
            );
          }
          if (state is ChangeEmailFailure) {
            showAuthError(context, state.errMessage);
          }
        },
        builder: (context, state) {
          final isLoading = state is ChangeEmailLoading;

          final cubitState = context.read<ProfileCubit>().state;
          final currentEmail =
              cubitState is ProfileLoaded ? cubitState.profile.email : '';

          return SafeArea(
            child: Column(
              children: [
                SettingsAppBar(
                  title: 'Change Email',
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
                          // Form card
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(AppValues.paddingLg),
                            decoration: BoxDecoration(
                              color:  AppColors.primary.withOpacity(0.07),
                              borderRadius:
                                  BorderRadius.circular(AppValues.radiusXl),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Current Email',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textDark,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                _ReadOnlyEmailField(email: currentEmail),
                                const SizedBox(height: AppValues.paddingMd),
                                Text(
                                  'New Email',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _newEmailCtrl,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: _validateEmail,
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: AppColors.wsHeading,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Enter new email address',
                                    hintStyle: GoogleFonts.outfit(
                                      fontSize: 14,
                                      color: AppColors.textHint,
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.alternate_email_rounded,
                                      color: AppColors.primary,
                                      size: 20,
                                    ),
                                    filled: true,
                                    fillColor: AppColors.background,
                                    contentPadding:
                                        const EdgeInsets.symmetric(
                                      horizontal: AppValues.paddingMd,
                                      vertical: AppValues.paddingMd,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                        AppValues.radiusMd,
                                      ),
                                      borderSide: BorderSide.none,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                        AppValues.radiusMd,
                                      ),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                        AppValues.radiusMd,
                                      ),
                                      borderSide: const BorderSide(
                                        color: AppColors.primary,
                                        width: 1.5,
                                      ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                        AppValues.radiusMd,
                                      ),
                                      borderSide: const BorderSide(
                                        color: AppColors.error,
                                        width: 1.5,
                                      ),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                        AppValues.radiusMd,
                                      ),
                                      borderSide: const BorderSide(
                                        color: AppColors.error,
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppValues.paddingLg),

                          const InfoBanner(
                            text: 'A verification code will be sent to your new email.',
                          ),
                          const SizedBox(height: AppValues.paddingXl),

                          PrimaryButton(
                            text: 'Send Verification Code',
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
                                context.read<ProfileCubit>().changeEmail(
                                      newEmail: _newEmailCtrl.text.trim(),
                                    );
                              }
                            },
                          ),
                          const SizedBox(height: AppValues.paddingMd),

                          Center(
                            child: RichText(
                              text: TextSpan(
                                style: GoogleFonts.outfit(
                                  fontSize: 13,
                                  color: AppColors.wsSubtext,
                                ),
                                children: [
                                  const TextSpan(text: 'Need help? '),
                                  TextSpan(
                                    text: 'Contact Support',
                                    style: GoogleFonts.outfit(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ReadOnlyEmailField extends StatelessWidget {
  final String email;

  const _ReadOnlyEmailField({required this.email});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppValues.paddingMd,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: AppColors.roleViewer.withOpacity(0.10),
        borderRadius: BorderRadius.circular(AppValues.radiusMd),
      ),
      child: Row(
        children: [
          const Icon(AppIcons.email, color: AppColors.wsSubtext, size: 20),
          const SizedBox(width: 10),
          Text(
            email.isEmpty ? 'loading...' : email,
            style: GoogleFonts.outfit(
              fontSize: 14,
              color: AppColors.wsHeading,
            ),
          ),
        ],
      ),
    );
  }
}