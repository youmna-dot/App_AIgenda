// core/utils/permission_checker.dart

import '../constants/app_permissions.dart';

/// Helper بيحدد إيه اللي يقدر يعمله اليوزر الحالي
/// بناءً على isOwner + الـ permissions اللي جايين من الـ API.
class PermissionChecker {
  final bool isOwner;
  final List<String> permissions;

  const PermissionChecker({
    required this.isOwner,
    required this.permissions,
  });

  // ── Workspace ─────────────────────────────────────
  bool get canDeleteWorkspace => isOwner;
  bool get canEditWorkspace   => isOwner;
  bool get canManageMembers   => isOwner;

  // ── Spaces ────────────────────────────────────────
  bool get canCreateSpace =>
      isOwner || permissions.contains(AppPermissions.spacesAdd);
  bool get canEditSpace =>
      isOwner || permissions.contains(AppPermissions.spacesUpdate);
  bool get canDeleteSpace =>
      isOwner || permissions.contains(AppPermissions.spacesDelete);

  // ── Tasks ─────────────────────────────────────────
  bool get canCreateTask =>
      isOwner || permissions.contains(AppPermissions.tasksAdd);
  bool get canEditTask =>
      isOwner || permissions.contains(AppPermissions.tasksUpdate);
  bool get canDeleteTask =>
      isOwner || permissions.contains(AppPermissions.tasksDelete);

  // ── Notes ─────────────────────────────────────────
  bool get canCreateNote =>
      isOwner || permissions.contains(AppPermissions.notesAdd);
  bool get canEditNote =>
      isOwner || permissions.contains(AppPermissions.notesUpdate);
  bool get canDeleteNote =>
      isOwner || permissions.contains(AppPermissions.notesDelete);

  bool get isViewer => !isOwner && permissions.isEmpty;
}