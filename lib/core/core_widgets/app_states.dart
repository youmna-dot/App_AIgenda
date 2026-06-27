import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import 'custom_button.dart';

class AppLoadingState extends StatelessWidget {
  const AppLoadingState({super.key});

  @override
  Widget build(BuildContext context) => const Center(
    child: CircularProgressIndicator(
        color: AppColors.primary, strokeWidth: 2.5),
  );
}

class AppErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const AppErrorState({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64, height: 64,
            decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20)),
            child: const Icon(Icons.error_outline_rounded,
                color: AppColors.error, size: 30),
          ),
          const SizedBox(height: 16),
          Text('Something went wrong',
              style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark)),
          const SizedBox(height: 6),
          Text(message,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  fontSize: 12, color: AppColors.textMuted)),
          const SizedBox(height: 24),
          SizedBox(
            width: 140,
            child: AppButton(label: 'Try Again', onTap: onRetry),
          ),
        ],
      ),
    ),
  );
}

class AppEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  const AppEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 24, offset: const Offset(0, 8))],
            ),
            child: Icon(icon, color: Colors.white, size: 36),
          ),
          const SizedBox(height: 24),
          Text(title,
              style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                  letterSpacing: -0.3)),
          const SizedBox(height: 8),
          Text(subtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  fontSize: 13.5,
                  color: AppColors.textMuted,
                  height: 1.6)),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 28),
            SizedBox(
              width: 200,
              child: AppButton(
                label: actionLabel!,
                onTap: onAction,
                icon: Icons.add_rounded,
              ),
            ),
          ],
        ],
      ),
    ),
  );
}

class AppShimmerList extends StatefulWidget {
  final int count;
  final double itemHeight;

  const AppShimmerList({
    super.key,
    this.count = 4,
    this.itemHeight = 80,
  });

  @override
  State<AppShimmerList> createState() => _AppShimmerListState();
}

class _AppShimmerListState extends State<AppShimmerList>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat(reverse: true);
    _anim = Tween(begin: 0.3, end: 0.7)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: widget.count,
      itemBuilder: (_, i) => AnimatedBuilder(
        animation: _anim,
        builder: (_, __) => Container(
          height: widget.itemHeight,
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(_anim.value * 0.5),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}