// lib/features/workspace/presentation/widgets/workspace_dash_widgets/summary_card.dart

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_values.dart';

/// Summary card — بيانات حقيقية من الـ API فقط.
/// [totalTasks]        ← DashboardStats.totalTasks
/// [activeSpaces]      ← DashboardStats.activeSpaces
/// [productivityScore] ← DashboardStats.productivityScore
class SummaryCard extends StatelessWidget {
  final int totalTasks;
  final int activeSpaces;
  final double productivityScore;

  const SummaryCard({
    super.key,
    required this.totalTasks,
    required this.activeSpaces,
    required this.productivityScore,
  });

  @override
  Widget build(BuildContext context) {
    final score = productivityScore.clamp(0.0, 100.0);

    return Container(
      padding: const EdgeInsets.all(20),
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
          // ── Label ─────────────────────────────────
          Text(
            'WORKSPACE SUMMARY',
            style: GoogleFonts.outfit(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.primary.withOpacity(0.65),
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 10),

          // ── Title + Ring ──────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Overall Health',
                  style: GoogleFonts.outfit(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                    height: 1.1,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              _ScoreRing(score: score),
            ],
          ),
          const SizedBox(height: 18),

          // ── Stats row ─────────────────────────────
          Row(
            children: [
              _SummaryStat(
                value: '$totalTasks',
                label: 'Total Tasks',
                color: AppColors.primary,
              ),
              const SizedBox(width: 28),
              _SummaryStat(
                value: '$activeSpaces',
                label: 'Active Spaces',
                color: AppColors.success,
              ),
              const SizedBox(width: 28),
              _SummaryStat(
                value: '${score.toInt()}%',
                label: 'Productivity',
                color: AppColors.warning,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Score ring ────────────────────────────────────────────────
class _ScoreRing extends StatelessWidget {
  final double score;
  const _ScoreRing({required this.score});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70,
      height: 70,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.15),
                  blurRadius: 12,
                ),
              ],
            ),
          ),
          CustomPaint(
            size: const Size(70, 70),
            painter: _RingPainter(
              progress: score / 100,
              color: AppColors.primary,
            ),
          ),
          Text(
            '${score.toInt()}%',
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Stat item ─────────────────────────────────────────────────
class _SummaryStat extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _SummaryStat({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: color,
            height: 1,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 12,
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }
}

// ── Ring CustomPainter ────────────────────────────────────────
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
        ..color = color.withOpacity(0.15)
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