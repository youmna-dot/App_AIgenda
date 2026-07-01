// // features/workspace/presentation/widgets/workspaces_screen_widgets/ws_grid.dart

// import 'package:flutter/material.dart';

// import '../../../data/models/workspace_model.dart';
// import 'cards/ws_card.dart';

// /// Pure widget — بتستقبل data وcallbacks من WorkspacesScreen.
// /// مفيش context.read هنا خالص.
// class WsGrid extends StatelessWidget {
//   final List<WorkspaceModel> workspaces;
//   final Future<bool> Function(int id) onDelete;
//   final Future<bool> Function(int id, String email) onLeave;
//   final Future<bool> Function({
//   required int workspaceId,
//   required String name,
//   required String description,
//   required String iconCode,
//   required int visibility,
//   }) onEdit;

//   const WsGrid({
//     super.key,
//     required this.workspaces,
//     required this.onDelete,
//     required this.onLeave,
//     required this.onEdit,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GridView.builder(
//       padding: const EdgeInsets.all(16),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         crossAxisSpacing: 12,
//         mainAxisSpacing: 12,
//         childAspectRatio: 0.85,
//       ),
//       itemCount: workspaces.length,
//       itemBuilder: (_, i) => WsCard(
//         workspace: workspaces[i],
//         onDelete: onDelete,
//         onLeave: onLeave,
//         onEdit: onEdit,
//       ),
//     );
//   }
// }