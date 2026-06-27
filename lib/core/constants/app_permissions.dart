class AppPermissions {
  // Workspaces
  static const workspacesAdd = "workspaces:add";
  static const workspacesRead = "workspaces:read";
  static const workspacesUpdate = "workspaces:update";
  static const workspacesDelete = "workspaces:delete";

  // Spaces
  static const spacesAdd = "spaces:add";
  static const spacesRead = "spaces:read";
  static const spacesUpdate = "spaces:update";
  static const spacesDelete = "spaces:delete";

  // Tasks
  static const tasksAdd = "tasks_widgets:add";
  static const tasksRead = "tasks_widgets:read";
  static const tasksUpdate = "tasks_widgets:update";
  static const tasksDelete = "tasks_widgets:delete";

  // Notes
  static const notesAdd = "notes:add";
  static const notesRead = "notes:read";
  static const notesUpdate = "notes:update";
  static const notesDelete = "notes:delete";



  // ── Admin permissions ─────────────────────────
  // workspace-level (delete/update) حق الـ owner بس —
  // الـ admin member يتحكم في المحتوى بس مش الـ workspace نفسه
  static const adminPermissions = [
    spacesAdd,    spacesUpdate,    spacesDelete,
    tasksAdd,     tasksUpdate,     tasksDelete,
    notesAdd,     notesUpdate,     notesDelete,
  ];

  // ── Editor permissions ────────────────────────
  static const editorPermissions = [
    spacesAdd,
    tasksAdd,    tasksUpdate,
    notesAdd,    notesUpdate,
  ];

  // ── كل الـ permissions (للـ PermissionsScreen groups) ──
  static const all = [
    spacesAdd,    spacesRead,    spacesUpdate,    spacesDelete,
    tasksAdd,     tasksRead,     tasksUpdate,     tasksDelete,
    notesAdd,     notesRead,     notesUpdate,     notesDelete,
  ];

}