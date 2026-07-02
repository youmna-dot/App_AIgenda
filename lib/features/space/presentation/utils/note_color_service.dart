// lib/features/Note/presentation/utils/note_color_service.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// الباك إند مش بيخزن لون النوت (زي حالة الـ Space بالظبط)،
/// فبنخزنه محليًا فى SharedPreferences، مربوط بـ noteId.
/// نفس فكرة SpaceColorService بس على مستوى النوتس.
class NoteColorService {
  NoteColorService._();

  static const String _key = 'note_color_';

  /// نفس الـ palette المعروضة فى Color Picker بتاع CreateNoteSheet.
  /// مصدر واحد للألوان عشان الكارد واللون المختار يفضلوا متطابقين دايمًا.
  static const List<Color> palette = [
    Color(0xFF6C4AB6),
    Color(0xFF1D9E75),
    Color(0xFF4A90E2),
    Color(0xFFE11D8E),
    Color(0xFFF59E0B),
    Color(0xFFEF4444),
  ];

  static Future<void> save(String noteId, int colorIndex) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('$_key$noteId', colorIndex);
  }

  static Future<Color> load(String noteId) async {
    final prefs = await SharedPreferences.getInstance();
    final colorIndex = prefs.getInt('$_key$noteId');
    if (colorIndex != null && colorIndex >= 0 && colorIndex < palette.length) {
      return palette[colorIndex];
    }
    // Fallback: لو مفيش لون متسجل (نوت قديمة قبل إضافة الميزة)
    // بنديله لون ثابت بناءً على الـ id عشان يفضل نفس اللون كل مرة.
    return palette[noteId.hashCode.abs() % palette.length];
  }

  static Color getColorByIndex(int index) {
    if (index >= 0 && index < palette.length) {
      return palette[index];
    }
    return palette[0];
  }
}