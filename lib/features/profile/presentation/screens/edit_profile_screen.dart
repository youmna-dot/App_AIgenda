// lib/features/profile/presentation/screens/edit_profile_screen.dart

import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_icons.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/utils/date_utils.dart';
import '../../../auth/presentation/widgets/auth_helpers.dart';
import '../../logic/profile_cubit/profile_cubit.dart';
import '../../logic/profile_cubit/profile_state.dart';
import '../profile_widgets/profile_avatar_section.dart';
import '../profile_widgets/profile_fields_card.dart';  // ✅ استيراد الكارد
import '../profile_widgets/profile_save_button.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey        = GlobalKey<FormState>();
  final _firstNameCtrl  = TextEditingController();
  final _lastNameCtrl   = TextEditingController();
  final _jobTitleCtrl   = TextEditingController();

  DateTime? _selectedDate;
  bool _controllersLoaded = false;

  @override
  void initState() {
    super.initState();
    final profile = context.read<ProfileCubit>().currentProfile;
    if (profile != null) {
      _fillControllers(profile);
    } else {
      context.read<ProfileCubit>().getProfile();
    }
  }

  void _fillControllers(dynamic profile) {
    if (_controllersLoaded) return;
    _firstNameCtrl.text = profile.firstName;
    _lastNameCtrl.text  = profile.secondName;
    _jobTitleCtrl.text  = profile.jobTitle ?? '';
    if (AppDateUtils.isValid(profile.dateOfBirth)) {
      _selectedDate = AppDateUtils.safeParse(profile.dateOfBirth);
    }
    _controllersLoaded = true;
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _jobTitleCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    DateTime tempDate = _selectedDate ?? DateTime(2000, 6, 15);

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.3),
      builder: (ctx) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: 350,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: Text(
                        'Cancel',
                        style: AppTextStyles.profileDiscardButton,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() => _selectedDate = tempDate);
                        Navigator.pop(ctx);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          'Done',
                          style: AppTextStyles.profileSaveButton,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: tempDate,
                  minimumDate: DateTime(1940, 1, 1),
                  maximumDate: DateTime(now.year - 5, 12, 31),
                  onDateTimeChanged: (d) => tempDate = d,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickAvatar() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (image != null && mounted) {
      context.read<ProfileCubit>().uploadAvatar(image.path);
    }
  }

  void _saveProfile() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null) {
      showAuthError(context, 'Please select your date of birth.');
      return;
    }
    context.read<ProfileCubit>().updateProfile(
      firstName:   _firstNameCtrl.text.trim(),
      secondName:  _lastNameCtrl.text.trim(),
      dateOfBirth: AppDateUtils.toApiFormat(_selectedDate!),
      jobTitle:    _jobTitleCtrl.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F2FA),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded) _fillControllers(state.profile);
          if (state is UpdateProfileSuccess) {
            showSuccessMessage(context, 'Profile updated successfully!');
            context.pop();
          }
          if (state is UpdateProfileFailure) {
            showAuthError(context, state.errMessage);
          }
          if (state is UploadAvatarFailure) {
            showAuthError(context, state.errMessage);
          }
        },
        builder: (context, state) {
          final isLoading         = state is UpdateProfileLoading;
          final isUploadingAvatar = state is UploadAvatarLoading;
          final profile           = context.read<ProfileCubit>().currentProfile;

          if (state is ProfileLoading && profile == null) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(AppColors.primary),
                strokeWidth: 2.5,
              ),
            );
          }

          return SafeArea(
            child: Column(
              children: [
                _EditProfileAppBar(onBack: () => context.pop()),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 32),
                        ProfileAvatarSection(
                          profile: profile,
                          isUploading: isUploadingAvatar,
                          onTap: isUploadingAvatar ? null : _pickAvatar,
                        ),
                        const SizedBox(height: 32),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Personal Information',
                            style: AppTextStyles.profileSectionTitle,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ProfileFieldsCard(
                          firstNameCtrl: _firstNameCtrl,
                          lastNameCtrl: _lastNameCtrl,
                          jobTitleCtrl: _jobTitleCtrl,
                          selectedDate: _selectedDate,
                          onDateTap: _pickDate,
                        ),
                        const SizedBox(height: 32),
                        ProfileSaveButton(
                          isLoading: isLoading,
                          onTap: _saveProfile,
                        ),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: () => context.pop(),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 32),
                            child: Text(
                              'Discard Changes',
                              style: AppTextStyles.profileDiscardButton,
                            ),
                          ),
                        ),
                      ],
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

class _EditProfileAppBar extends StatelessWidget {
  final VoidCallback onBack;

  const _EditProfileAppBar({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            child: Container(
              width: 40,
              height: 40,
              decoration:  BoxDecoration(
                color: AppColors.primary.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(AppIcons.back, color: AppColors.primary,fontWeight: FontWeight.w700, size: 20),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                'Edit Profile',
                style: AppTextStyles.profileScreenTitle,
              ),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }
}