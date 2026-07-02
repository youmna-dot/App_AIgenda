// lib/features/space/presentation/utils/space_color_service.dart
import 'package:ajenda_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpaceColorService {
  SpaceColorService._();

  static const String _key = 'space_color_';

  // Same palette used in create_space_sheet.dart
  static const List<Color> palette = [
   Color.fromARGB(255, 65, 11, 101),
    Color.fromARGB(255, 6, 106, 74),
    Color.fromARGB(255, 188, 21, 102),
    Color.fromARGB(244, 209, 103, 37),
    Color.fromARGB(255, 245, 11, 11),
    Color.fromARGB(255, 142, 14, 14),
    Color.fromARGB(255, 52, 164, 216),
    Color.fromARGB(255, 201, 172, 40),
    AppColors.success,
    Color(0xFFD97706),
    Color.fromARGB(255, 93, 69, 134),
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

