// lib/features/task/presentation/widgets/member_avatar.dart
//
// `MemberModel` has no avatar/photo URL field, so every "face" in the task
// screens (assignee list, "Assign to" picker, task card) is an initials
// avatar instead of a fetched photo like the mockups show. This is
// intentional — we don't fabricate image URLs that don't exist.

import 'package:flutter/material.dart';

class MemberAvatar extends StatelessWidget {
  final String label; // full name or email
  final double radius;
  final Color? background;

  const MemberAvatar({
    super.key,
    required this.label,
    this.radius = 16,
    this.background,
  });

  String get _initials {
    final trimmed = label.trim();
    if (trimmed.isEmpty) return '?';
    final parts = trimmed.split(RegExp(r'\s+'));
    final first = parts.first.isNotEmpty ? parts.first[0] : '';
    final second =
        parts.length > 1 && parts.last.isNotEmpty ? parts.last[0] : '';
    final initials = (first + second).toUpperCase();
    return initials.isEmpty ? '?' : initials;
  }

  Color _colorFromLabel() {
    const palette = [
      Color(0xFF6C63FF),
      Color(0xFF43B89C),
      Color(0xFFFF6584),
      Color(0xFFFFBE0B),
      Color(0xFF3A86FF),
      Color(0xFFFB5607),
    ];
    return palette[label.hashCode.abs() % palette.length];
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: background ?? _colorFromLabel(),
      child: Text(
        _initials,
        style: TextStyle(
          color: Colors.white,
          fontSize: radius * 0.7,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
