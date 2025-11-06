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

    // --- START: Alignment Fix ---

    // 1. Define your icon size and the desired gap
    final iconSize = Vector2.all(40);
    const double gap = 12.0; // Space between icon and text

    // 2. Create the TextComponent first so we can measure its width
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
      anchor: Anchor.centerLeft, // Use centerLeft for easy horizontal layout
    );

    // 3. Calculate the total width of all content
    final double totalContentWidth = iconSize.x + gap + text.width;

    // 4. Find the starting X position to center the content group
    final double startX = (size.x - totalContentWidth) / 2;

    // 5. Create the icon using the calculated startX
    final icon = SpriteComponent(
      sprite: await Sprite.load('Infected.png'),
      size: iconSize,
      position: Vector2(startX, size.y / 2), // Position at startX
      anchor: Anchor.centerLeft, // Use centerLeft
    );
    add(icon);

    // 6. Position the text right after the icon and gap
    text.position = Vector2(
      startX + iconSize.x + gap, // Position after icon + gap
      size.y / 2,
    );
    add(text);

    // --- END: Alignment Fix ---

    // The flash logic works perfectly with the new components
    if (flash) {
      bool visible = true;
      add(
        TimerComponent(
          period: 0.6,
          repeat: true,
          onTick: () {
            visible = !visible;
            final opacity = visible ? 1.0 : 0.3;
            icon.opacity = opacity;
            text.textRenderer = TextPaint(
              style: text.textRenderer.style.copyWith(
                color: color.withOpacity(opacity),
              ),
            );
            // Note: Your original code used 0.25 opacity here
            fill.paint.color = color.withOpacity(opacity * 0.25);
          },
        ),
      );
    }
  }
}
