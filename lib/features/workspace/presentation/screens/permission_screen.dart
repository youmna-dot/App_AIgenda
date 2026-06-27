// presentation/screens/permission_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_values.dart';
import '../../logic/permission_cubit/permission_cubit.dart';
import '../../logic/permission_cubit/permission_state.dart';
import '../widgets/permission_screen_widgets/permission_header.dart';
import '../widgets/permission_screen_widgets/permissions_body.dart';
import '../widgets/permission_screen_widgets/save_bar.dart';

class PermissionsScreen extends StatelessWidget {
  final int workspaceId;
  final String userId;

  /// يتبعت من MembersScreen عن طريق route extra.
  /// true بس لما يكون اليوزر الحالي هو مالك الـ workspace.
  final bool canUserModify;

  const PermissionsScreen({
    super.key,
    required this.workspaceId,
    required this.userId,
    required this.canUserModify,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocListener<PermissionsCubit, PermissionsState>(
        listener: (context, state) {
          if (state is PermissionsUpdateSuccess) {
            _showSnackBar(context, state.message, AppColors.success);
            context.pop();
          }
          if (state is PermissionsError) {
            _showSnackBar(context, state.message, AppColors.error,
                duration: const Duration(seconds: 4));
          }
        },
        child: SafeArea(
          child: Column(
            children: [
              const PermissionHeader(),

              // ── Body ──────────────────────────────────────────
              Expanded(
                child: BlocBuilder<PermissionsCubit, PermissionsState>(
                  buildWhen: (_, curr) =>
                  curr is PermissionsLoaded || curr is PermissionsInitial,
                  builder: (context, state) {
                    if (state is PermissionsLoaded) {
                      return PermissionsBody(state: state);
                    }
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    );
                  },
                ),
              ),

              // ── Save Bar — pure widget, الكيوبيت بيتقرأ هنا بس ──
              BlocBuilder<PermissionsCubit, PermissionsState>(
                buildWhen: (_, curr) =>
                curr is PermissionsLoaded || curr is PermissionsInitial,
                builder: (context, state) {
                  final loaded =
                  state is PermissionsLoaded ? state : null;

                  return SaveBar(
                    isLoading: loaded?.isLoading ?? false,
                    canModify: loaded?.canUserModify ?? false,
                    onSave: (loaded?.canUserModify ?? false)
                        ? () => context
                        .read<PermissionsCubit>()
                        .updatePermissions(
                      workspaceId: workspaceId,
                      memberUserId: userId,
                    )
                        : null,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void _showSnackBar(
      BuildContext context,
      String message,
      Color color, {
        Duration duration = const Duration(seconds: 3),
      }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.poppins(fontSize: 13, color: AppColors.white),
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppValues.radiusSm),
        ),
        margin: const EdgeInsets.all(AppValues.paddingMd),
        duration: duration,
      ),
    );
  }
}