abstract class ProfileStatsState {}

class ProfileStatsInitial extends ProfileStatsState {}

class ProfileStatsLoading extends ProfileStatsState {}

class ProfileStatsLoaded extends ProfileStatsState {
  final int workspacesCount;
  final int totalTasks;

  ProfileStatsLoaded({
    required this.workspacesCount,
    required this.totalTasks,
  });
}

class ProfileStatsError extends ProfileStatsState {}