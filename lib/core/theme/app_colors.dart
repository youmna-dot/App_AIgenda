import 'package:flutter/material.dart';

enum TaskPriority {
  none,     // ← أضيفيه (0)
  low,      // 1
  medium,   // 2
  high,     // 3
  critical; // 4

  static TaskPriority fromInt(int value) =>
      TaskPriority.values[value.clamp(0, TaskPriority.values.length - 1)];

  int toInt() => index;
}

class PriorityTheme {
  final Color color;
  final Color backgroundColor;
  final IconData icon;
  final String label;

  const PriorityTheme({
    required this.color,
    required this.backgroundColor,
    required this.icon,
    required this.label,
  });
}

class AppColors {
  // ── Palette for workspaces/spaces ──
  static const List<Color> palette = [
    Color(0xFF6C63FF), // Purple
    Color(0xFF43B89C), // Teal
    Color(0xFFFF6584), // Pink
    Color(0xFFFFBE0B), // Yellow
    Color(0xFF3A86FF), // Blue
    Color(0xFFFF006E), // Red
    Color(0xFF8338EC), // Violet
    Color(0xFFFB5607), // Orange
    Color(0xFF06FFA5), // Green
    Color(0xFFFFD23F), // Gold
  ];

  static Color fromId(String id) {
    final hash = id.hashCode.abs();
    return palette[hash % palette.length];
  }


  static const Map<TaskPriority, PriorityTheme> priorities = {
    TaskPriority.none: PriorityTheme(        // ← جديد
      color: Color(0xFF9E9E9E),
      backgroundColor: Color(0xFFF5F5F5),
      icon: Icons.remove,
      label: 'No Priority',
    ),
    TaskPriority.low: PriorityTheme(
      color: Color(0xFF22C55E),
      backgroundColor: Color(0xFFE8FFF0),
      icon: Icons.arrow_downward,
      label: 'Low',
    ),
    TaskPriority.medium: PriorityTheme(
      color: Color(0xFFF59E0B),
      backgroundColor: Color(0xFFFEF3CD),
      icon: Icons.remove,
      label: 'Medium',
    ),
    TaskPriority.high: PriorityTheme(
      color: Color(0xFFF97316),
      backgroundColor: Color(0xFFFFEDD5),
      icon: Icons.arrow_upward,
      label: 'High',
    ),
    TaskPriority.critical: PriorityTheme(
      color: Color(0xFFEF4444),
      backgroundColor: Color(0xFFFEECEC),
      icon: Icons.priority_high,
      label: 'Critical',
    ),
  };

  // ── Other colors (keep existing ones) ──
  static const Color white = Colors.white;
  static const Color black = Colors.black;

  static const Color surface = Color(0xFFF8F7FF);
  static const Color borderLight = Color(0xFFE8E4FF);
  static const Color accentRed = Color(0xFFEF4444);
  static const Color accentOrange = Color(0xFFF59E0B);
  static const Color accentGreen = Color(0xFF1D9E75);

  static const Color gradientBlue   = Color(0xFF4A90E2);
  static const Color gradientPurple = Color(0xFF6C4AB6);
  static const Color gradientLight  = Color(0xFF9D7BDB);

  static const Color primary = gradientPurple;

  static const Color background     = Color(0xFFF7F5FF);
  static const Color cardBackground = Color(0xFFFBFAFF);
  static const Color cardBorder     = Color(0xFFE6E1F2);

  static const Color textPrimary   = Color(0xFF1F1147);
  static const Color textSecondary = Color(0xFF5C4E8C);
  static const Color textMuted     = Color(0xFF9A8CC3);
  static const Color textDark      = Color(0xFF140B3D);
  static const Color textHint      = Color(0xFFB8A9D6);

  static const Color success = Color(0xFF22C55E);
  static const Color error   = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color grey    = Color(0xFFB0A4C8);

  static const Color instructionPink = Color(0xFFE11D8E);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [gradientBlue, gradientPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFF4F1FF),
      Color(0xFFF8FBFF),
      Color(0xFFF6F2FF),
    ],
  );

  static const Color wsHeading = Color(0xFF1A1035);
  static const Color wsSubtext = Color(0xFF6B6880);
  static const Color wsFieldBg = Color(0xFFF8F7FF);
  static const Color wsCancelBg = Color(0xFFF5F3FF);
  static const Color wsHandleBar = Color(0xFFE0DCF0);
  static const Color roleViewer = Color(0xFF6B7280);
  static const Color actionBgBlue   = Color(0xFFE6F4FF);
  static const Color actionBgEdit   = Color(0xFFE8F2FE);
  static const Color actionBgGreen  = Color(0xFFE8FFF0);
  static const Color actionBgRed    = Color(0xFFFEECEC);
  static const Color actionBgOrange = Color(0xFFFEF3CD);

  static const Color ownerGold       = Color(0xFFFFD700);
  static const Color ownerOrange     = Color(0xFFFF9500);
  static const Color ownerGoldShadow = Color(0xFFFFB300);

  static const Color membersBackground = Color(0xFFF4F2FA);

  static const Color teal    = Color(0xFF0D9488);
  static const Color skyBlue = Color(0xFF0EA5E9);
  static const Color emerald = Color(0xFF059669);

  static const Color primaryLight = Color(0xFFF0EBFF);

  static const Color dividerLight = Color(0xFFF5F3FF);
}
