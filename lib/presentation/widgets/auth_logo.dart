import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/constants/auth_constants.dart';

/// Animated neon logo for the auth module
class AuthLogo extends StatefulWidget {
  final bool isDark;
  final double size;

  const AuthLogo({super.key, this.isDark = true, this.size = 80});

  @override
  State<AuthLogo> createState() => _AuthLogoState();
}

class _AuthLogoState extends State<AuthLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotateAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _rotateAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );

    _glowAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.5, curve: Curves.easeInOut),
      ),
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.05), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.05, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'auth_logo',
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: SizedBox(
              width: widget.size,
              height: widget.size,
              child: CustomPaint(
                painter: _LogoPainter(
                  rotation: _rotateAnimation.value,
                  glowIntensity: _glowAnimation.value,
                  isDark: widget.isDark,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _LogoPainter extends CustomPainter {
  final double rotation;
  final double glowIntensity;
  final bool isDark;

  _LogoPainter({
    required this.rotation,
    required this.glowIntensity,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2;

    if (isDark) {
      // Outer glow ring
      final outerGlowPaint = Paint()
        ..color = AuthColors.neonCyan.withOpacity(0.15 * glowIntensity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
      canvas.drawCircle(center, r, outerGlowPaint);

      // Background circle
      final bgPaint = Paint()
        ..shader = RadialGradient(
          colors: [
            AuthColors.neonPurple.withOpacity(0.2),
            AuthColors.darkCard.withOpacity(0.9),
          ],
        ).createShader(Rect.fromCircle(center: center, radius: r));
      canvas.drawCircle(center, r, bgPaint);

      // Spinning arc
      final arcPaint = Paint()
        ..shader = const SweepGradient(
          colors: [AuthColors.neonCyan, AuthColors.neonPurple, Colors.transparent],
          stops: [0.0, 0.6, 1.0],
        ).createShader(Rect.fromCircle(center: center, radius: r))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round;

      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(rotation);
      canvas.translate(-center.dx, -center.dy);

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: r - 4),
        0,
        math.pi * 1.5,
        false,
        arcPaint,
      );
      canvas.restore();

      // Inner lock icon
      final iconPaint = Paint()
        ..color = AuthColors.neonCyan.withOpacity(0.9)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      _drawLockIcon(canvas, center, r * 0.4, iconPaint);

      // Glow on lock icon
      final glowPaint = Paint()
        ..color = AuthColors.neonCyan.withOpacity(0.3 * glowIntensity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
      _drawLockIcon(canvas, center, r * 0.4, glowPaint);
    } else {
      // Light mode version
      final bgPaint = Paint()
        ..shader = RadialGradient(
          colors: [
            AuthColors.lightPrimary.withOpacity(0.15),
            AuthColors.lightBackground,
          ],
        ).createShader(Rect.fromCircle(center: center, radius: r));
      canvas.drawCircle(center, r, bgPaint);

      // Border
      final borderPaint = Paint()
        ..color = AuthColors.lightPrimary.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawCircle(center, r - 1, borderPaint);

      // Lock icon
      final iconPaint = Paint()
        ..color = AuthColors.lightPrimary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;
      _drawLockIcon(canvas, center, r * 0.4, iconPaint);
    }
  }

  void _drawLockIcon(Canvas canvas, Offset center, double r, Paint paint) {
    final body = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center.translate(0, r * 0.2), width: r * 1.2, height: r),
      const Radius.circular(4),
    );
    canvas.drawRRect(body, paint);

    final archRect = Rect.fromCenter(
      center: center.translate(0, -r * 0.15),
      width: r * 0.8,
      height: r * 0.7,
    );
    canvas.drawArc(archRect, math.pi, math.pi, false, paint);

    // Keyhole
    canvas.drawCircle(
      center.translate(0, r * 0.2),
      r * 0.12,
      paint..style = PaintingStyle.fill,
    );
    paint.style = PaintingStyle.stroke;
  }

  @override
  bool shouldRepaint(covariant _LogoPainter oldDelegate) =>
      oldDelegate.rotation != rotation ||
      oldDelegate.glowIntensity != glowIntensity;
}

/// Theme toggle widget
class AuthThemeToggle extends StatelessWidget {
  final bool isDark;
  final VoidCallback onToggle;

  const AuthThemeToggle({
    super.key,
    required this.isDark,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: AnimatedContainer(
        duration: AuthDurations.normal,
        curve: Curves.easeInOut,
        width: 56,
        height: 28,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: isDark
              ? AuthColors.neonPurple.withOpacity(0.2)
              : AuthColors.lightPrimary.withOpacity(0.15),
          border: Border.all(
            color: isDark
                ? AuthColors.neonPurple.withOpacity(0.5)
                : AuthColors.lightPrimary.withOpacity(0.3),
          ),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: AuthDurations.normal,
              curve: Curves.easeInOut,
              alignment:
                  isDark ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.all(3),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark ? AuthColors.neonPurple : AuthColors.lightPrimary,
                  boxShadow: isDark
                      ? [
                          BoxShadow(
                            color: AuthColors.neonPurple.withOpacity(0.5),
                            blurRadius: 6,
                          )
                        ]
                      : null,
                ),
                child: Icon(
                  isDark ? Icons.nightlight_round : Icons.wb_sunny_rounded,
                  size: 12,
                  color: isDark ? AuthColors.darkBackground : Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
