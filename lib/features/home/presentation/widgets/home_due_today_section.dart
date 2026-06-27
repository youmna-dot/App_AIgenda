// lib/features/home/presentation/widgets/home_due_today_section.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_values.dart';

class DueTodayItem {
  final String time;
  final String title;
  final String subtitle;
  final bool isHighPriority;

  const DueTodayItem({
    required this.time,
    required this.title,
    required this.subtitle,
    this.isHighPriority = false,
  });
}

class HomeDueTodaySection extends StatelessWidget {
  final List<DueTodayItem> items;
  final VoidCallback? onViewAll;

  const HomeDueTodaySection({
    super.key,
    required this.items,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Section header ──────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppValues.horizontalPadding),
          child: Row(
            children: [
              Text(
                'Due Today',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              const Spacer(),
              if (onViewAll != null)
                GestureDetector(
                  onTap: onViewAll,
                  child: Text(
                    'View all',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // ── Items ───────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppValues.horizontalPadding),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppValues.radiusXl),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.08),
                width: 0.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: List.generate(items.length, (i) {
                final item = items[i];
                final isLast = i == items.length - 1;
                return Column(
                  children: [
                    _DueTodayRow(item: item),
                    if (!isLast)
                      Divider(
                        height: 1,
                        color: AppColors.primary.withOpacity(0.06),
                        indent: 16,
                        endIndent: 16,
                      ),
                  ],
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}

class _DueTodayRow extends StatelessWidget {
  final DueTodayItem item;
  const _DueTodayRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Time column مع الخط الجانبي ──────────────
          Column(
            children: [
              // الدوت
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: item.isHighPriority
                      ? AppColors.error
                      : AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
              // الخط الرأسي — بيظهر بس لو مش آخر عنصر
              Container(
                width: 1.5,
                height: 36,
                color: item.isHighPriority
                    ? AppColors.error.withOpacity(0.18)
                    : AppColors.primary.withOpacity(0.18),
              ),
            ],
          ),
          const SizedBox(width: 12),

          // ── Content ───────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // الوقت
                Text(
                  item.time,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 3),
                // العنوان
                Text(
                  item.title,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 3),
                // الوصف
                Text(
                  item.subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: AppColors.textMuted,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // ── High badge ────────────────────────────────
          if (item.isHighPriority) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.10),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'High',
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.error,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}