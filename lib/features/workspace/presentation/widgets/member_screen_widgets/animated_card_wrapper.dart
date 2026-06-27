// presentation/screens/member_screen_widgets/animated_card_wrapper.dart

import 'package:flutter/material.dart';

import '../../../../../core/constants/app_values.dart';

/// Wraps any [child] with a staggered fade + slide-up entrance animation.
/// Pass a [delay] to stagger cards in a list.
class AnimatedCardWrapper extends StatefulWidget {
  final Widget child;
  final Duration delay;

  const AnimatedCardWrapper({
    super.key,
    required this.child,
    required this.delay,
  });

  @override
  State<AnimatedCardWrapper> createState() => _AnimatedCardWrapperState();
}

class _AnimatedCardWrapperState extends State<AnimatedCardWrapper>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppValues.animNormal,
    );
    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}