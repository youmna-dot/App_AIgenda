// presentation/screens/member_screen_widgets/members_loading_view.dart

import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_values.dart';

class MembersLoadingView extends StatelessWidget {
  const MembersLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(
        AppValues.paddingLg,
        4,
        AppValues.paddingLg,
        AppValues.paddingLg,
      ),
      itemCount: 4,
      itemBuilder: (_, index) => _ShimmerCard(index: index),
    );
  }
}

// Shimmer Card 
class _ShimmerCard extends StatefulWidget {
  final int index;

  const _ShimmerCard({required this.index});

  @override
  State<_ShimmerCard> createState() => _ShimmerCardState();
}

class _ShimmerCardState extends State<_ShimmerCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppValues.radiusXl),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          children: [
            _ShimmerBox(
              width: AppValues.memberAvatarSize,
              height: AppValues.memberAvatarSize,
              radius: 16,
              opacity: _animation.value,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ShimmerBox(
                    width: double.infinity,
                    height: 13,
                    radius: AppValues.radiusXs,
                    opacity: _animation.value,
                  ),
                  const SizedBox(height: 8),
                  _ShimmerBox(
                    width: 160,
                    height: 11,
                    radius: AppValues.radiusXs,
                    opacity: _animation.value * 0.7,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Shimmer Box 
class _ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  final double opacity;

  const _ShimmerBox({
    required this.width,
    required this.height,
    required this.radius,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(opacity),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}