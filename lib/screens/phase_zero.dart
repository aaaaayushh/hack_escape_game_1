import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:hack_game/hack_game.dart';

class PhaseZero extends World with HasGameReference<HackGame>, TapCallbacks {
  PhaseZero();
  bool hasTransitioned = false;
  bool hasStarted = false;

  @override
  Future<void> onLoad() async {
    final screenWidth = 1920.0;
    final screenHeight = 1080.0;

    // White background
    final background = RectangleComponent(
      size: Vector2(screenWidth, screenHeight),
      position: Vector2(0, 0),
      paint: Paint()..color = Color(0xFFF5F5F5),
    );
    add(background);

    // Status bar at top
    _addStatusBar(screenWidth);

    // Hospital logo/wallpaper text (centered upper area)
    add(
      TextComponent(
        text: 'St. Aegis Medical',
        textRenderer: TextPaint(
          style: TextStyle(
            color: Color(0xFFB0BEC5),
            fontSize: 56,
            fontWeight: FontWeight.w300,
            letterSpacing: 3,
          ),
        ),
        position: Vector2(screenWidth / 2, 200),
        anchor: Anchor.center,
      ),
    );

    // App grid - 2 rows, 4 columns
    _addAppGrid(screenWidth, screenHeight);
  }

  void startSequence() {
    if (hasStarted) return;
    hasStarted = true;

    // Trigger hack transition after a few seconds
    add(
      TimerComponent(
        period: 5.0,
        repeat: false,
        onTick: () {
          if (!hasTransitioned) {
            _triggerHackTransition();
          }
        },
      ),
    );
  }

  void _triggerHackTransition() {
    hasTransitioned = true;
    game.cam.world = game.phaseOne;
    // Start the sequence for phase one
    game.phaseOne.startSequence();
  }

  void _addStatusBar(double screenWidth) {
    // Time display (08:41)
    add(
      TextComponent(
        text: '08:41',
        textRenderer: TextPaint(
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontSize: 40,
            fontWeight: FontWeight.w500,
          ),
        ),
        position: Vector2(screenWidth / 2, 45),
        anchor: Anchor.center,
      ),
    );

    // WiFi icon (right side - using text representation)
    add(
      TextComponent(
        text: '📶',
        textRenderer: TextPaint(
          style: TextStyle(color: Color(0xFF1A1A1A), fontSize: 36),
        ),
        position: Vector2(screenWidth - 150, 40),
        anchor: Anchor.center,
      ),
    );

    // Battery icon (far right - using text representation)
    add(
      TextComponent(
        text: '🔋',
        textRenderer: TextPaint(
          style: TextStyle(color: Color(0xFF1A1A1A), fontSize: 36),
        ),
        position: Vector2(screenWidth - 80, 40),
        anchor: Anchor.center,
      ),
    );
  }

  void _addAppGrid(double screenWidth, double screenHeight) {
    // App configuration
    final apps = [
      // Row 1
      {'name': 'Mail', 'icon': 'phase0_icons/mail.png'},
      {'name': 'Chat', 'icon': 'phase0_icons/chat.png'},
      {'name': 'Contacts', 'icon': 'phase0_icons/contacts.png'},
      {'name': 'EPD', 'icon': 'phase0_icons/epd.png'},
      // Row 2
      {'name': 'Docs', 'icon': 'phase0_icons/docs.png'},
      {'name': 'Power App', 'icon': 'phase0_icons/power.png'},
      {'name': 'Network\nDashboard', 'icon': 'phase0_icons/network.png'},
      {'name': 'Pager', 'icon': 'phase0_icons/pager.png'},
    ];

    final iconSize = 200.0;
    final iconSpacing = 100.0;

    // Calculate grid positioning (centered on screen)
    final gridWidth = (iconSize * 4) + (iconSpacing * 3);
    final gridHeight =
        (iconSize * 2) + (iconSpacing * 1) + 140; // Extra space for labels
    final startX = (screenWidth - gridWidth) / 2;
    final startY = (screenHeight - gridHeight) / 2 + 100; // Offset down a bit

    for (int i = 0; i < apps.length; i++) {
      final row = i ~/ 4;
      final col = i % 4;

      final x = startX + (col * (iconSize + iconSpacing));
      final y = startY + (row * (iconSize + iconSpacing + 140));

      // Create app icon container
      _addAppIcon(
        position: Vector2(x, y),
        size: iconSize,
        appName: apps[i]['name']!,
        iconAsset: apps[i]['icon']!,
      );
    }
  }

  void _addAppIcon({
    required Vector2 position,
    required double size,
    required String appName,
    required String iconAsset,
  }) {
    // Add shadow using a custom component
    add(
      _RoundedIconShadow(
        position: position + Vector2(0, 4),
        size: Vector2(size, size),
        borderRadius: 24,
      ),
    );

    // App icon background (rounded square)
    add(
      _RoundedIconContainer(
        position: position,
        size: Vector2(size, size),
        borderRadius: 24,
      ),
    );

    // Try to load icon image if available, otherwise show placeholder
    try {
      final iconSprite = SpriteComponent(
        sprite: Sprite(game.images.fromCache(iconAsset)),
        size: Vector2(size * 0.6, size * 0.6),
        position: position + Vector2(size * 0.2, size * 0.2),
      );
      add(iconSprite);
    } catch (e) {
      // Placeholder icon (blue/grey circle)
      final placeholder = CircleComponent(
        radius: size * 0.3,
        position: position + Vector2(size / 2, size / 2),
        paint: Paint()..color = Color(0xFF5B9BD5),
        anchor: Anchor.center,
      );
      add(placeholder);

      // Add a simple icon letter in the center
      final iconLetter = appName.split('\n').first[0];
      add(
        TextComponent(
          text: iconLetter,
          textRenderer: TextPaint(
            style: TextStyle(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
          position: position + Vector2(size / 2, size / 2),
          anchor: Anchor.center,
        ),
      );
    }

    // App name label below icon
    add(
      TextComponent(
        text: appName,
        textRenderer: TextPaint(
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontSize: 32,
            fontWeight: FontWeight.w500,
          ),
        ),
        position: position + Vector2(size / 2, size + 20),
        anchor: Anchor.topCenter,
      ),
    );

    // Make icon tappable (for future interaction)
    final tapArea = RectangleComponent(
      size: Vector2(size, size + 120),
      position: position,
      paint: Paint()..color = Colors.transparent,
    );
    add(tapArea);
  }
}

// Custom component for rounded icon container
class _RoundedIconContainer extends PositionComponent {
  final double borderRadius;

  _RoundedIconContainer({
    required Vector2 size,
    required Vector2 position,
    required this.borderRadius,
  }) : super(size: size, position: position);

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size.toSize(),
      Radius.circular(borderRadius),
    );

    canvas.drawRRect(rrect, paint);
  }
}

// Custom component for rounded icon shadow
class _RoundedIconShadow extends PositionComponent {
  final double borderRadius;

  _RoundedIconShadow({
    required Vector2 size,
    required Vector2 position,
    required this.borderRadius,
  }) : super(size: size, position: position);

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = Color(0x20000000)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 8);

    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size.toSize(),
      Radius.circular(borderRadius),
    );

    canvas.drawRRect(rrect, paint);
  }
}
