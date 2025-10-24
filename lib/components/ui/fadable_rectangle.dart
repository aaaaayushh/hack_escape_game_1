import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class FadableRectangle extends PositionComponent {
  final Color color;
  final bool isFilled;
  final double strokeWidth;
  double _opacity = 1.0;

  FadableRectangle({
    required Vector2 position,
    required Vector2 size,
    required this.color,
    this.isFilled = true,
    this.strokeWidth = 1.0,
  }) : super(position: position, size: size);

  void resetOpacity() {
    _opacity = 1.0;
  }

  void fadeOut(double durationSeconds, {VoidCallback? onComplete}) {
    final int steps = (durationSeconds * 60).clamp(1, 6000).toInt();
    int current = 0;
    add(
      TimerComponent(
        period: 1 / 60,
        repeat: true,
        onTick: () {
          current++;
          _opacity = (1.0 - current / steps).clamp(0.0, 1.0);
          if (current >= steps) {
            _opacity = 0.0;
            removeFromParent();
            onComplete?.call();
          }
        },
      ),
    );
  }

  @override
  void render(Canvas canvas) {
    if (_opacity <= 0) return;
    final paint = Paint()
      ..color = color.withOpacity(color.opacity * _opacity)
      ..style = isFilled ? PaintingStyle.fill : PaintingStyle.stroke;
    if (!isFilled) {
      paint.strokeWidth = strokeWidth;
    }
    canvas.drawRect(size.toRect(), paint);
  }
}
