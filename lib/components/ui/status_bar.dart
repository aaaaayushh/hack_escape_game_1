import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:hack_game/hack_game.dart';

class StatusBar extends PositionComponent with HasGameReference<HackGame> {
  final double screenWidth;
  final double y;
  final Color timeColor;
  final bool centerTime;
  final bool showWifiBattery;

  StatusBar({
    required this.screenWidth,
    required this.y,
    required this.timeColor,
    this.centerTime = true,
    this.showWifiBattery = true,
  });

  @override
  Future<void> onLoad() async {
    final now = DateTime.now();
    final timeString =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    final position = centerTime ? Vector2(screenWidth / 2, y) : Vector2(80, y);

    final anchor = centerTime ? Anchor.center : Anchor.centerLeft;

    final timeDisplay = TextComponent(
      text: timeString,
      textRenderer: TextPaint(
        style: TextStyle(
          color: timeColor,
          fontSize: 40,
          fontWeight: FontWeight.w500,
        ),
      ),
      position: position,
      anchor: anchor,
    );
    add(timeDisplay);

    add(
      TimerComponent(
        period: 60.0,
        repeat: true,
        onTick: () {
          final now = DateTime.now();
          timeDisplay.text =
              '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
        },
      ),
    );

    if (showWifiBattery) {
      // Add connection icon (leftmost)
      add(
        SpriteComponent(
          sprite: Sprite(
            game.images.fromCache('phase0_icons/connection_white.png'),
          ),
          size: Vector2(36, 28),
          position: Vector2(screenWidth - 150, y),
          anchor: Anchor.center,
        ),
      );

      // Add WiFi icon (middle)
      add(
        SpriteComponent(
          sprite: Sprite(game.images.fromCache('phase0_icons/wifi_white.png')),
          size: Vector2(40, 32),
          position: Vector2(screenWidth - 90, y),
          anchor: Anchor.center,
        ),
      );

      // Add battery icon (rightmost)
      add(
        SpriteComponent(
          sprite: Sprite(
            game.images.fromCache('phase0_icons/battery_white.png'),
          ),
          size: Vector2(40, 24),
          position: Vector2(screenWidth - 35, y),
          anchor: Anchor.center,
        ),
      );
    }
  }
}
