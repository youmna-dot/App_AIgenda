// lib/core/theme/app_icons.dart
// pure Dart — no imports needed

class AppIcon {
  final String code;    // بيتبعت للباك
  final String display; // emoji بيتعرض في الـ UI
  final String label;

  const AppIcon({
    required this.code,
    required this.display,
    required this.label,
  });
}

class AppIcons {
  AppIcons._();

  // ══════════════════════════════════════════
  // Workspace — E001 to E060
  // ══════════════════════════════════════════
  static const List<AppIcon> workspace = [
    AppIcon(code: 'E001', display: '💼', label: 'Briefcase'),
    AppIcon(code: 'E002', display: '🚀', label: 'Rocket'),
    AppIcon(code: 'E003', display: '🎯', label: 'Target'),
    AppIcon(code: 'E004', display: '📊', label: 'Chart'),
    AppIcon(code: 'E005', display: '💡', label: 'Idea'),
    AppIcon(code: 'E006', display: '🏆', label: 'Trophy'),
    AppIcon(code: 'E007', display: '⚡', label: 'Lightning'),
    AppIcon(code: 'E008', display: '🔥', label: 'Fire'),
    AppIcon(code: 'E009', display: '💎', label: 'Diamond'),
    AppIcon(code: 'E010', display: '🌟', label: 'Star'),
    AppIcon(code: 'E011', display: '💻', label: 'Laptop'),
    AppIcon(code: 'E012', display: '🤖', label: 'Robot'),
    AppIcon(code: 'E013', display: '⚙️', label: 'Gear'),
    AppIcon(code: 'E014', display: '🔧', label: 'Wrench'),
    AppIcon(code: 'E015', display: '📱', label: 'Phone'),
    AppIcon(code: 'E016', display: '🖥️', label: 'Monitor'),
    AppIcon(code: 'E017', display: '🔬', label: 'Microscope'),
    AppIcon(code: 'E018', display: '🧬', label: 'DNA'),
    AppIcon(code: 'E019', display: '🛸', label: 'UFO'),
    AppIcon(code: 'E020', display: '🌐', label: 'Globe'),
    AppIcon(code: 'E021', display: '🎨', label: 'Art'),
    AppIcon(code: 'E022', display: '✏️', label: 'Pencil'),
    AppIcon(code: 'E023', display: '📸', label: 'Camera'),
    AppIcon(code: 'E024', display: '🎬', label: 'Film'),
    AppIcon(code: 'E025', display: '🎵', label: 'Music'),
    AppIcon(code: 'E026', display: '🎭', label: 'Theater'),
    AppIcon(code: 'E027', display: '📝', label: 'Notes'),
    AppIcon(code: 'E028', display: '📚', label: 'Books'),
    AppIcon(code: 'E029', display: '🖊️', label: 'Pen'),
    AppIcon(code: 'E030', display: '🗺️', label: 'Map'),
    AppIcon(code: 'E031', display: '👥', label: 'Team'),
    AppIcon(code: 'E032', display: '🤝', label: 'Handshake'),
    AppIcon(code: 'E033', display: '👑', label: 'Crown'),
    AppIcon(code: 'E034', display: '🧠', label: 'Brain'),
    AppIcon(code: 'E035', display: '💪', label: 'Strong'),
    AppIcon(code: 'E036', display: '🙌', label: 'Celebrate'),
    AppIcon(code: 'E037', display: '❤️', label: 'Heart'),
    AppIcon(code: 'E038', display: '😊', label: 'Happy'),
    AppIcon(code: 'E039', display: '🌈', label: 'Rainbow'),
    AppIcon(code: 'E040', display: '🌸', label: 'Flower'),
    AppIcon(code: 'E041', display: '🏠', label: 'Home'),
    AppIcon(code: 'E042', display: '🌍', label: 'Earth'),
    AppIcon(code: 'E043', display: '🏔️', label: 'Mountain'),
    AppIcon(code: 'E044', display: '🌊', label: 'Wave'),
    AppIcon(code: 'E045', display: '🌿', label: 'Plant'),
    AppIcon(code: 'E046', display: '☀️', label: 'Sun'),
    AppIcon(code: 'E047', display: '🌙', label: 'Moon'),
    AppIcon(code: 'E048', display: '⭐', label: 'Star2'),
    AppIcon(code: 'E049', display: '🦋', label: 'Butterfly'),
    AppIcon(code: 'E050', display: '🐉', label: 'Dragon'),
    AppIcon(code: 'E051', display: '✅', label: 'Check'),
    AppIcon(code: 'E052', display: '📋', label: 'Clipboard'),
    AppIcon(code: 'E053', display: '🗓️', label: 'Calendar'),
    AppIcon(code: 'E054', display: '⏰', label: 'Clock'),
    AppIcon(code: 'E055', display: '📌', label: 'Pin'),
    AppIcon(code: 'E056', display: '🔑', label: 'Key'),
    AppIcon(code: 'E057', display: '🔒', label: 'Lock'),
    AppIcon(code: 'E058', display: '📦', label: 'Box'),
    AppIcon(code: 'E059', display: '🎁', label: 'Gift'),
    AppIcon(code: 'E060', display: '💰', label: 'Money'),
  ];

  // ══════════════════════════════════════════
  // Space — S001 to S020 (نفس الـ pattern بالظبط)
  // ══════════════════════════════════════════
  static const List<AppIcon> space = [
    AppIcon(code: 'S001', display: '🏠', label: 'Home'),
    AppIcon(code: 'S002', display: '⭐', label: 'Star'),
    AppIcon(code: 'S003', display: '💼', label: 'Work'),
    AppIcon(code: 'S004', display: '💻', label: 'Code'),
    AppIcon(code: 'S005', display: '🎨', label: 'Design'),
    AppIcon(code: 'S006', display: '📊', label: 'Chart'),
    AppIcon(code: 'S007', display: '📅', label: 'Calendar'),
    AppIcon(code: 'S008', display: '👥', label: 'People'),
    AppIcon(code: 'S009', display: '💬', label: 'Chat'),
    AppIcon(code: 'S010', display: '📄', label: 'Docs'),
    AppIcon(code: 'S011', display: '📁', label: 'Folder'),
    AppIcon(code: 'S012', display: '🚀', label: 'Rocket'),
    AppIcon(code: 'S013', display: '🎓', label: 'School'),
    AppIcon(code: 'S014', display: '💰', label: 'Finance'),
    AppIcon(code: 'S015', display: '🛍️', label: 'Shopping'),
    AppIcon(code: 'S016', display: '⚙️', label: 'Settings'),
    AppIcon(code: 'S017', display: '🐛', label: 'Bug'),
    AppIcon(code: 'S018', display: '🚩', label: 'Flag'),
    AppIcon(code: 'S019', display: '🌐', label: 'Globe'),
    AppIcon(code: 'S020', display: '❤️', label: 'Heart'),
  ];

  // ══════════════════════════════════════════
  // Lookup
  // ══════════════════════════════════════════
  static AppIcon? fromCode(String code) {
    try {
      return [...workspace, ...space].firstWhere((e) => e.code == code);
    } catch (_) {
      return null;
    }
  }

  /// fallback display لأي كود
  static String displayFromCode(String code) {
    // لو كود جديد (E001, S011...)
    final found = fromCode(code);
    if (found != null) return found.display;

    // لو الكود نفسه emoji (زي "📁")
    if (code.runes.length <= 3) return code;

    // legacy text codes ("bug", "design") → fallback
    return '📁';
  }
}