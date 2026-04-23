import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../constants/app_theme.dart';

class TimerRingWidget extends StatelessWidget {
  final double progress; // 0.0 .. 1.0
  final String centerText;
  final String subtitle;
  final double size;

  const TimerRingWidget({
    super.key,
    required this.progress,
    required this.centerText,
    required this.subtitle,
    this.size = 220,
  });

  Color _interpolateColor(double t) {
    // green → gold → red
    if (t < 0.5) {
      return Color.lerp(kGreen, kGold, t * 2)!;
    }
    return Color.lerp(kGold, kRed, (t - 0.5) * 2)!;
  }

  @override
  Widget build(BuildContext context) {
    final color = _interpolateColor(progress.clamp(0.0, 1.0));
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _RingPainter(
              progress: progress.clamp(0.0, 1.0),
              color: color,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                centerText,
                style: cairoStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  color: kTextPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: cairoStyle(fontSize: 13, color: kTextSecond),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color color;

  _RingPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 8.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - strokeWidth;

    final bgPaint = Paint()
      ..color = kSurface
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, bgPaint);

    final glowPaint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 6);

    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * math.pi * progress;
    final startAngle = -math.pi / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    if (progress > 0) {
      canvas.drawArc(rect, startAngle, sweepAngle, false, glowPaint);
      canvas.drawArc(rect, startAngle, sweepAngle, false, progressPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) =>
      old.progress != progress || old.color != color;
}
