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
import '../profile_widgets/profile_fields_card.dart';
import '../profile_widgets/profile_save_button.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _jobTitleCtrl = TextEditingController();

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
    _lastNameCtrl.text = profile.secondName;
    _jobTitleCtrl.text = profile.jobTitle ?? '';
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                            horizontal: 20, vertical: 8),
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
    final image = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (image != null && mounted) {
      context.read<ProfileCubit>().uploadAvatar(image.path);
    }
  }

  // ✅ هنا كان مكمن مشكلة الـ Save: لازم نتأكد إن الـ Form فعلاً بتلف
  // حوالين الـ TextFormFields الموجودة جوه ProfileFieldsCard، وإن
  // الـ validate() بترجع true لو الحقول مليانة صح.
  void _saveProfile() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    if (_selectedDate == null) {
      showAuthError(context, 'Please select your date of birth.');
      return;
    }

    context.read<ProfileCubit>().updateProfile(
          firstName: _firstNameCtrl.text.trim(),
          secondName: _lastNameCtrl.text.trim(),
          dateOfBirth: AppDateUtils.toApiFormat(_selectedDate!),
          jobTitle: _jobTitleCtrl.text.trim(),
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
          final isLoading = state is UpdateProfileLoading;
          final isUploadingAvatar = state is UploadAvatarLoading;
          final profile = context.read<ProfileCubit>().currentProfile;

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
                    child: Form(
                      key: _formKey,
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
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ─── App Bar ───────────────────────────────────────────────────
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
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                AppIcons.back,
                color: AppColors.primary,
                size: 20,
              ),
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





// // lib/features/profile/presentation/screens/edit_profile_screen.dart

// import 'dart:ui';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:image_picker/image_picker.dart';

// import '../../../../../core/constants/app_colors.dart';
// import '../../../../../core/constants/app_icons.dart';
// import '../../../../../core/constants/app_text_styles.dart';
// import '../../../../../core/utils/date_utils.dart';
// import '../../../auth/presentation/widgets/auth_helpers.dart';
// import '../../logic/profile_cubit/profile_cubit.dart';
// import '../../logic/profile_cubit/profile_state.dart';
// import '../profile_widgets/profile_avatar_section.dart';
// import '../profile_widgets/profile_fields_card.dart';  
// import '../profile_widgets/profile_save_button.dart';

// class EditProfileScreen extends StatefulWidget {
//   const EditProfileScreen({super.key});

//   @override
//   State<EditProfileScreen> createState() => _EditProfileScreenState();
// }

// class _EditProfileScreenState extends State<EditProfileScreen> {
//   final _formKey        = GlobalKey<FormState>();
//   final _firstNameCtrl  = TextEditingController();
//   final _lastNameCtrl   = TextEditingController();
//   final _jobTitleCtrl   = TextEditingController();

//   DateTime? _selectedDate;
//   bool _controllersLoaded = false;

//   @override
//   void initState() {
//     super.initState();
//     final profile = context.read<ProfileCubit>().currentProfile;
//     if (profile != null) {
//       _fillControllers(profile);
//     } else {
//       context.read<ProfileCubit>().getProfile();
//     }
//   }

//   void _fillControllers(dynamic profile) {
//     if (_controllersLoaded) return;
//     _firstNameCtrl.text = profile.firstName;
//     _lastNameCtrl.text  = profile.secondName;
//     _jobTitleCtrl.text  = profile.jobTitle ?? '';
//     if (AppDateUtils.isValid(profile.dateOfBirth)) {
//       _selectedDate = AppDateUtils.safeParse(profile.dateOfBirth);
//     }
//     _controllersLoaded = true;
//   }

//   @override
//   void dispose() {
//     _firstNameCtrl.dispose();
//     _lastNameCtrl.dispose();
//     _jobTitleCtrl.dispose();
//     super.dispose();
//   }

//   Future<void> _pickDate() async {
//     final now = DateTime.now();
//     DateTime tempDate = _selectedDate ?? DateTime(2000, 6, 15);

//     await showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       barrierColor: Colors.black.withOpacity(0.3),
//       builder: (ctx) => BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//         child: Container(
//           height: 350,
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//           ),
//           child: Column(
//             children: [
//               const SizedBox(height: 12),
//               Container(
//                 width: 40,
//                 height: 4,
//                 decoration: BoxDecoration(
//                   color: AppColors.primary.withOpacity(0.25),
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 20,
//                   vertical: 10,
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     TextButton(
//                       onPressed: () => Navigator.pop(ctx),
//                       child: Text(
//                         'Cancel',
//                         style: AppTextStyles.profileDiscardButton,
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         setState(() => _selectedDate = tempDate);
//                         Navigator.pop(ctx);
//                       },
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 20,
//                           vertical: 8,
//                         ),
//                         decoration: BoxDecoration(
//                           gradient: AppColors.primaryGradient,
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                         child: Text(
//                           'Done',
//                           style: AppTextStyles.profileSaveButton,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Expanded(
//                 child: CupertinoDatePicker(
//                   mode: CupertinoDatePickerMode.date,
//                   initialDateTime: tempDate,
//                   minimumDate: DateTime(1940, 1, 1),
//                   maximumDate: DateTime(now.year - 5, 12, 31),
//                   onDateTimeChanged: (d) => tempDate = d,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _pickAvatar() async {
//     final image = await ImagePicker().pickImage(
//       source: ImageSource.gallery,
//       imageQuality: 70,
//     );
//     if (image != null && mounted) {
//       context.read<ProfileCubit>().uploadAvatar(image.path);
//     }
//   }

//   void _saveProfile() {
//     if (!_formKey.currentState!.validate()) return;
//     if (_selectedDate == null) {
//       showAuthError(context, 'Please select your date of birth.');
//       return;
//     }
//     context.read<ProfileCubit>().updateProfile(
//       firstName:   _firstNameCtrl.text.trim(),
//       secondName:  _lastNameCtrl.text.trim(),
//       dateOfBirth: AppDateUtils.toApiFormat(_selectedDate!),
//       jobTitle:    _jobTitleCtrl.text.trim(),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF4F2FA),
//       body: BlocConsumer<ProfileCubit, ProfileState>(
//         listener: (context, state) {
//           if (state is ProfileLoaded) _fillControllers(state.profile);
//           if (state is UpdateProfileSuccess) {
//             showSuccessMessage(context, 'Profile updated successfully!');
//             context.pop();
//           }
//           if (state is UpdateProfileFailure) {
//             showAuthError(context, state.errMessage);
//           }
//           if (state is UploadAvatarFailure) {
//             showAuthError(context, state.errMessage);
//           }
//         },
//         builder: (context, state) {
//           final isLoading         = state is UpdateProfileLoading;
//           final isUploadingAvatar = state is UploadAvatarLoading;
//           final profile           = context.read<ProfileCubit>().currentProfile;

//           if (state is ProfileLoading && profile == null) {
//             return const Center(
//               child: CircularProgressIndicator(
//                 valueColor: AlwaysStoppedAnimation(AppColors.primary),
//                 strokeWidth: 2.5,
//               ),
//             );
//           }

//           return SafeArea(
//             child: Column(
//               children: [
//                 _EditProfileAppBar(onBack: () => context.pop()),
//                 Expanded(
//                   child: SingleChildScrollView(
//                     physics: const BouncingScrollPhysics(),
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     child: Column(
//                       children: [
//                         const SizedBox(height: 32),
//                         ProfileAvatarSection(
//                           profile: profile,
//                           isUploading: isUploadingAvatar,
//                           onTap: isUploadingAvatar ? null : _pickAvatar,
//                         ),
//                         const SizedBox(height: 32),
//                         Align(
//                           alignment: Alignment.centerLeft,
//                           child: Text(
//                             'Personal Information',
//                             style: AppTextStyles.profileSectionTitle,
//                           ),
//                         ),
//                         const SizedBox(height: 12),
//                         ProfileFieldsCard(
//                           firstNameCtrl: _firstNameCtrl,
//                           lastNameCtrl: _lastNameCtrl,
//                           jobTitleCtrl: _jobTitleCtrl,
//                           selectedDate: _selectedDate,
//                           onDateTap: _pickDate,
//                         ),
//                         const SizedBox(height: 32),
//                         ProfileSaveButton(
//                           isLoading: isLoading,
//                           onTap: _saveProfile,
//                         ),
//                         const SizedBox(height: 16),
//                         GestureDetector(
//                           onTap: () => context.pop(),
//                           child: Padding(
//                             padding: const EdgeInsets.only(bottom: 32),
//                             child: Text(
//                               'Discard Changes',
//                               style: AppTextStyles.profileDiscardButton,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// class _EditProfileAppBar extends StatelessWidget {
//   final VoidCallback onBack;

//   const _EditProfileAppBar({required this.onBack});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
//       child: Row(
//         children: [
//           GestureDetector(
//             onTap: onBack,
//             child: Container(
//               width: 40,
//               height: 40,
//               decoration:  BoxDecoration(
//                 color: AppColors.primary.withOpacity(0.2),
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(AppIcons.back, color: AppColors.primary,fontWeight: FontWeight.w700, size: 20),
//             ),
//           ),
//           Expanded(
//             child: Center(
//               child: Text(
//                 'Edit Profile',
//                 style: AppTextStyles.profileScreenTitle,
//               ),
//             ),
//           ),
//           const SizedBox(width: 40),
//         ],
//       ),
//     );
//   }
// }



// import 'dart:ui';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:image_picker/image_picker.dart';

// import '../../../../../core/constants/app_colors.dart';
// import '../../../../../core/constants/app_icons.dart';
// import '../../../../../core/constants/app_text_styles.dart';
// import '../../../../../core/constants/app_values.dart';
// import '../../../../../core/utils/date_utils.dart';
// import '../../../../../core/utils/validators.dart';
// import '../../../auth/presentation/widgets/auth_helpers.dart';
// import '../../logic/profile_cubit/profile_cubit.dart';
// import '../../logic/profile_cubit/profile_state.dart';
// import '../profile_widgets/profile_avatar.dart';

// class EditProfileScreen extends StatefulWidget {
//   const EditProfileScreen({super.key});

//   @override
//   State<EditProfileScreen> createState() => _EditProfileScreenState();
// }

// class _EditProfileScreenState extends State<EditProfileScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _firstNameCtrl = TextEditingController();
//   final _lastNameCtrl = TextEditingController();
//   final _jobTitleCtrl = TextEditingController();

//   DateTime? _selectedDate;
//   bool _controllersLoaded = false;

//   @override
//   void initState() {
//     super.initState();
//     final profile = context.read<ProfileCubit>().currentProfile;
//     if (profile != null) {
//       _fillControllers(profile);
//     } else {
//       context.read<ProfileCubit>().getProfile();
//     }
//   }

//   void _fillControllers(dynamic profile) {
//     if (_controllersLoaded) return;
//     _firstNameCtrl.text = profile.firstName;
//     _lastNameCtrl.text = profile.secondName;
//     _jobTitleCtrl.text = profile.jobTitle ?? '';
//     if (AppDateUtils.isValid(profile.dateOfBirth)) {
//       _selectedDate = AppDateUtils.safeParse(profile.dateOfBirth);
//     }
//     _controllersLoaded = true;
//   }

//   @override
//   void dispose() {
//     _firstNameCtrl.dispose();
//     _lastNameCtrl.dispose();
//     _jobTitleCtrl.dispose();
//     super.dispose();
//   }

//   Future<void> _pickDate() async {
//     final now = DateTime.now();
//     DateTime tempDate = _selectedDate ?? DateTime(2000, 6, 15);

//     await showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       barrierColor: Colors.black.withOpacity(0.3),
//       builder: (ctx) => BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//         child: Container(
//           height: 350,
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//           ),
//           child: Column(
//             children: [
//               const SizedBox(height: 12),
//               Container(
//                 width: 40,
//                 height: 4,
//                 decoration: BoxDecoration(
//                   color: AppColors.primary.withOpacity(0.25),
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     TextButton(
//                       onPressed: () => Navigator.pop(ctx),
//                       child: Text('Cancel', style: AppTextStyles.profileDiscardButton),
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           _selectedDate = tempDate;
//                         });
//                         Navigator.pop(ctx);
//                       },
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//                         decoration: BoxDecoration(
//                           gradient: AppColors.primaryGradient,
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                         child: Text('Done', style: AppTextStyles.profileSaveButton),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Expanded(
//                 child: CupertinoDatePicker(
//                   mode: CupertinoDatePickerMode.date,
//                   initialDateTime: tempDate,
//                   minimumDate: DateTime(1940, 1, 1),
//                   maximumDate: DateTime(now.year - 5, 12, 31),
//                   onDateTimeChanged: (d) => tempDate = d,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _pickAvatar() async {
//     final image = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 70);
//     if (image != null && mounted) {
//       context.read<ProfileCubit>().uploadAvatar(image.path);
//     }
//   }

//   void _saveProfile() {
//     if (!_formKey.currentState!.validate()) return;
//     if (_selectedDate == null) {
//       showAuthError(context, 'Please select your date of birth.');
//       return;
//     }
//     context.read<ProfileCubit>().updateProfile(
//       firstName: _firstNameCtrl.text.trim(),
//       secondName: _lastNameCtrl.text.trim(),
//       dateOfBirth: AppDateUtils.toApiFormat(_selectedDate!),
//       jobTitle: _jobTitleCtrl.text.trim(),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF4F2FA),
//       body: BlocConsumer<ProfileCubit, ProfileState>(
//         listener: (context, state) {
//           if (state is ProfileLoaded) _fillControllers(state.profile);
//           if (state is UpdateProfileSuccess) {
//             showSuccessMessage(context, 'Profile updated successfully!');
//             context.pop();
//           }
//           if (state is UpdateProfileFailure) showAuthError(context, state.errMessage);
//           if (state is UploadAvatarFailure) showAuthError(context, state.errMessage);
//         },
//         builder: (context, state) {
//           final isLoading = state is UpdateProfileLoading;
//           final isUploadingAvatar = state is UploadAvatarLoading;
//           final profile = context.read<ProfileCubit>().currentProfile;

//           if (state is ProfileLoading && profile == null) {
//             return const Center(
//               child: CircularProgressIndicator(
//                 valueColor: AlwaysStoppedAnimation(AppColors.primary),
//                 strokeWidth: 2.5,
//               ),
//             );
//           }

//           return SafeArea(
//             child: Column(
//               children: [
//                 _EditProfileAppBar(onBack: () => context.pop()),
//                 Expanded(
//                   child: SingleChildScrollView(
//                     physics: const BouncingScrollPhysics(),
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     child: Column(
//                       children: [
//                         const SizedBox(height: 32),
//                         _AvatarSection(
//                           profile: profile,
//                           isUploading: isUploadingAvatar,
//                           onTap: isUploadingAvatar ? null : _pickAvatar,
//                         ),
//                         const SizedBox(height: 32),
//                         Align(
//                           alignment: Alignment.centerLeft,
//                           child: Text('PERSONAL INFORMATION', style: AppTextStyles.profileEditSectionLabel),
//                         ),
//                         const SizedBox(height: 12),
//                         Form(
//                           key: _formKey,
//                           child: _FieldsCard(
//                             firstNameCtrl: _firstNameCtrl,
//                             lastNameCtrl: _lastNameCtrl,
//                             jobTitleCtrl: _jobTitleCtrl,
//                             selectedDate: _selectedDate,
//                             onDateTap: _pickDate,
//                           ),
//                         ),
//                         const SizedBox(height: 32),
//                         _SaveButton(isLoading: isLoading, onTap: _saveProfile),
//                         const SizedBox(height: 16),
//                         GestureDetector(
//                           onTap: () => context.pop(),
//                           child: Padding(
//                             padding: const EdgeInsets.only(bottom: 32),
//                             child: Text('Discard Changes', style: AppTextStyles.profileDiscardButton),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// // ─── App Bar ───────────────────────────────────────────────────
// class _EditProfileAppBar extends StatelessWidget {
//   final VoidCallback onBack;

//   const _EditProfileAppBar({required this.onBack});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
//       child: Row(
//         children: [
//           GestureDetector(
//             onTap: onBack,
//             child: Container(
//               width: 40,
//               height: 40,
//               decoration: const BoxDecoration(
//                 color: AppColors.primary,
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(AppIcons.back, color: Colors.white, size: 18),
//             ),
//           ),
//           Expanded(
//             child: Center(child: Text('Edit Profile', style: AppTextStyles.profileScreenTitle)),
//           ),
//           const SizedBox(width: 40),
//         ],
//       ),
//     );
//   }
// }

// // ─── Avatar Section ────────────────────────────────────────────
// class _AvatarSection extends StatelessWidget {
//   final dynamic profile;
//   final bool isUploading;
//   final VoidCallback? onTap;

//   const _AvatarSection({required this.profile, required this.isUploading, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Stack(
//           children: [
//             Container(
//               width: 100,
//               height: 100,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 gradient: AppColors.primaryGradient,
//                 border: Border.all(color: Colors.white, width: 3),
//                 boxShadow: [
//                   BoxShadow(
//                     color: AppColors.primary.withOpacity(0.25),
//                     blurRadius: 16,
//                     offset: const Offset(0, 6),
//                   ),
//                 ],
//               ),
//               child: ClipOval(
//                 child: isUploading
//                     ? Container(
//                         color: AppColors.primary.withOpacity(0.1),
//                         child: const Center(
//                           child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
//                         ),
//                       )
//                     : profile?.profileImage != null && profile!.profileImage!.isNotEmpty
//                         ? Image.network(
//                             profile!.profileImage!,
//                             fit: BoxFit.cover,
//                             errorBuilder: (_, __, ___) => _InitialsBox(initials: profile?.initials ?? 'U'),
//                           )
//                         : _InitialsBox(initials: profile?.initials ?? 'U'),
//               ),
//             ),
//             Positioned(
//               bottom: 0,
//               right: 0,
//               child: GestureDetector(
//                 onTap: onTap,
//                 child: Container(
//                   width: 32,
//                   height: 32,
//                   decoration: BoxDecoration(
//                     gradient: AppColors.appPurpleGradient,
//                     shape: BoxShape.circle,
//                     border: Border.all(color: Colors.white, width: 2),
//                     boxShadow: [
//                       BoxShadow(
//                         color: AppColors.appPurpleDark.withOpacity(0.25),
//                         blurRadius: 8,
//                         offset: const Offset(0, 4),
//                       ),
//                     ],
//                   ),
//                   child: const Icon(AppIcons.camera, color: Colors.white, size: 15),
//                 ),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 14),
//         Text('Change Photo', style: AppTextStyles.profileChangePhotoTitle),
//         const SizedBox(height: 4),
//         Text('Upload a new profile picture.', style: AppTextStyles.profileChangePhotoSubtitle),
//       ],
//     );
//   }
// }

// class _InitialsBox extends StatelessWidget {
//   final String initials;

//   const _InitialsBox({required this.initials});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: AppColors.primary.withOpacity(0.1),
//       child: Center(
//         child: Text(
//           initials,
//           style: AppTextStyles.profileName.copyWith(fontSize: 32, color: Colors.white),
//         ),
//       ),
//     );
//   }
// }

// // ─── Fields Card ───────────────────────────────────────────────
// class _FieldsCard extends StatelessWidget {
//   final TextEditingController firstNameCtrl;
//   final TextEditingController lastNameCtrl;
//   final TextEditingController jobTitleCtrl;
//   final DateTime? selectedDate;
//   final VoidCallback onDateTap;

//   const _FieldsCard({
//     required this.firstNameCtrl,
//     required this.lastNameCtrl,
//     required this.jobTitleCtrl,
//     required this.selectedDate,
//     required this.onDateTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: AppColors.roleViewer.withOpacity(0.10),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Column(
//         children: [
//           _FieldItem(icon: AppIcons.person, label: 'FIRST NAME', controller: firstNameCtrl, validator: AppValidators.validateUsername, isFirst: true),
//           _fieldDivider(),
//           _FieldItem(icon: AppIcons.person, label: 'LAST NAME', controller: lastNameCtrl, validator: AppValidators.validateUsername),
//           _fieldDivider(),
//           _FieldItem(icon: AppIcons.work, label: 'JOB TITLE', controller: jobTitleCtrl, hint: 'Senior Product Designer'),
//           _fieldDivider(),
//           _DateField(icon: AppIcons.calendar, label: 'DATE OF BIRTH', selectedDate: selectedDate, onTap: onDateTap, isLast: true),
//         ],
//       ),
//     );
//   }

//   Widget _fieldDivider() => Divider(
//         height: 1,
//         thickness: 1,
//         color: Colors.white.withOpacity(0.6),
//         indent: 56,
//       );
// }

// class _FieldItem extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final TextEditingController controller;
//   final String? hint;
//   final String? Function(String?)? validator;
//   final bool isFirst;
//   final bool isLast;

//   const _FieldItem({
//     required this.icon,
//     required this.label,
//     required this.controller,
//     this.hint,
//     this.validator,
//     this.isFirst = false,
//     this.isLast = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(left: 12, right: 12, top: isFirst ? 12 : 4, bottom: isLast ? 12 : 4),
//       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
//         child: Row(
//           children: [
//             Icon(icon, color: AppColors.wsSubtext, size: 20),
//             const SizedBox(width: 12),
//             Expanded(
//               child: TextFormField(
//                 controller: controller,
//                 validator: validator,
//                 style: AppTextStyles.profileFieldValue,
//                 decoration: InputDecoration(
//                   labelText: label,
//                   labelStyle: AppTextStyles.profileFieldLabel,
//                   hintText: hint,
//                   hintStyle: AppTextStyles.profileFieldHint,
//                   border: InputBorder.none,
//                   contentPadding: const EdgeInsets.symmetric(vertical: 12),
//                   floatingLabelBehavior: FloatingLabelBehavior.always,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _DateField extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final DateTime? selectedDate;
//   final VoidCallback onTap;
//   final bool isLast;

//   const _DateField({
//     required this.icon,
//     required this.label,
//     required this.selectedDate,
//     required this.onTap,
//     this.isLast = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final hasDate = selectedDate != null;
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: EdgeInsets.only(left: 12, right: 12, top: 4, bottom: isLast ? 12 : 4),
//         decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
//         child: Row(
//           children: [
//             Icon(icon, color: AppColors.wsSubtext, size: 20),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(label, style: AppTextStyles.profileFieldLabel),
//                   const SizedBox(height: 4),
//                   Text(
//                     hasDate ? AppDateUtils.toDisplayFormat(selectedDate!) : 'Select date of birth',
//                     style: hasDate ? AppTextStyles.profileFieldValue : AppTextStyles.profileFieldHint,
//                   ),
//                 ],
//               ),
//             ),
//             const Icon(Icons.arrow_drop_down_rounded, color: AppColors.wsSubtext),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ─── Save Button ───────────────────────────────────────────────
// class _SaveButton extends StatelessWidget {
//   final bool isLoading;
//   final VoidCallback onTap;

//   const _SaveButton({required this.isLoading, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: isLoading ? null : onTap,
//       child: Container(
//         width: double.infinity,
//         height: 52,
//         decoration: BoxDecoration(
//           gradient: isLoading
//               ? LinearGradient(colors: [
//                   AppColors.appPurpleLight.withOpacity(0.5),
//                   AppColors.appPurpleDark.withOpacity(0.5),
//                 ])
//               : AppColors.appPurpleGradient,
//           borderRadius: BorderRadius.circular(AppValues.pillRadius),
//           boxShadow: isLoading
//               ? []
//               : [
//                   BoxShadow(
//                     color: AppColors.appPurpleDark.withOpacity(0.30),
//                     blurRadius: 20,
//                     offset: const Offset(0, 8),
//                   ),
//                 ],
//         ),
//         child: Center(
//           child: isLoading
//               ? const SizedBox(
//                   width: 22,
//                   height: 22,
//                   child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
//                 )
//               : Text('Save Changes', style: AppTextStyles.profileSaveButton),
//         ),
//       ),
//     );
//   }
// }






