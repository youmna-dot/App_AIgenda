// lib/features/workspace/presentation/widgets/workspaces_screen_widgets/ws_color_service.dart
import 'package:ajenda_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WsColorService {
  WsColorService._();

  static const String _key = 'ws_color_';

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

  static Future<void> save(int workspaceId, Color color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('$_key$workspaceId', color.value);
  }

  static Future<Color> load(int workspaceId) async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getInt('$_key$workspaceId');
    return value != null ? Color(value) : palette[workspaceId % palette.length];
  }
}