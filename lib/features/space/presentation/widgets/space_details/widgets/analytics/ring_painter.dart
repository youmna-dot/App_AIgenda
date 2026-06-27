// lib/features/workspace/presentation/widgets/space_details/widgets/analytics/ring_painter.dart

import 'dart:math' as math;
import 'package:flutter/material.dart';

class RingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  const RingPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    canvas.drawCircle(
      center, radius,
      Paint()
        ..color = color.withOpacity(0.1)
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress.clamp(0.0, 1.0),
      false,
      Paint()
        ..color = color
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(RingPainter old) =>
      old.progress != progress || old.color != color;
}