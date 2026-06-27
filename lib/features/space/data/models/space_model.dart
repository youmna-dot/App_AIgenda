// lib/features/space/data/models/space_model.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/network/api_keys.dart';

class SpaceModel {
  final String id;
  final String name;
  final String? description;
  final String iconCode;
  final bool isPublic;
  final int? workspaceId;
  final int totalTasks;       // ← من الـ API
  final int completedTasks;   // ← من الـ API
  final int? colorIndex;      // ← للـ color persistence

  SpaceModel({
    required this.id,
    required this.name,
    this.description,
    required this.iconCode,
    required this.isPublic,
    this.workspaceId,
    this.totalTasks = 0,
    this.completedTasks = 0,
    this.colorIndex,
  });

  factory SpaceModel.fromJson(Map<String, dynamic> json) {
    return SpaceModel(
      id: json[ApiKeys.id].toString(),
      name: json[ApiKeys.name],
      description: json[ApiKeys.description],
      iconCode: json[ApiKeys.iconCode] ?? '',
      isPublic: json[ApiKeys.isPublic] ?? false,
      workspaceId: json[ApiKeys.workspaceId] as int?,
      totalTasks: json[ApiKeys.totalTasks] ?? 0,
      completedTasks: json[ApiKeys.completedTasks] ?? 0,
      colorIndex: json['colorIndex'] as int?,
    );
  }

  Color get color {
    const colors = [
      Color(0xFF6C63FF),
      Color(0xFF43B89C),
      Color(0xFFFF6584),
      Color(0xFFFFBE0B),
      Color(0xFF3A86FF),
      Color(0xFFFF006E),
      Color(0xFF8338EC),
      Color(0xFFFB5607),
    ];
    return colors[id.hashCode.abs() % colors.length];
  }

  String get display => AppIcons.displayFromCode(iconCode);

  double get completionRate =>
      totalTasks == 0 ? 0.0 : completedTasks / totalTasks;

  SpaceModel copyWith({int? workspaceId, int? colorIndex}) {
    return SpaceModel(
      id: id,
      name: name,
      description: description,
      iconCode: iconCode,
      isPublic: isPublic,
      workspaceId: workspaceId ?? this.workspaceId,
      totalTasks: totalTasks,
      completedTasks: completedTasks,
      colorIndex: colorIndex ?? this.colorIndex,
    );
  }
}