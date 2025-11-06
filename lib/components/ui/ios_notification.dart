import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class IOSNotification extends PositionComponent {
  final String title;
  final String message;
  final String timeLabel;
  final Color accentColor;
  final String iconEmoji;
  final Color backgroundColor;
  final Color titleColor;
  final Color messageColor;

  IOSNotification({
    required Vector2 position,
    required Vector2 size,
    this.title = 'SECURITY ALERT',
    this.message = 'Tap the Power app to restore system access',
    this.timeLabel = 'now',
    this.accentColor = const Color(0xFFFF0000),
    this.iconEmoji = '⚠',
    this.backgroundColor = const Color(0xEE1C1C1E),
    this.titleColor = Colors.white,
    this.messageColor = const Color(0xFFAAAAAA),
  }) : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    final background = RectangleComponent(
      size: size,
      paint: Paint()..color = backgroundColor,
    );
    add(background);

    final iconCircle = CircleComponent(
      radius: 30,
      position: Vector2(60, size.y / 2),
      anchor: Anchor.center,
      paint: Paint()..color = accentColor,
    );
    add(iconCircle);

    add(
      TextComponent(
        text: iconEmoji,
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Colors.white,
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
        ),
        position: Vector2(60, size.y / 2),
        anchor: Anchor.center,
      ),
    );

    add(
      TextComponent(
        text: title,
        textRenderer: TextPaint(
          style: TextStyle(
            color: titleColor,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        position: Vector2(110, 25),
        anchor: Anchor.topLeft,
      ),
    );

    // Calculate available width for message text (accounting for icon, padding, and time label)
    final messageMaxWidth =
        size.x -
        130 -
        30; // 110 (icon area) + 20 (padding) and 30 (right padding)

    add(
      TextBoxComponent(
        text: message,
        textRenderer: TextPaint(
          style: TextStyle(color: messageColor, fontSize: 22),
        ),
        position: Vector2(110, 58),
        size: Vector2(messageMaxWidth, size.y - 68),
        align: Anchor.topLeft,
      ),
    );

    add(
      TextComponent(
        text: timeLabel,
        textRenderer: TextPaint(
          style: const TextStyle(color: Color(0xFF888888), fontSize: 20),
        ),
        position: Vector2(size.x - 20, 25),
        anchor: Anchor.topRight,
      ),
    );
  }

  @override
  void render(Canvas canvas) {
    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size.toSize(),
      const Radius.circular(20),
    );

    final paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    canvas.drawRRect(rrect, paint);

    final borderPaint = Paint()
      ..color = const Color(0x33FFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawRRect(rrect, borderPaint);

    super.render(canvas);
  }
}
