import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/material.dart';
import 'package:hack_game/hack_game.dart';

class RoundedRectangleComponent extends PositionComponent {
  final double borderRadius;
  final Paint paint;

  RoundedRectangleComponent({
    required super.position,
    required super.size,
    required super.children,
    required this.borderRadius,
    required this.paint,
  });

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    paint
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Offset.zero & size.toSize(),
        Radius.circular(borderRadius),
      ),
      paint,
    );
  }
}

class ColoredRoundedRectangleComponent extends PositionComponent {
  final double borderRadius;
  final Paint paint;

  ColoredRoundedRectangleComponent({
    required super.position,
    required super.size,
    required super.children,
    required this.borderRadius,
    required this.paint,
  });

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    paint.style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Offset.zero & size.toSize(),
        Radius.circular(borderRadius),
      ),
      paint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Offset.zero & size.toSize(),
        Radius.circular(borderRadius),
      ),
      paint,
    );
  }
}

class GlowingBox extends PositionComponent
    with HasPaint, HasGameReference<HackGame>, TapCallbacks {
  final Paint backgroundPaint;
  final Color fontColor;
  final String content;
  final String? icon;
  void Function()? tapDownFunction;

  GlowingBox({
    required Vector2 size,
    required Color backgroundColor,
    required Color glowColor,
    required this.fontColor,
    required this.content,
    required this.icon,
    super.position,
    this.tapDownFunction,
  }) : backgroundPaint = Paint()..color = glowColor {
    this.size = size;
    paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill
      ..strokeWidth = 0;
  }

  @override
  void onLoad() async {
    // assert(children.first is TextComponent);
    // var statusText = children.first as TextComponent;
    // statusText.position += size / 2 - statusText.size / 2;
    RowComponent row = RowComponent(
      size: size,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      gap: 16,
    );
    if (icon != null) {
      row.add(
        SpriteComponent(
          size: Vector2(48, 48),
          sprite: Sprite(game.images.fromCache(icon!)),
        ),
      );
    }
    row.add(
      TextComponent(
        text: content,
        textRenderer: TextPaint(
          style: TextStyle(color: fontColor, fontSize: 48),
        ),
      ),
    );
    add(row);
  }

  @override
  void render(Canvas canvas) {
    final rrect = RRect.fromRectAndRadius(
      size.toRect(),
      Radius.circular(8),
    ); // Draw background fill first
    canvas.drawRRect(
      rrect,
      backgroundPaint,
    ); // Then draw border or shape with paint (which GlowEffect modifies
    canvas.drawRRect(
      rrect,
      paint,
    ); // Then draw border or shape with paint (which GlowEffect modifies
  }

  @override
  void onTapDown(TapDownEvent event) {
    tapDownFunction?.call();
  }
}
