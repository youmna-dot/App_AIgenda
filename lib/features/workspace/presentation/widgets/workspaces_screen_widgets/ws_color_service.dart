// lib/features/workspace/presentation/widgets/workspaces_screen_widgets/ws_color_service.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WsColorService {
  WsColorService._();

  static const String _key = 'ws_color_';

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