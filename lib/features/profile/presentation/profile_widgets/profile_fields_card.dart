// lib/features/profile/presentation/profile_widgets/profile_fields_card.dart

import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_icons.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/utils/date_utils.dart';
import '../../../../../core/utils/validators.dart';

class ProfileFieldsCard extends StatelessWidget {
  final TextEditingController firstNameCtrl;
  final TextEditingController lastNameCtrl;
  final TextEditingController jobTitleCtrl;
  final DateTime? selectedDate;
  final VoidCallback onDateTap;

  const ProfileFieldsCard({
    super.key,
    required this.firstNameCtrl,
    required this.lastNameCtrl,
    required this.jobTitleCtrl,
    required this.selectedDate,
    required this.onDateTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // ✅ نفس خلفية البروفايل
      decoration: BoxDecoration(
        color: AppColors.roleViewer.withOpacity(0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _EditFieldRow(
            icon: AppIcons.person,
            label: 'FIRST NAME',
            controller: firstNameCtrl,
            validator: AppValidators.validateUsername,
            isFirst: true,
          ),
          _divider(),
          _EditFieldRow(
            icon: AppIcons.person,
            label: 'LAST NAME',
            controller: lastNameCtrl,
            validator: AppValidators.validateUsername,
          ),
          _divider(),
          _EditFieldRow(
            icon: AppIcons.work,
            label: 'JOB TITLE',
            controller: jobTitleCtrl,
            hint: 'Senior Product Designer',
          ),
          _divider(),
          _EditDateRow(
            icon: AppIcons.calendar,
            label: 'DATE OF BIRTH',
            selectedDate: selectedDate,
            onTap: onDateTap,
            isLast: true,
          ),
        ],
      ),
    );
  }

  // ✅ نفس divider بتاع البروفايل
  Widget _divider() => Divider(
        height: 1,
        thickness: 1,
        color: Colors.white.withOpacity(0.6),
        indent: 56,
      );
}

// ✅ نفس _InfoRow بالظبط بس مع TextFormField
class _EditFieldRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final TextEditingController controller;
  final String? hint;
  final String? Function(String?)? validator;
  final bool isFirst;
  final bool isLast;

  const _EditFieldRow({
    required this.icon,
    required this.label,
    required this.controller,
    this.hint,
    this.validator,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      // ✅ نفس padding بتاع البروفايل
      padding: EdgeInsets.only(
        left: 18,
        right: 18,
        top: isFirst ? 18 : 14,
        bottom: isLast ? 18 : 14,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ نفس الأيقونة
          Icon(icon, color: AppColors.wsSubtext, size: 25),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ نفس label style
                Text(label, style: AppTextStyles.profileInfoLabel),
                const SizedBox(height: 3),
                // ✅ TextFormField بدل Text عشان الـ validation
                TextFormField(
                  controller: controller,
                  validator: validator,
                  // ✅ نفس value style
                  style: controller.text.isEmpty
                      ? AppTextStyles.profileInfoPlaceholder
                      : AppTextStyles.profileInfoValue,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    hintText: hint,
                    // ✅ نفس placeholder style
                    hintStyle: AppTextStyles.profileInfoPlaceholder,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ✅ نفس _InfoRow بس للـ Date (مش قابل للتعديل)
class _EditDateRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final DateTime? selectedDate;
  final bool isPlaceholder;
  final VoidCallback onTap;
  final bool isLast;

  const _EditDateRow({
    required this.icon,
    required this.label,
    this.selectedDate,
    this.isPlaceholder = false,
    required this.onTap,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final displayValue = selectedDate != null
        ? AppDateUtils.toDisplayFormat(selectedDate!)
        : 'Select date of birth';

    return Padding(
      // ✅ نفس padding
      padding: EdgeInsets.only(
        left: 18,
        right: 18,
        top: 14,
        bottom: isLast ? 18 : 14,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ نفس الأيقونة
          Icon(icon, color: AppColors.wsSubtext, size: 25),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ نفس label style
                Text(label, style: AppTextStyles.profileInfoLabel),
                const SizedBox(height: 3),
                // ✅ GestureDetector عشان تفتح الـ date picker
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    displayValue,
                    // ✅ نفس value/placeholder style
                    style: isPlaceholder
                        ? AppTextStyles.profileInfoPlaceholder
                        : AppTextStyles.profileInfoValue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}