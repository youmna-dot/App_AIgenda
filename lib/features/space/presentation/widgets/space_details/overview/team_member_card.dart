// // lib/features/space/presentation/widgets/space_details/overview/team_member_card.dart
// //
// // ⚠️ SpaceTeamMember دلوقتي نموذج خفيف مؤقت للعرض بس.
// // TODO: استبدليه بالـ member model الحقيقي لما توصلي الشاشة دي بالـ
// // MembersCubit/WorkspaceCubit اللي عندك (زي MembersScreen).
// // لحد ما يتوصل، مررّي List<SpaceTeamMember> فاضية (zero fallback) —
// // مفيش mock data هنا.

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../../../../../../core/constants/app_colors.dart';
// import '../../../../../../core/constants/app_values.dart';

// class SpaceTeamMember {
//   final String name;
//   final String role;
//   final String? avatarUrl;
//   final bool isOwner;

//   const SpaceTeamMember({
//     required this.name,
//     required this.role,
//     this.avatarUrl,
//     this.isOwner = false,
//   });
// }

// class TeamMemberCard extends StatelessWidget {
//   final SpaceTeamMember member;
//   final Color accentColor;
//   final VoidCallback? onTap;

//   const TeamMemberCard({
//     super.key,
//     required this.member,
//     required this.accentColor,
//     this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
//         decoration: BoxDecoration(
//           color: AppColors.white,
//           borderRadius: BorderRadius.circular(AppValues.radiusLg + 4),
//           border: Border.all(color: AppColors.cardBorder),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               width: 56,
//               height: 56,
//               padding: const EdgeInsets.all(2),
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 border: member.isOwner
//                     ? Border.all(color: accentColor, width: 2)
//                     : null,
//               ),
//               child: ClipOval(
//                 child: member.avatarUrl != null && member.avatarUrl!.isNotEmpty
//                     ? Image.network(member.avatarUrl!, fit: BoxFit.cover)
//                     : Container(
//                         color: accentColor.withOpacity(0.12),
//                         child: Center(
//                           child: Text(
//                             member.name.isNotEmpty
//                                 ? member.name[0].toUpperCase()
//                                 : '?',
//                             style: GoogleFonts.poppins(
//                               fontSize: 20,
//                               fontWeight: FontWeight.w700,
//                               color: accentColor,
//                             ),
//                           ),
//                         ),
//                       ),
//               ),
//             ),
//             const SizedBox(height: 10),
//             Text(
//               member.name,
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//               style: GoogleFonts.poppins(
//                 fontSize: 12.5,
//                 fontWeight: FontWeight.w700,
//                 color: AppColors.textDark,
//               ),
//             ),
//             Text(
//               member.role,
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//               style: GoogleFonts.poppins(
//                 fontSize: 10.5,
//                 color: AppColors.textMuted,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class InviteMemberCard extends StatelessWidget {
//   final VoidCallback onTap;

//   const InviteMemberCard({super.key, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: CustomPaint(
//         painter: _DashedBorderPainter(
//           color: AppColors.textMuted.withOpacity(0.45),
//           radius: AppValues.radiusLg + 4,
//         ),
//         child: Container(
//           padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 width: 56,
//                 height: 56,
//                 decoration: const BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: AppColors.background,
//                 ),
//                 child: const Icon(Icons.add_rounded,
//                     color: AppColors.textMuted, size: 26),
//               ),
//               const SizedBox(height: 10),
//               Text(
//                 'Invite New',
//                 style: GoogleFonts.poppins(
//                   fontSize: 12.5,
//                   fontWeight: FontWeight.w600,
//                   color: AppColors.textMuted,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _DashedBorderPainter extends CustomPainter {
//   final Color color;
//   final double radius;

//   const _DashedBorderPainter({required this.color, required this.radius});

//   @override
//   void paint(Canvas canvas, Size size) {
//     final rrect =
//         RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(radius));
//     final path = Path()..addRRect(rrect);
//     final dashPath = Path();
//     const dashWidth = 5.0;
//     const dashSpace = 4.0;

//     for (final metric in path.computeMetrics()) {
//       double distance = 0;
//       while (distance < metric.length) {
//         dashPath.addPath(
//           metric.extractPath(distance, distance + dashWidth),
//           Offset.zero,
//         );
//         distance += dashWidth + dashSpace;
//       }
//     }

//     canvas.drawPath(
//       dashPath,
//       Paint()
//         ..color = color
//         ..style = PaintingStyle.stroke
//         ..strokeWidth = 1.4,
//     );
//   }

//   @override
//   bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) => false;
// }