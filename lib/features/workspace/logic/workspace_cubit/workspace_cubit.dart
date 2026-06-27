// features/workspace/logic/workspace_cubit/workspace_cubit.dart
//
// FIX 2: addMember بيقبل دلوقتي List<String> permissions
//         (WsCreateSheet كانت بتبعت member.permissions وكان بيـ ignore)
// FIX 3: editWorkspace اتشال منه isOwner param تماماً
//         (الـ guard بيبقى في الـ repository/backend — مش مسؤولية الكيوبيت)

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/models/filter_request.dart';
import '../../domain/workspace_repository.dart';
import 'workspace_state.dart';

class WorkspaceCubit extends Cubit<WorkspaceState> {
  final WorkspaceRepository repository;

  WorkspaceCubit(this.repository) : super(WorkspaceInitial());

  // ── GET ALL ───────────────────────────────────────────────
  Future<void> getWorkspaces({
    FilterRequest filter = const FilterRequest(),
  }) async {
    try {
      emit(WorkspaceLoading());
      final data = await repository.getWorkspaces(filter: filter);
      emit(WorkspacesSuccess(data));
    } catch (e) {
      emit(WorkspaceError(_handleError(e)));
    }
  }

  // ── GET BY ID ─────────────────────────────────────────────
  Future<void> getWorkspaceById(int id) async {
    try {
      emit(WorkspaceLoading());
      final workspace = await repository.getWorkspaceById(id);
      emit(WorkspaceDetailSuccess(workspace));
    } catch (e) {
      emit(WorkspaceError(_handleError(e)));
    }
  }

  // ── CREATE ────────────────────────────────────────────────
  Future<int?> createWorkspace({
    required String name,
    required String description,
    required String iconCode,
    required int visibility,
  }) async {
    try {
      emit(WorkspaceLoading());
      final id = await repository.createWorkspace(
        name: name,
        description: description,
        iconCode: iconCode,
        visibility: visibility,
      );
      await getWorkspaces();
      return id;
    } catch (e) {
      emit(WorkspaceError(_handleError(e)));
      return null;
    }
  }

  // ── EDIT ──────────────────────────────────────────────────
  // [FIX] isOwner اتحذف — الـ backend بيتحقق من الصلاحية
  Future<bool> editWorkspace({
    required int workspaceId,
    required String name,
    required String description,
    required String iconCode,
    required int visibility,
  }) async {
    try {
      emit(WorkspaceLoading());
      await repository.updateWorkspace(
        id: workspaceId,
        name: name,
        description: description,
        iconCode: iconCode,
        visibility: visibility,
      );
      await getWorkspaces();
      return true;
    } catch (e) {
      emit(WorkspaceError(_handleError(e)));
      return false;
    }
  }

  // ── DELETE ────────────────────────────────────────────────
  Future<bool> deleteWorkspace(int id) async {
    try {
      emit(WorkspaceLoading());
      await repository.deleteWorkspace(id);
      await getWorkspaces();
      return true;
    } catch (e) {
      emit(WorkspaceError(_handleError(e)));
      return false;
    }
  }

  // ── RESTORE ───────────────────────────────────────────────
  Future<void> restoreWorkspace(int id) async {
    try {
      emit(WorkspaceLoading());
      await repository.restoreWorkspace(id);
      emit(WorkspaceActionSuccess());
    } catch (e) {
      emit(WorkspaceError(_handleError(e)));
    }
  }

  // ── DELETED LIST ──────────────────────────────────────────
  Future<void> getDeletedWorkspaces() async {
    try {
      emit(WorkspaceLoading());
      final list = await repository.getDeletedWorkspaces();
      emit(DeletedWorkspacesSuccess(list));
    } catch (e) {
      emit(WorkspaceError(_handleError(e)));
    }
  }

  // ── DASHBOARD ─────────────────────────────────────────────
  Future<void> getDashboard(int id) async {
    try {
      emit(WorkspaceLoading());
      final dashboard = await repository.getDashboard(id);
      emit(WorkspaceDashboardSuccess(dashboard));
    } catch (e) {
      emit(WorkspaceError(_handleError(e)));
    }
  }

  // ── LEAVE ─────────────────────────────────────────────────
  Future<bool> leaveWorkspace(int workspaceId, String email) async {
    try {
      emit(WorkspaceLoading());
      await repository.removeMember(workspaceId, email);
      await getWorkspaces();
      return true;
    } catch (e) {
      emit(WorkspaceError(_handleError(e)));
      return false;
    }
  }


  String _handleError(dynamic error) => error.toString();
}