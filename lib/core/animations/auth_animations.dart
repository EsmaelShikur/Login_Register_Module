import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../constants/auth_constants.dart';

/// Widget that shakes its child on animation trigger (for error states)
class ShakeAnimWidget extends StatelessWidget {
  final Widget child;
  final Animation<double> animation;

  const ShakeAnimWidget({
    super.key,
    required this.child,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final offset = math.sin(animation.value * math.pi * 4) * 8.0;
        return Transform.translate(
          offset: Offset(offset, 0),
          child: child,
        );
      },
      child: child,
    );
  }
}

/// Neon glow shadow container
class NeonGlowContainer extends StatelessWidget {
  final Widget child;
  final Color glowColor;
  final double glowRadius;
  final double glowOpacity;
  final BorderRadius? borderRadius;

  const NeonGlowContainer({
    super.key,
    required this.child,
    this.glowColor = AuthColors.neonCyan,
    this.glowRadius = 15,
    this.glowOpacity = 0.3,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: glowColor.withOpacity(glowOpacity),
            blurRadius: glowRadius,
            spreadRadius: 1,
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Animated glow border that pulses when active
class AnimatedNeonBorder extends StatefulWidget {
  final Widget child;
  final bool isActive;
  final bool isDark;

  const AnimatedNeonBorder({
    super.key,
    required this.child,
    this.isActive = false,
    this.isDark = true,
  });

  @override
  State<AnimatedNeonBorder> createState() => _AnimatedNeonBorderState();
}

class _AnimatedNeonBorderState extends State<AnimatedNeonBorder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.3, end: 0.8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isActive || !widget.isDark) return widget.child;

    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AuthRadius.md + 2),
            boxShadow: [
              BoxShadow(
                color: AuthColors.neonCyan
                    .withOpacity(_glowAnimation.value * 0.4),
                blurRadius: 12,
                spreadRadius: 1,
              ),
            ],
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

/// Fade + slide page route transition
class AuthPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  AuthPageRoute({required this.page})
      : super(
          transitionDuration: AuthDurations.slow,
          reverseTransitionDuration: AuthDurations.normal,
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final fadeAnim = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            );
            final slideAnim = Tween<Offset>(
              begin: const Offset(0.05, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            ));

            return FadeTransition(
              opacity: fadeAnim,
              child: SlideTransition(position: slideAnim, child: child),
            );
          },
        );
}

/// Loading overlay with pulsing animation
class AuthLoadingOverlay extends StatefulWidget {
  final bool isLoading;
  final Widget child;
  final bool isDark;

  const AuthLoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.isDark = true,
  });

  @override
  State<AuthLoadingOverlay> createState() => _AuthLoadingOverlayState();
}

class _AuthLoadingOverlayState extends State<AuthLoadingOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (widget.isLoading)
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, _) => Container(
              color:
                  (widget.isDark ? AuthColors.darkBackground : Colors.white)
                      .withOpacity(0.7 * _pulseAnimation.value),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 48,
                      height: 48,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          widget.isDark
                              ? AuthColors.neonCyan
                              : AuthColors.lightPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Authenticating...',
                      style: TextStyle(
                        color: widget.isDark
                            ? AuthColors.neonCyan
                            : AuthColors.lightPrimary,
                        fontSize: 14,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }
}
