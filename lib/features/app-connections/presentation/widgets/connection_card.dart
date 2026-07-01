import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../data/models/app_connection_enums.dart';

/// كارت واحد في شاشة Connect Apps.
/// لو [provider] != null -> الكارت فعّال (فيه زرار Connect/Disconnect حقيقي).
/// لو [provider] == null -> الكارت "Coming Soon" بس (معطّل بصريًا، بدون أي action).
class ConnectionCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
  final String tagLabel; // مثلاً "Popular integration" أو "Video conferencing"

  final AppProviderType? provider; // null لو الكارت Coming Soon
  final bool isConnected;
  final bool isLoading; // وقت عملية connect/disconnect لـ provider ده بالتحديد
  final String? lastSyncedLabel; // مثلاً "Last synced: 2m ago"

  final VoidCallback? onConnect;
  final VoidCallback? onDisconnect;

  const ConnectionCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    required this.tagLabel,
    this.provider,
    this.isConnected = false,
    this.isLoading = false,
    this.lastSyncedLabel,
    this.onConnect,
    this.onDisconnect,
  });

  bool get _isComingSoon => provider == null;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _isComingSoon ? 0.55 : 1,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                const Spacer(),
                _StatusBadge(
                  isComingSoon: _isComingSoon,
                  isConnected: isConnected,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(title, style: AppTextStyles.titleMedium),
            const SizedBox(height: 4),
            Text(
              description,
              style: AppTextStyles.bodySmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: Text(
                    isConnected && lastSyncedLabel != null
                        ? lastSyncedLabel!
                        : tagLabel,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textMuted,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                _ActionButton(
                  isComingSoon: _isComingSoon,
                  isConnected: isConnected,
                  isLoading: isLoading,
                  onConnect: onConnect,
                  onDisconnect: onDisconnect,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool isComingSoon;
  final bool isConnected;

  const _StatusBadge({required this.isComingSoon, required this.isConnected});

  @override
  Widget build(BuildContext context) {
    if (isComingSoon) {
      return const _Badge(
        label: 'COMING SOON',
        background: AppColors.borderLight,
        textColor: AppColors.textMuted,
      );
    }
    if (isConnected) {
      return const _Badge(
        label: '• CONNECTED',
        background: AppColors.actionBgGreen,
        textColor: AppColors.success,
      );
    }
    return const _Badge(
      label: 'NOT CONNECTED',
      background: AppColors.surface,
      textColor: AppColors.textMuted,
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color background;
  final Color textColor;

  const _Badge({
    required this.label,
    required this.background,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppTextStyles.bodySmall.copyWith(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final bool isComingSoon;
  final bool isConnected;
  final bool isLoading;
  final VoidCallback? onConnect;
  final VoidCallback? onDisconnect;

  const _ActionButton({
    required this.isComingSoon,
    required this.isConnected,
    required this.isLoading,
    required this.onConnect,
    required this.onDisconnect,
  });

  @override
  Widget build(BuildContext context) {
    if (isComingSoon) {
      return OutlinedButton(
        onPressed: null,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.cardBorder),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          'Notify Me',
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
        ),
      );
    }

    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(
            strokeWidth: 2.2,
            color: AppColors.primary,
          ),
        ),
      );
    }

    if (isConnected) {
      return OutlinedButton(
        onPressed: onDisconnect,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.primary),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          'Disconnect',
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary),
        ),
      );
    }

    return ElevatedButton(
      onPressed: onConnect,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0,
      ),
      child: Text(
        'Connect',
        style: AppTextStyles.bodySmall.copyWith(color: AppColors.white),
      ),
    );
  }
}