import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:hack_game/hack_game.dart';

class SplashScreen extends World with HasGameReference<HackGame> {
  SplashScreen();

  late SpriteComponent logo;
  late _FadableRectangle boxRect;
  late _FadableRectangle boxOutline;

  @override
  Future<void> onLoad() async {
    final screenWidth = 1920.0;
    final screenHeight = 1080.0;

    // Add splash background image
    final background = SpriteComponent(
      sprite: Sprite(game.images.fromCache('splash_background.png')),
      size: Vector2(screenWidth, screenHeight),
      position: Vector2(0, 0),
    );
    add(background);

    // Logo dimensions - maintain aspect ratio (logo appears to be roughly square)
    final logoWidth = 500.0;
    final logoHeight = 500.0;
    final boxPadding = 50.0;
    final boxWidth = logoWidth + boxPadding * 2;
    final boxHeight = logoHeight + boxPadding * 2;

    // Create semi-transparent box with outline
    boxRect = _FadableRectangle(
      position: Vector2(
        (screenWidth - boxWidth) / 2,
        (screenHeight - boxHeight) / 2,
      ),
      size: Vector2(boxWidth, boxHeight),
      color: Color(0x990F1F30), // 60% opacity (#0F1F30 with 99 = 60% of FF)
      isFilled: true,
    );

    // Create outline for the box
    boxOutline = _FadableRectangle(
      position: Vector2(
        (screenWidth - boxWidth) / 2,
        (screenHeight - boxHeight) / 2,
      ),
      size: Vector2(boxWidth, boxHeight),
      color: Color(0xFF6DC5D9), // #6DC5D9
      isFilled: false,
      strokeWidth: 3.0,
    );

    // Add logo image with proper aspect ratio
    logo = SpriteComponent(
      sprite: Sprite(game.images.fromCache('escape_the hack_logo.png')),
      size: Vector2(logoWidth, logoHeight),
      position: Vector2(
        (screenWidth - logoWidth) / 2,
        (screenHeight - logoHeight) / 2,
      ),
    );

    add(boxRect);
    add(boxOutline);
    add(logo);

    // Show splash for 2.5 seconds, then fade out over 1 second
    Future.delayed(Duration(milliseconds: 2500), () {
      if (isMounted) {
        _startFadeOut();
      }
    });
  }

  void _startFadeOut() {
    // Add fade out effect to logo
    logo.add(OpacityEffect.fadeOut(EffectController(duration: 1.0)));

    // Start fade out for rectangles
    boxRect.fadeOut(1.0);
    boxOutline.fadeOut(
      1.0,
      onComplete: () {
        // Switch to loading screen after fade completes
        game.cam.world = game.loadingScreen;
      },
    );
  }
}

class _FadableRectangle extends PositionComponent {
  final Color color;
  final bool isFilled;
  final double strokeWidth;
  double opacity = 1.0;

  _FadableRectangle({
    required Vector2 position,
    required Vector2 size,
    required this.color,
    this.isFilled = true,
    this.strokeWidth = 1.0,
  }) : super(position: position, size: size);

  void fadeOut(double duration, {VoidCallback? onComplete}) {
    final startTime = DateTime.now().millisecondsSinceEpoch;
    final durationMs = (duration * 1000).toInt();

    // Add a component that updates opacity over time
    add(
      TimerComponent(
        period: 0.016, // ~60fps
        repeat: true,
        onTick: () {
          final elapsed = DateTime.now().millisecondsSinceEpoch - startTime;
          final progress = (elapsed / durationMs).clamp(0.0, 1.0);
          opacity = 1.0 - progress;

          if (progress >= 1.0) {
            opacity = 0.0;
            removeFromParent();
            onComplete?.call();
          }
        },
      ),
    );
  }

  @override
  void render(Canvas canvas) {
    if (opacity <= 0.0) return;

    final paint = Paint()
      ..color = color.withOpacity(color.opacity * opacity)
      ..style = isFilled ? PaintingStyle.fill : PaintingStyle.stroke;

    if (!isFilled) {
      paint.strokeWidth = strokeWidth;
    }

    canvas.drawRect(size.toRect(), paint);
  }
}
