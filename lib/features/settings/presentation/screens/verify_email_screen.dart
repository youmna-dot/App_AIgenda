// lib/features/settings/presentation/screens/verify_email_screen.dart

import 'dart:async';

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
import '../widgets/settings_app_bar.dart';

class VerifyEmailScreen extends StatefulWidget {
  final String newEmail;
  final String id;

  const VerifyEmailScreen({
    super.key,
    required this.newEmail,
    required this.id,
  });

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final _codeCtrl = TextEditingController();
  final _formKey  = GlobalKey<FormState>();

  static const _timerSeconds = 120;
  int    _secondsLeft = _timerSeconds;
  Timer? _timer;
  bool   _canResend  = false;
  bool   _isSuccess  = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _secondsLeft = _timerSeconds;
      _canResend   = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft <= 1) {
        t.cancel();
        setState(() => _canResend = true);
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  String get _timerLabel {
    final m = (_secondsLeft ~/ 60).toString().padLeft(2, '0');
    final s = (_secondsLeft % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  String _maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return email;
    final name    = parts[0];
    final domain  = parts[1];
    final visible = name.length > 3 ? name.substring(0, 3) : name;
    return '$visible***@$domain';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _codeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) async {
          if (state is ConfirmChangeEmailSuccess) {
            setState(() => _isSuccess = true);

            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: AppColors.accentGreen,
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  duration: const Duration(seconds: 2),
                  content: Row(
                    children: [
                      const Icon(Icons.check_circle_outline,
                          color: Colors.white, size: 22),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Email updated! Please sign in again.',
                          style: GoogleFonts.outfit(
                              color: Colors.white, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              );
              await Future.delayed(const Duration(seconds: 2));
            }

            if (context.mounted) {
              context.go(RouteNames.login);
            }
          }

          if (state is ConfirmChangeEmailFailure) {
            showAuthError(context, state.errMessage);
          }

          if (state is ChangeEmailCodeSent) {
            _startTimer();
          }
        },
        builder: (context, state) {
          final isLoading   = state is ConfirmChangeEmailLoading;
          final isResending = state is ChangeEmailLoading;

          if (_isSuccess) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          return SafeArea(
            child: Column(
              children: [
                SettingsAppBar(title: 'Verify Email', onBack: () => context.pop()),
                const Divider(height: 1, color: AppColors.cardBorder),

                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppValues.horizontalPadding,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const SizedBox(height: AppValues.paddingXl),

                            // ── Envelope icon ──
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.07),
                                borderRadius:
                                    BorderRadius.circular(AppValues.radiusCard),
                              ),
                              child: const Icon(
                                AppIcons.checkEmail,
                                size: 56,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: AppValues.paddingXl),

                            // ── Title ──
                            Text(
                              'Check your inbox',
                              style: GoogleFonts.outfit(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: AppColors.wsHeading,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "We've sent a verification code to",
                              style: GoogleFonts.outfit(
                                  fontSize: 14, color: AppColors.wsSubtext),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _maskEmail(widget.newEmail),
                              style: GoogleFonts.outfit(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.wsHeading,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: AppValues.paddingXl),

                            // ── Code field ──
                            TextFormField(
                              controller: _codeCtrl,
                              keyboardType: TextInputType.text,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.wsHeading,
                                letterSpacing: 2,
                              ),
                              validator: (v) =>
                                  (v == null || v.trim().isEmpty)
                                      ? 'Enter the verification code'
                                      : null,
                              decoration: InputDecoration(
                                hintText: 'Enter verification code',
                                hintStyle: GoogleFonts.outfit(
                                  fontSize: 14,
                                  color: AppColors.textHint,
                                  letterSpacing: 0,
                                ),
                                prefixIcon: const Icon(
                                  AppIcons.pinOutlined,
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                                filled: true,
                                fillColor: AppColors.primary.withOpacity(0.06),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: AppValues.paddingMd,
                                  vertical: AppValues.paddingMd,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(AppValues.radiusMd),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(AppValues.radiusMd),
                                  borderSide:
                                      const BorderSide(color: AppColors.cardBorder),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(AppValues.radiusMd),
                                  borderSide: const BorderSide(
                                      color: AppColors.primary, width: 1.5),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(AppValues.radiusMd),
                                  borderSide: const BorderSide(
                                      color: AppColors.error, width: 1.5),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(AppValues.radiusMd),
                                  borderSide: const BorderSide(
                                      color: AppColors.error, width: 1.5),
                                ),
                              ),
                            ),
                            const SizedBox(height: AppValues.paddingLg),

                            // ── Timer ──
                            Text(
                              _canResend ? 'Code expired' : 'Resend code in',
                              style: GoogleFonts.outfit(
                                  fontSize: 13, color: AppColors.wsSubtext),
                            ),
                            if (!_canResend) ...[
                              Text(
                                _timerLabel,
                                style: GoogleFonts.outfit(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                            const SizedBox(height: 8),

                            // ── Resend button ──
                            GestureDetector(
                              onTap: (_canResend && !isResending)
                                  ? () => context.read<ProfileCubit>().changeEmail(
                                        newEmail: widget.newEmail,
                                      )
                                  : null,
                              child: isResending
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColors.primary,
                                      ),
                                    )
                                  : Text(
                                      'Resend Code',
                                      style: GoogleFonts.outfit(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: _canResend
                                            ? AppColors.primary
                                            : AppColors.wsSubtext,
                                        decoration: _canResend
                                            ? TextDecoration.underline
                                            : TextDecoration.none,
                                        decorationColor: AppColors.primary,
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // ── Pinned button ──
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppValues.horizontalPadding,
                    0,
                    AppValues.horizontalPadding,
                    AppValues.paddingXl +
                        MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: PrimaryButton(
                    text: 'Verify & Update Email',
                    isLoading: isLoading,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<ProfileCubit>().confirmChangeEmail(
                              id: widget.id,
                              newEmail: widget.newEmail,
                              code: _codeCtrl.text.trim(),
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