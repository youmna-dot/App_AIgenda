// lib/features/space/presentation/utils/space_color_service.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpaceColorService {
  SpaceColorService._();

  static const String _key = 'space_color_';

  // Same palette used in create_space_sheet.dart
  static const List<Color> palette = [
    Color.fromARGB(255, 182, 74, 74),
    Color.fromARGB(255, 6, 106, 74),
    Color.fromARGB(255, 188, 21, 102),
    Color.fromARGB(255, 171, 113, 147),
    Color.fromARGB(255, 245, 11, 11),
    Color.fromARGB(255, 79, 2, 2),
    Color.fromARGB(255, 52, 164, 216),
    Color.fromARGB(255, 246, 218, 92),
    Color.fromARGB(255, 87, 173, 136),
    Color(0xFFD97706),
    Color.fromARGB(255, 124, 86, 190),
    Color.fromARGB(255, 17, 5, 150),
  ];

  static Future<void> save(String spaceId, int colorIndex) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('$_key$spaceId', colorIndex);
  }

  static Future<Color> load(String spaceId) async {
    final prefs = await SharedPreferences.getInstance();
    final colorIndex = prefs.getInt('$_key$spaceId');
    if (colorIndex != null && colorIndex >= 0 && colorIndex < palette.length) {
      return palette[colorIndex];
    }
    // Fallback: hash-based color assignment
    return palette[spaceId.hashCode.abs() % palette.length];
  }

  static Color getColorByIndex(int index) {
    if (index >= 0 && index < palette.length) {
      return palette[index];
    }
    return palette[0]; // Fallback to first color
  }
}

