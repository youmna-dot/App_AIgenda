// features/workspace/logic/current_user_permissions_cubit/current_user_permissions_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_permissions.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/workspace_repository.dart';

/// State = List<String> — الـ permissions بتاعة اليوزر الحالي في workspace معين.
///
/// Owner  → بيتبعتله AppPermissions.adminPermissions مباشرة (بدون API call)
/// Member → بيجيب الـ permissions من getMemberPermissions
/// Fail   → بيرجع [] (viewer by default — fail safe)
class CurrentUserPermissionsCubit extends Cubit<List<String>> {
  final WorkspaceRepository repository;
  final SecureStorageService storage;

  CurrentUserPermissionsCubit({
    required this.repository,
    required this.storage,
  }) : super([]);

  Future<void> load(int workspaceId, {required bool isOwner}) async {
    // Owner — مش محتاجين API call
    if (isOwner) {
      emit(AppPermissions.adminPermissions);
      return;
    }

    try {
      final userId = await storage.getUserId();
      if (userId == null) {
        emit([]);
        return;
      }

      final permissions = await repository.getMemberPermissions(
        workspaceId,
        userId,
      );
      emit(permissions);
    } catch (_) {
      emit([]); // viewer by default لو حصل أي error
    }
  }
}