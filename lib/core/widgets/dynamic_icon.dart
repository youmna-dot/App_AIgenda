import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_icons.dart';

class DynamicIcon extends StatelessWidget {
  final String iconCode;
  final String? id;
  final double size;

  const DynamicIcon({
    super.key,
    required this.iconCode,
    this.id,
    this.size = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    final icon = AppIcons.fromCode(iconCode);

    if (icon != null) {
      if (icon.code.startsWith('E')) {
        // Emoji
        return Text(
          icon.display,
          style: TextStyle(fontSize: size),
        );
      } else {
        // Material icon
        final iconData = _getIconData(icon.display);
        return Icon(
          iconData,
          size: size,
          color: id != null ? AppColors.fromId(id!) : null,
        );
      }
    } else {
      // Unknown
      return Icon(
        Icons.help_outline,
        size: size,
        color: AppColors.grey,
      );
    }
  }

  IconData _getIconData(String name) {
    switch (name) {
      case 'home': return Icons.home_rounded;
      case 'star': return Icons.star_rounded;
      case 'work': return Icons.work_rounded;
      case 'code': return Icons.code_rounded;
      case 'palette': return Icons.palette_rounded;
      case 'bar_chart': return Icons.bar_chart_rounded;
      case 'calendar_today': return Icons.calendar_today_rounded;
      case 'people': return Icons.people_rounded;
      case 'chat_bubble': return Icons.chat_bubble_rounded;
      case 'description': return Icons.description_rounded;
      case 'folder': return Icons.folder_rounded;
      case 'rocket_launch': return Icons.rocket_launch_rounded;
      case 'school': return Icons.school_rounded;
      case 'attach_money': return Icons.attach_money_rounded;
      case 'shopping_bag': return Icons.shopping_bag_rounded;
      case 'settings': return Icons.settings_rounded;
      case 'bug_report': return Icons.bug_report_rounded;
      case 'flag': return Icons.flag_rounded;
      case 'language': return Icons.language_rounded;
      case 'favorite': return Icons.favorite_rounded;
      default: return Icons.help_outline;
    }
  }
}
