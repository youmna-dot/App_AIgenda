// lib/features/home/presentation/widgets/home_ai_insight_card.dart
//
// "AI INSIGHT" focus card at the top of the home screen.
// Shows a circular progress ring + focus message + stats row.
//
// 🟡 focusScore / dueToday / highPriority → mock until home/summary API is ready

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_values.dart';

class HomeAiInsightCard extends StatelessWidget {
  /// 0–100, displayed as a percentage ring
  final int focusScore;
  final int dueToday;
  final int highPriority;
  final String insightMessage;
  final VoidCallback? onTap;

  const HomeAiInsightCard({
    super.key,
    this.focusScore = 82,
    this.dueToday = 3,
    this.highPriority = 1,
    this.insightMessage =
        '"Completing the UI audit first will clear 40% of your remaining weekly roadmap."',
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppValues.horizontalPadding),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(AppValues.radiusXl),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.12),
              width: 0.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Badge + Ring row ──────────────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.auto_awesome_rounded,
                                  color: AppColors.primary, size: 12),
                              const SizedBox(width: 4),
                              Text(
                                'AI INSIGHT',
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Focus on Project\nOrion today.',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark,
                            height: 1.25,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Circular progress ring
                  _FocusRing(score: focusScore),
                ],
              ),

              const SizedBox(height: 14),

              // ── Stats row ─────────────────────────────────
              Row(
                children: [
                  _InsightStat(
                    label: 'DUE TODAY',
                    value: '$dueToday Tasks',
                    valueColor: AppColors.textDark,
                  ),
                  const SizedBox(width: 10),
                  _InsightStat(
                    label: 'HIGH PRIORITY',
                    value: '$highPriority Task',
                    valueColor: AppColors.error,
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // ── Insight quote ─────────────────────────────
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.70),
                  borderRadius: BorderRadius.circular(AppValues.radiusLg),
                ),
                child: Text(
                  insightMessage,
                  style: GoogleFonts.poppins(
                    fontSize: 11.5,
                    color: AppColors.textSecondary,
                    height: 1.55,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Circular ring ─────────────────────────────────────────────
class _FocusRing extends StatelessWidget {
  final int score;
  const _FocusRing({required this.score});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 68,
      height: 68,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(68, 68),
            painter: _RingPainter(
              progress: score / 100,
              color: AppColors.primary,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$score%',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                  height: 1.0,
                ),
              ),
              Text(
                'focus',
                style: GoogleFonts.poppins(
                  fontSize: 8,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color color;
  const _RingPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = (size.width - 7) / 2;

    // Track
    canvas.drawCircle(
      Offset(cx, cy),
      r,
      Paint()
        ..color = color.withOpacity(0.12)
        ..strokeWidth = 6
        ..style = PaintingStyle.stroke,
    );

    // Progress arc
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      -math.pi / 2,
      2 * math.pi * progress.clamp(0.0, 1.0),
      false,
      Paint()
        ..color = color
        ..strokeWidth = 6
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress || old.color != color;
}

// ── Insight stat item ─────────────────────────────────────────
class _InsightStat extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _InsightStat({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.white.withOpacity(0.70),
          borderRadius: BorderRadius.circular(AppValues.radiusLg),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: AppColors.textMuted,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: valueColor,
                height: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}