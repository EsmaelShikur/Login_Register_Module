// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/auth_constants.dart';

/// Primary neon glow button with press animation and haptics
class NeonButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDark;
  final Color? color;
  final Color? glowColor;
  final Widget? leading;

  const NeonButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isDark = true,
    this.color,
    this.glowColor,
    this.leading,
  });

  @override
  State<NeonButton> createState() => _NeonButtonState();
}

class _NeonButtonState extends State<NeonButton> with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  Future<void> _handleTapDown(TapDownDetails _) async {
    await _scaleController.forward();
  }

  Future<void> _handleTapUp(TapUpDetails _) async {
    await _scaleController.reverse();
    HapticFeedback.lightImpact();
  }

  Future<void> _handleTapCancel() async {
    await _scaleController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = widget.color ??
        (widget.isDark ? AuthColors.neonCyan : AuthColors.lightPrimary);
    final glow = widget.glowColor ?? primaryColor;

    return AnimatedBuilder(
      animation: Listenable.merge([_scaleAnimation, _glowAnimation]),
      builder: (context, child) {
        return GestureDetector(
          onTapDown: widget.onPressed != null ? _handleTapDown : null,
          onTapUp: widget.onPressed != null ? _handleTapUp : null,
          onTapCancel: widget.onPressed != null ? _handleTapCancel : null,
          onTap: widget.onPressed,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: double.infinity,
              height: 52,
              decoration: BoxDecoration(
                gradient: widget.isDark
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          primaryColor,
                          Color.lerp(primaryColor, AuthColors.neonPurple, 0.3)!,
                        ],
                      )
                    : null,
                color: widget.isDark ? null : primaryColor,
                borderRadius: BorderRadius.circular(AuthRadius.md),
                boxShadow: widget.isDark
                    ? [
                        BoxShadow(
                          color: glow
                              .withOpacity(0.3 + _glowAnimation.value * 0.2),
                          blurRadius: 12 + _glowAnimation.value * 8,
                          spreadRadius: 1,
                        ),
                        BoxShadow(
                          color: glow.withOpacity(0.1),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
              ),
              child: Material(
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: widget.isLoading
                      ? Center(
                          child: SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(
                                widget.isDark
                                    ? AuthColors.darkBackground
                                    : Colors.white,
                              ),
                            ),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (widget.leading != null) ...[
                              widget.leading!,
                              const SizedBox(width: 10),
                            ],
                            Text(
                              widget.label,
                              style: TextStyle(
                                color: widget.isDark
                                    ? AuthColors.darkBackground
                                    : Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Social login button (Google, Apple)
class SocialAuthButton extends StatefulWidget {
  final String label;
  final Widget icon;
  final VoidCallback? onPressed;
  final bool isDark;

  const SocialAuthButton({
    super.key,
    required this.label,
    required this.icon,
    this.onPressed,
    this.isDark = true,
  });

  @override
  State<SocialAuthButton> createState() => _SocialAuthButtonState();
}

class _SocialAuthButtonState extends State<SocialAuthButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.96).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        HapticFeedback.selectionClick();
        widget.onPressed?.call();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            color: widget.isDark ? AuthColors.darkCard : Colors.white,
            borderRadius: BorderRadius.circular(AuthRadius.md),
            border: Border.all(
              color: widget.isDark
                  ? AuthColors.darkTextHint.withOpacity(0.2)
                  : const Color(0xFFDDE3EF),
              width: 1,
            ),
            boxShadow: widget.isDark
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 22, height: 22, child: widget.icon),
              const SizedBox(width: 10),
              Text(
                widget.label,
                style: TextStyle(
                  color: widget.isDark
                      ? AuthColors.darkTextPrimary
                      : AuthColors.lightTextPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
