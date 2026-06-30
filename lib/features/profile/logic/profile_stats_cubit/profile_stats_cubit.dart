import 'package:ajenda_app/features/workspace/domain/workspace_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'profile_stats_state.dart';

class ProfileStatsCubit extends Cubit<ProfileStatsState> {
  final WorkspaceRepository workspaceRepository;

  ProfileStatsCubit(this.workspaceRepository) : super(ProfileStatsInitial());

  Future<void> loadStats() async {
    emit(ProfileStatsLoading());
    try {
      final response = await workspaceRepository.getWorkspaces();
      final workspaces = response.items;
      final totalTasks = workspaces.fold<int>(
        0,
        (sum, ws) => sum + ws.numberOfTasks,
      );
      emit(ProfileStatsLoaded(
        workspacesCount: workspaces.length,
        totalTasks: totalTasks,
      ));
    } catch (_) {
      emit(ProfileStatsError());
    }
  }
}