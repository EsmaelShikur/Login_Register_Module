import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../constants/auth_constants.dart';

/// Particle data model
class _Particle {
  double x;
  double y;
  double vx;
  double vy;
  double radius;
  double opacity;
  Color color;
  double pulsePhase;

  _Particle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.radius,
    required this.opacity,
    required this.color,
    required this.pulsePhase,
  });
}

/// Animated particle background widget using CustomPainter
/// Optimized for 60fps with minimal allocations
class ParticleBackground extends StatefulWidget {
  final bool isDark;
  final int particleCount;

  const ParticleBackground({
    super.key,
    this.isDark = true,
    this.particleCount = 60,
  });

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_Particle> _particles;
  final _random = math.Random();
  Size _size = Size.zero;

  static const _particleColors = [
    AuthColors.neonCyan,
    AuthColors.neonPurple,
    AuthColors.neonPink,
    Color(0xFF4A6CF7),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    _particles = [];
  }

  void _initParticles(Size size) {
    if (_size == size && _particles.isNotEmpty) return;
    _size = size;

    _particles = List.generate(widget.particleCount, (_) => _createParticle());
  }

  _Particle _createParticle() {
    return _Particle(
      x: _random.nextDouble() * (_size.width > 0 ? _size.width : 400),
      y: _random.nextDouble() * (_size.height > 0 ? _size.height : 800),
      vx: (_random.nextDouble() - 0.5) * 0.4,
      vy: (_random.nextDouble() - 0.5) * 0.4,
      radius: _random.nextDouble() * 2 + 0.5,
      opacity: _random.nextDouble() * 0.6 + 0.1,
      color: _particleColors[_random.nextInt(_particleColors.length)],
      pulsePhase: _random.nextDouble() * math.pi * 2,
    );
  }

  void _updateParticles() {
    if (_size == Size.zero) return;

    for (final p in _particles) {
      p.x += p.vx;
      p.y += p.vy;

      // Wrap around edges
      if (p.x < -10) p.x = _size.width + 10;
      if (p.x > _size.width + 10) p.x = -10;
      if (p.y < -10) p.y = _size.height + 10;
      if (p.y > _size.height + 10) p.y = -10;

      // Pulse opacity
      p.pulsePhase += 0.02;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _initParticles(Size(constraints.maxWidth, constraints.maxHeight));

        return AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            _updateParticles();
            return CustomPaint(
              painter: _ParticlePainter(
                particles: _particles,
                time: _controller.value,
                isDark: widget.isDark,
              ),
              size: Size(constraints.maxWidth, constraints.maxHeight),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double time;
  final bool isDark;

  _ParticlePainter({
    required this.particles,
    required this.time,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw gradient background
    final bgRect = Rect.fromLTWH(0, 0, size.width, size.height);

    if (isDark) {
      final bgPaint = Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF050A18),
            Color(0xFF0A1020),
            Color(0xFF070E1E),
          ],
        ).createShader(bgRect);
      canvas.drawRect(bgRect, bgPaint);

      // Add subtle radial gradient glow in center
      final radialPaint = Paint()
        ..shader = RadialGradient(
          center: Alignment.center,
          radius: 0.8,
          colors: [
            AuthColors.neonPurple.withOpacity(0.04),
            Colors.transparent,
          ],
        ).createShader(bgRect);
      canvas.drawRect(bgRect, radialPaint);
    } else {
      final bgPaint = Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFEEF2FF),
            Color(0xFFF5F7FF),
            Color(0xFFEFF3FF),
          ],
        ).createShader(bgRect);
      canvas.drawRect(bgRect, bgPaint);
    }

    // Draw connection lines between nearby particles
    final linePaint = Paint()
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < particles.length; i++) {
      for (int j = i + 1; j < particles.length; j++) {
        final dx = particles[i].x - particles[j].x;
        final dy = particles[i].y - particles[j].y;
        final dist = math.sqrt(dx * dx + dy * dy);

        if (dist < 80) {
          final alpha = (1 - dist / 80) * 0.15;
          linePaint.color = isDark
              ? AuthColors.neonCyan.withOpacity(alpha)
              : AuthColors.lightPrimary.withOpacity(alpha * 0.5);
          canvas.drawLine(
            Offset(particles[i].x, particles[i].y),
            Offset(particles[j].x, particles[j].y),
            linePaint,
          );
        }
      }
    }

    // Draw particles
    for (final p in particles) {
      final pulse = (math.sin(p.pulsePhase) + 1) / 2;
      final currentOpacity = p.opacity * (0.7 + pulse * 0.3);
      final currentRadius = p.radius * (0.9 + pulse * 0.2);

      // Glow effect
      if (isDark) {
        final glowPaint = Paint()
          ..color = p.color.withOpacity(currentOpacity * 0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
        canvas.drawCircle(Offset(p.x, p.y), currentRadius * 3, glowPaint);
      }

      // Core particle
      final corePaint = Paint()
        ..color = isDark
            ? p.color.withOpacity(currentOpacity)
            : p.color.withOpacity(currentOpacity * 0.5)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(p.x, p.y), currentRadius, corePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => true;
}
