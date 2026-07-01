// // features/workspace/presentation/widgets/workspaces_screen_widgets/cards/ws_card.dart

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:go_router/go_router.dart';
// import 'package:google_fonts/google_fonts.dart';

// import '../../../../../../config/routes/route_names.dart';
// import '../../../../../../core/constants/app_colors.dart';
// import '../../../../../../core/constants/app_values.dart';
// import '../../../../../../core/storage/secure_storage_service.dart';
// import '../../../../../../core/theme/app_icons.dart' show AppIcons;
// import '../../../../../workspace/data/models/workspace_model.dart';
// import '../shared/ws_confirm_dialog.dart';
// import '../ws_color_service.dart';
// import '../sheets/ws_actions_sheet.dart';
// import '../sheets/ws_edit_sheet.dart';
// import 'ws_card_body.dart';

// /// WsCard — pure widget.
// /// كل الـ cubit calls بتتم من WorkspacesScreen عن طريق الـ callbacks.
// class WsCard extends StatefulWidget {
//   final WorkspaceModel workspace;

//   /// بيتنادى من الـ screen بعد ما الـ cubit يتحدث
//   final Future<bool> Function(int id) onDelete;
//   final Future<bool> Function(int id, String email) onLeave;
//   final Future<bool> Function({
//   required int workspaceId,
//   required String name,
//   required String description,
//   required String iconCode,
//   required int visibility,
//   }) onEdit;

//   const WsCard({
//     super.key,
//     required this.workspace,
//     required this.onDelete,
//     required this.onLeave,
//     required this.onEdit,
//   });

//   @override
//   State<WsCard> createState() => _WsCardState();
// }

// class _WsCardState extends State<WsCard> with SingleTickerProviderStateMixin {
//   late AnimationController _ctrl;
//   late Animation<double> _scale;
//   Color _color = AppColors.primary;

//   @override
//   void initState() {
//     super.initState();
//     _ctrl = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 120),
//     );
//     _scale = Tween(begin: 1.0, end: 0.96)
//         .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
//     _loadColor();
//   }

//   Future<void> _loadColor() async {
//     final color = await WsColorService.load(widget.workspace.id);
//     if (mounted) setState(() => _color = color);
//   }

//   @override
//   void dispose() {
//     _ctrl.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final emoji = AppIcons.displayFromCode(widget.workspace.iconCode);

//     return AnimatedBuilder(
//       animation: _scale,
//       builder: (_, child) => Transform.scale(scale: _scale.value, child: child),
//       child: GestureDetector(
//         onTapDown: (_) => _ctrl.forward(),
//         onTapUp: (_) {
//           _ctrl.reverse();
//           context.push(
//             RouteNames.workspaceDashboard,
//             extra: {
//               'workspaceId': widget.workspace.id,
//               'workspaceName': widget.workspace.name,
//               'workspaceDescription': widget.workspace.description,
//               'numberOfMembers': widget.workspace.numberOfMembers,
//               'isCurrentUserOwner': widget.workspace.isOwnedByCurrentUser,
//             },
//           );
//         },
//         onTapCancel: () => _ctrl.reverse(),
//         onLongPress: () {
//           HapticFeedback.mediumImpact();
//           _openActions(context);
//         },
//         child: WsCardBody(
//           workspace: widget.workspace,
//           color: _color,
//           emoji: emoji,
//           onMoreTap: () => _openActions(context),
//         ),
//       ),
//     );
//   }

//   void _openActions(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (_) => WsActionsSheet(
//         workspace: widget.workspace,
//         color: _color,
//         isOwner: widget.workspace.isOwnedByCurrentUser,
//         onEditTap: widget.workspace.isOwnedByCurrentUser
//             ? () => _openEdit(context)
//             : null,
//         onDeleteTap: widget.workspace.isOwnedByCurrentUser
//             ? () => _confirmDelete(context)
//             : null,
//         onLeaveTap: !widget.workspace.isOwnedByCurrentUser
//             ? () => _confirmLeave(context)
//             : null,
//       ),
//     );
//   }

//   void _openEdit(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       useSafeArea: true,
//       builder: (_) => WsEditSheet(
//         workspace: widget.workspace,
//         currentColor: _color,
//         onColorSaved: (c) {
//           if (mounted) setState(() => _color = c);
//         },
//         // الـ edit callback بيتنادى من الـ screen
//         onSave: (name, description, iconCode, visibility) =>
//             widget.onEdit(
//               workspaceId: widget.workspace.id,
//               name: name,
//               description: description,
//               iconCode: iconCode,
//               visibility: visibility,
//             ),
//       ),
//     );
//   }

//   void _confirmDelete(BuildContext context) {
//     final sm = ScaffoldMessenger.of(context);
//     final name = widget.workspace.name;
//     final id = widget.workspace.id;

//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (d) => WsConfirmDialog(
//         title: 'Delete Workspace?',
//         body: '"$name" and all its data will be permanently removed.',
//         confirmLabel: 'Delete',
//         confirmColor: AppColors.error,
//         onConfirm: () async {
//           Navigator.of(d).pop();
//           // ✅ بدون isOwner parameter — الـ screen بتتحقق قبل ما تعرض الزرار
//           final ok = await widget.onDelete(id);
//           if (!mounted) return;
//           sm
//             ..clearSnackBars()
//             ..showSnackBar(_snack(
//               ok ? '"$name" deleted.' : 'Failed to delete.',
//               ok ? AppColors.success : AppColors.error,
//             ));
//         },
//         onCancel: () => Navigator.of(d).pop(),
//       ),
//     );
//   }

//   void _confirmLeave(BuildContext context) async {
//     final email = await SecureStorageService().getEmail() ?? '';
//     if (!mounted) return;

//     final sm = ScaffoldMessenger.of(context);
//     final name = widget.workspace.name;
//     final id = widget.workspace.id;

//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (d) => WsConfirmDialog(
//         title: 'Leave Workspace?',
//         body: 'You will lose access to "$name".',
//         confirmLabel: 'Leave',
//         confirmColor: AppColors.warning,
//         onConfirm: () async {
//           Navigator.of(d).pop();
//           final ok = await widget.onLeave(id, email);
//           if (!mounted) return;
//           sm
//             ..clearSnackBars()
//             ..showSnackBar(_snack(
//               ok ? 'Left "$name".' : 'Failed to leave.',
//               ok ? AppColors.success : AppColors.error,
//             ));
//         },
//         onCancel: () => Navigator.of(d).pop(),
//       ),
//     );
//   }

//   SnackBar _snack(String msg, Color bg) => SnackBar(
//     content: Text(
//       msg,
//       style: GoogleFonts.poppins(fontSize: 13, color: AppColors.white),
//     ),
//     backgroundColor: bg,
//     behavior: SnackBarBehavior.floating,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(AppValues.radiusSm),
//     ),
//     margin: const EdgeInsets.all(AppValues.paddingMd),
//     duration: const Duration(seconds: 3),
//   );
// }