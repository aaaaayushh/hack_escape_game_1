import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:hack_game/hack_game.dart';
import 'package:hack_game/components/ui/fadable_rectangle.dart';
import 'package:hack_game/ui/constants.dart';

class SplashScreen extends World with HasGameReference<HackGame> {
  SplashScreen();

  late SpriteComponent logo;
  late FadableRectangle boxRect;
  late FadableRectangle boxOutline;

  // Track if this is the initial splash (goes to loading) or transition splash (goes to phase one)
  bool isTransitionToPhaseOne = false;

  @override
  Future<void> onLoad() async {
    final screenWidth = game.size.x;
    final screenHeight = game.size.y;

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
    boxRect = FadableRectangle(
      position: Vector2(
        (screenWidth - boxWidth) / 2,
        (screenHeight - boxHeight) / 2,
      ),
      size: Vector2(boxWidth, boxHeight),
      color: const Color(0x990F1F30),
      isFilled: true,
    );

    // Create outline for the box
    boxOutline = FadableRectangle(
      position: Vector2(
        (screenWidth - boxWidth) / 2,
        (screenHeight - boxHeight) / 2,
      ),
      size: Vector2(boxWidth, boxHeight),
      color: UiColors.brandTeal,
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
    Future.delayed(Duration(milliseconds: 2000), () {
      if (isMounted) {
        _startFadeOut();
      }
    });
  }

  void prepareForTransitionToPhaseOne() {
    // Reset opacity for logo (use opacity property for components)
    logo.opacity = 1.0;

    // Re-add rectangles if they were removed
    if (!boxRect.isMounted) {
      boxRect.resetOpacity();
      add(boxRect);
    } else {
      boxRect.resetOpacity();
    }

    if (!boxOutline.isMounted) {
      boxOutline.resetOpacity();
      add(boxOutline);
    } else {
      boxOutline.resetOpacity();
    }

    // Set flag to transition to phase one
    isTransitionToPhaseOne = true;

    // Start the fade sequence
    Future.delayed(Duration(milliseconds: 2000), () {
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
        // Switch to appropriate screen based on context
        if (isTransitionToPhaseOne) {
          game.cam.world = game.phaseOne;
          game.phaseOne.startSequence();
          // Reset flag for next time
          isTransitionToPhaseOne = false;
        } else {
          game.cam.world = game.loadingScreen;
        }
      },
    );
  }
}
