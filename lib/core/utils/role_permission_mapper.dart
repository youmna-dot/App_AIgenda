// features/roles/utils/role_permissions_mapper.dart

import '../../../core/constants/app_permissions.dart';
import '../../features/roles/models/workspce_role.dart';

class RolePermissionsMapper {
  RolePermissionsMapper._();

  static List<String> map(WorkspaceRole role) {
    switch (role) {
      case WorkspaceRole.admin:
      // Admin = كل صلاحيات المحتوى — مش صلاحيات الـ workspace نفسه
        return AppPermissions.adminPermissions;

      case WorkspaceRole.editor:
      // Editor = يضيف ويعدل بس، مش يحذف
        return AppPermissions.editorPermissions;

      case WorkspaceRole.viewer:
      // Viewer = read only — الـ backend بيديه read access تلقائياً
        return [];

      case WorkspaceRole.custom:
      // Custom = المالك بيحدد manually في PermissionsScreen
        return [];
    }
  }
}