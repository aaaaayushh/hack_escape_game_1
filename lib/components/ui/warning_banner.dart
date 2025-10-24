import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class WarningBanner extends PositionComponent {
  final String message;
  final Color color;
  final bool flash;

  WarningBanner({
    required Vector2 position,
    required Vector2 size,
    required this.message,
    required this.color,
    this.flash = false,
  }) : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    final border = RectangleComponent(
      size: size,
      position: Vector2.zero(),
      paint: Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
    add(border);

    final fill = RectangleComponent(
      size: size,
      position: Vector2.zero(),
      paint: Paint()..color = color.withOpacity(0.125),
    );
    add(fill);

    final icon = TextComponent(
      text: '⚠',
      textRenderer: TextPaint(
        style: TextStyle(
          color: color,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
      position: Vector2(30, size.y / 2),
      anchor: Anchor.centerLeft,
    );
    add(icon);

    final text = TextComponent(
      text: message,
      textRenderer: TextPaint(
        style: TextStyle(
          color: color,
          fontSize: 28,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.5,
        ),
      ),
      position: Vector2(70, size.y / 2),
      anchor: Anchor.centerLeft,
    );
    add(text);

    if (flash) {
      bool visible = true;
      add(
        TimerComponent(
          period: 0.6,
          repeat: true,
          onTick: () {
            visible = !visible;
            final opacity = visible ? 1.0 : 0.3;
            icon.textRenderer = TextPaint(
              style: icon.textRenderer.style.copyWith(
                color: color.withOpacity(opacity),
              ),
            );
            text.textRenderer = TextPaint(
              style: text.textRenderer.style.copyWith(
                color: color.withOpacity(opacity),
              ),
            );
            fill.paint.color = color.withOpacity(opacity * 0.25);
          },
        ),
      );
    }
  }
}
