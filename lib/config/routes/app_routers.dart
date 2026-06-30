import 'package:ajenda_app/core/network/api_keys.dart';
import 'package:ajenda_app/features/profile/logic/profile_cubit/profile_cubit.dart';
import 'package:ajenda_app/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:ajenda_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:ajenda_app/features/settings/presentation/screens/about_screen.dart';
import 'package:ajenda_app/features/settings/presentation/screens/change_email_screen.dart';
import 'package:ajenda_app/features/settings/presentation/screens/change_password_screen.dart';
import 'package:ajenda_app/features/settings/presentation/screens/help_center_screen.dart';
import 'package:ajenda_app/features/settings/presentation/screens/password_security_screen.dart';
import 'package:ajenda_app/features/settings/presentation/screens/settings_screen.dart';
import 'package:ajenda_app/features/settings/presentation/screens/terms_privacy_screen.dart';
import 'package:ajenda_app/features/settings/presentation/screens/verify_email_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/app_startup/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/app_startup/splash/presentation/screens/splash_screen.dart';
import '../../features/auth/logic/auth_cubit/auth_cubit.dart';
import '../../features/auth/presentation/screens/check_email_screen.dart';
import '../../features/auth/presentation/screens/confirm_email_screen.dart';
import '../../features/auth/presentation/screens/enter_code_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/space/data/models/space_model.dart';
import '../../features/space/logic/space_cubit/space_cubit.dart';
import '../../features/workspace/logic/permission_cubit/permission_cubit.dart';
import '../../features/workspace/logic/workspace_cubit/workspace_cubit.dart';
import '../../features/workspace/presentation/screens/member_screen.dart';
import '../../features/workspace/presentation/screens/permission_screen.dart';
import '../../features/space/presentation/screens/space_detail_screen.dart';
import '../../features/workspace/presentation/screens/workspace_dashboard_screen.dart';
import '../../features/workspace/presentation/screens/workspaces_screen.dart';
import '../dependency_injection.dart';
import 'route_names.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: RouteNames.splash,
  routes: [
    // ── App Startup ───────────────────────────────────────────
    GoRoute(
      path: RouteNames.splash,
      builder: (_, __) => const SplashScreen(),
    ),
    GoRoute(
      path: RouteNames.onboarding,
      builder: (_, __) => const OnboardingScreen(),
    ),

    // ── Auth ──────────────────────────────────────────────────
    GoRoute(
      path: RouteNames.login,
      builder: (context, _) => BlocProvider(
        create: (_) => getIt<AuthCubit>(),
        child: LoginScreen(onSwitchToSignUp: () => context.go(RouteNames.register)),
      ),
    ),
    GoRoute(
      path: RouteNames.register,
      builder: (context, _) => BlocProvider(
        create: (_) => getIt<AuthCubit>(),
        child: RegisterScreen(onSwitchToSignIn: () => context.go(RouteNames.login)),
      ),
    ),
    GoRoute(
      path: RouteNames.confirmEmail,
      builder: (_, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return BlocProvider(
          create: (_) => getIt<AuthCubit>(),
          child: ConfirmEmailScreen(
            userId: extra?[ApiKeys.userId],
            email: extra?[ApiKeys.email],
          ),
        );
      },
    ),
    GoRoute(
      path: RouteNames.checkEmail,
      builder: (_, __) => BlocProvider(
        create: (_) => getIt<AuthCubit>(),
        child: CheckEmailScreen(),
      ),
    ),
    GoRoute(
      path: RouteNames.enterCode,
      builder: (_, state) {
        final extra = state.extra as Map<String, String>?;
        return BlocProvider(
          create: (_) => getIt<AuthCubit>(),
          child: EnterCodeScreen(email: extra?['email'], code: extra?['code']),
        );
      },
    ),

    // ── Home ──────────────────────────────────────────────────
    GoRoute(
      path: RouteNames.home,
      name: 'home',
      builder: (_, __) => BlocProvider(
        create: (_) => getIt<WorkspaceCubit>(),
        child: const HomeScreen(),
      ),
    ),

    // ── Profile ───────────────────────────────────────────────
    GoRoute(
      path: RouteNames.profile,
      builder: (_, __) => BlocProvider(
        create: (_) => getIt<ProfileCubit>(),
        child: const ProfileScreen(),
      ),
    ),
    GoRoute(
      path: RouteNames.editProfile,
      builder: (_, __) => BlocProvider.value(
        value: getIt<ProfileCubit>(),
        child: const EditProfileScreen(),
      ),
    ),

    // ── Settings ──────────────────────────────────────────────
    GoRoute(
      path: RouteNames.settings,
      builder: (_, __) => BlocProvider.value(
        value: getIt<ProfileCubit>(),
        child: const SettingsScreen(),
      ),
    ),
    GoRoute(
      path: RouteNames.passwordSecurity,
      builder: (_, __) => BlocProvider.value(
        value: getIt<ProfileCubit>(),
        child: const PasswordSecurityScreen(),
      ),
    ),
    GoRoute(
      path: RouteNames.changePassword,
      builder: (_, __) => BlocProvider.value(
        value: getIt<ProfileCubit>(),
        child: const ChangePasswordScreen(),
      ),
    ),
    GoRoute(
      path: RouteNames.changeEmail,
      builder: (_, __) => BlocProvider.value(
        value: getIt<ProfileCubit>(),
        child: const ChangeEmailScreen(),
      ),
    ),
    GoRoute(
      path: RouteNames.verifyEmail,
      builder: (_, state) {
        final extra = state.extra as Map<String, dynamic>;
        return BlocProvider.value(
          value: getIt<ProfileCubit>(),
          child: VerifyEmailScreen(
            newEmail: extra['newEmail'] as String,
            id: extra['id'] as String,
          ),
        );
      },
    ),
    GoRoute(
      path: RouteNames.about,
      builder: (_, __) => const AboutScreen(),
    ),
    GoRoute(
      path: RouteNames.helpCenter, 
      builder: (_, __) => const HelpCenterScreen()
    ),
    GoRoute(
      path: RouteNames.termsPrivacy, 
      builder: (_, __) => const TermsPrivacyScreen()
    ),

    // ── Workspaces ────────────────────────────────────────────
    ...workspaceRoutes,
  ],
);

final workspaceRoutes = [
  GoRoute(
    path: RouteNames.workspaces,
    builder: (_, __) => const WorkspacesScreen(),
  ),
  GoRoute(
    path: RouteNames.workspaceDashboard,
    builder: (_, state) {
      final extra = state.extra as Map<String, dynamic>;
      return WorkspaceDashboardScreen(
        workspaceId: extra['workspaceId'] as int,
        workspaceName: extra['workspaceName'] as String,
        workspaceDescription: extra['workspaceDescription'] as String? ?? '',
        numberOfMembers: extra['numberOfMembers'] as int,
        isCurrentUserOwner: extra['isCurrentUserOwner'] as bool,
      );
    },
  ),
  GoRoute(
    path: RouteNames.members,
    builder: (_, state) {
      final extra = state.extra as Map<String, dynamic>;
      return MembersScreen(
        workspaceId: extra['workspaceId'] as int,
        workspaceName: extra['workspaceName'] as String,
        isCurrentUserOwner: extra['isCurrentUserOwner'] as bool,
      );
    },
  ),
  GoRoute(
    path: RouteNames.permissions,
    builder: (_, state) {
      final extra = state.extra as Map<String, dynamic>;
      return BlocProvider(
        create: (_) => getIt<PermissionsCubit>()
          ..init(
            List<String>.from(extra['permissions'] as List),
            canUserModify: extra['canUserModify'] as bool,
          ),
        child: PermissionsScreen(
          workspaceId: extra['workspaceId'] as int,
          userId: extra['userId'] as String,
          canUserModify: extra['canUserModify'] as bool,
        ),
      );
    },
  ),
  GoRoute(
    path: RouteNames.spaceDetail,
    builder: (_, state) {
      final extra = state.extra as Map<String, dynamic>;
      return SpaceDetailScreen(
        workspaceId: extra['workspaceId'] as int,
        space: extra['space'] as SpaceModel,
        isCurrentUserOwner: extra['isCurrentUserOwner'] as bool,
        userPermissions: List<String>.from(extra['userPermissions'] as List? ?? []),
      );
    },
  ),
];
