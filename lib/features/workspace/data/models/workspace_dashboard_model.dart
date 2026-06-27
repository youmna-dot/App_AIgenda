import '../../../../core/network/api_keys.dart';

class DashboardStats {
  final int totalTasks;
  final double focusTimeHours;
  final int activeSpaces;
  final int productivityScore;

  DashboardStats({
    required this.totalTasks,
    required this.focusTimeHours,
    required this.activeSpaces,
    required this.productivityScore,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      totalTasks: json[ApiKeys.totalTasks] ?? 0,
      focusTimeHours: (json[ApiKeys.focusTimeHours] ?? 0).toDouble(),
      activeSpaces: json[ApiKeys.activeSpaces] ?? 0,
      productivityScore: json[ApiKeys.productivityScore] ?? 0,
    );
  }
}

class WorkspaceDashboardModel {
  final DashboardStats stats;
  final List<dynamic> weeklyFocusTimeDays;
  final List<dynamic> recentActivities;
  final List<dynamic> priorityTasks;
  final List<dynamic> spaces;

  WorkspaceDashboardModel({
    required this.stats,
    required this.weeklyFocusTimeDays,
    required this.recentActivities,
    required this.priorityTasks,
    required this.spaces,
  });

  factory WorkspaceDashboardModel.fromJson(Map<String, dynamic> json) {
    return WorkspaceDashboardModel(
      stats: DashboardStats.fromJson(json[ApiKeys.stats] ?? {}),
      weeklyFocusTimeDays:
          (json[ApiKeys.weeklyFocusTime]?[ApiKeys.days] as List?) ?? [],
      recentActivities: (json[ApiKeys.recentActivities] as List?) ?? [],
      priorityTasks: (json[ApiKeys.priorityTasks] as List?) ?? [],
      spaces: (json[ApiKeys.spaces] as List?) ?? [],
    );
  }
}
