// lib/features/Note/presentation/widgets/hand_draw_canvas.dart
//
// A finger-drawing canvas widget for HandDraw notes.
// Uses GestureDetector + CustomPainter.
// Exposes the captured strokes via onStrokesChanged callback.

import 'package:flutter/material.dart';

class HandDrawCanvas extends StatefulWidget {
  /// Height of the canvas area
  final double height;

  /// Color used for new strokes
  final Color strokeColor;

  /// Called whenever strokes change (new stroke added or canvas cleared)
  final void Function(List<List<Offset>> strokes)? onStrokesChanged;

  const HandDrawCanvas({
    super.key,
    this.height = 200,
    this.strokeColor = const Color(0xFF6C4AB6),
    this.onStrokesChanged,
  });

  @override
  State<HandDrawCanvas> createState() => _HandDrawCanvasState();
}

class _HandDrawCanvasState extends State<HandDrawCanvas> {
  // Each inner list = one stroke (finger down → move → up)
  final List<List<Offset>> _strokes = [];
  List<Offset>? _current;

  void _onPanStart(DragStartDetails d) {
    setState(() {
      _current = [d.localPosition];
      _strokes.add(_current!);
    });
  }

  void _onPanUpdate(DragUpdateDetails d) {
    setState(() => _current?.add(d.localPosition));
  }

  void _onPanEnd(DragEndDetails _) {
    _current = null;
    widget.onStrokesChanged?.call(List.from(_strokes));
  }

  void clear() {
    setState(() {
      _strokes.clear();
      _current = null;
    });
    widget.onStrokesChanged?.call([]);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: widget.height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFFAF9FF),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: widget.strokeColor.withOpacity(0.2),
            width: 1.5,
          ),
        ),
        child: Stack(
          children: [
            // Faint grid lines for visual guidance
            CustomPaint(
              painter: _GridPainter(),
              size: Size.infinite,
            ),

            // Drawing layer
            GestureDetector(
              onPanStart: _onPanStart,
              onPanUpdate: _onPanUpdate,
              onPanEnd: _onPanEnd,
              child: CustomPaint(
                painter: _StrokePainter(
                  strokes: _strokes,
                  color: widget.strokeColor,
                ),
                size: Size.infinite,
              ),
            ),

            // Hint text when empty
            if (_strokes.isEmpty)
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.draw_rounded,
                        size: 32,
                        color: widget.strokeColor.withOpacity(0.25)),
                    const SizedBox(height: 6),
                    Text(
                      'Draw here with your finger',
                      style: TextStyle(
                        fontSize: 12,
                        color: widget.strokeColor.withOpacity(0.4),
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Painter: renders all strokes ─────────────────────────────
class _StrokePainter extends CustomPainter {
  final List<List<Offset>> strokes;
  final Color color;

  _StrokePainter({required this.strokes, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    for (final stroke in strokes) {
      if (stroke.isEmpty) continue;
      if (stroke.length == 1) {
        // Single tap → draw a dot
        canvas.drawCircle(stroke.first, 1.5, paint..style = PaintingStyle.fill);
        paint.style = PaintingStyle.stroke;
        continue;
      }
      final path = Path()..moveTo(stroke.first.dx, stroke.first.dy);
      for (int i = 1; i < stroke.length; i++) {
        // Smooth with quadratic bezier through midpoints
        if (i < stroke.length - 1) {
          final mid = Offset(
            (stroke[i].dx + stroke[i + 1].dx) / 2,
            (stroke[i].dy + stroke[i + 1].dy) / 2,
          );
          path.quadraticBezierTo(
              stroke[i].dx, stroke[i].dy, mid.dx, mid.dy);
        } else {
          path.lineTo(stroke[i].dx, stroke[i].dy);
        }
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_StrokePainter old) =>
      old.strokes != strokes || old.color != color;
}

// ── Painter: faint grid ───────────────────────────────────────
class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const spacing = 24.0;
    final paint = Paint()
      ..color = const Color(0xFFE8E4FF).withOpacity(0.5)
      ..strokeWidth = 0.5;

    for (double x = spacing; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = spacing; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_GridPainter _) => false;
}