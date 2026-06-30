class RouteNames {
  // ── App Startup ───────────────────────────────────────────
  static const String splash      = '/splash';
  static const String onboarding  = '/onboarding';
  static const String welcome     = '/welcome';

  // ── Auth ──────────────────────────────────────────────────
  static const String login         = '/login';
  static const String register      = '/register';
  static const String confirmEmail  = '/confirm-email';
  static const String checkEmail    = '/check-email';
  static const String enterCode     = '/enter-code';

  // ── Main ──────────────────────────────────────────────────
  static const String home = '/home';

  // ── Profile ───────────────────────────────────────────────
  static const String profile     = '/profile';
  static const String editProfile = '/profile/edit';

  // ── Settings ──────────────────────────────────────────────
  static const String settings         = '/profile/settings';
  static const String passwordSecurity = '/profile/settings/password-security';
  static const String changePassword   = '/profile/settings/change-password';
  static const String changeEmail      = '/profile/settings/change-email';
  static const String verifyEmail      = '/profile/settings/verify-email';
  static const String about            = '/profile/settings/about';
  static const String helpCenter    = '/profile/settings/help-center';
  static const String termsPrivacy  = '/profile/settings/terms-privacy';

  // ── Workspaces ────────────────────────────────────────────
  static const String workspaces         = '/workspaces';
  static const String workspaceDashboard = '/dashboard';
  static const String members            = '/members';
  static const String permissions        = '/permissions';

  // ── Spaces ────────────────────────────────────────────────
  static const String spaces      = '/spaces';
  static const String spaceDetail = spaces;

  // ── Other ─────────────────────────────────────────────────
  static const String chatBot       = '/chat-bot';
  static const String notifications = '/notifications';
}