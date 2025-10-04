import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:hack_game/components/round_rectangle_component.dart';
import 'package:hack_game/hack_game.dart';

class LoadingScreen extends World
    with HasGameReference<HackGame>, TapCallbacks {
  LoadingScreen();

  @override
  Future<void> onLoad() async {
    final screenWidth = 1920.0;
    final screenHeight = 1080.0;

    // Add background image
    final background = SpriteComponent(
      sprite: Sprite(game.images.fromCache('Background before hack.png')),
      size: Vector2(screenWidth, screenHeight),
      position: Vector2(0, 0),
    );

    // Add a glowing "Press to Start" button
    GlowingBox startButton =
        GlowingBox(
          position: Vector2(screenWidth / 2 - 300, screenHeight - 250),
          icon: null,
          size: Vector2(600, 120),
          glowColor: Color(0xFF8EC4BB),
          backgroundColor: Color(0xFF1A1A1A),
          content: "Press to Start",
          fontColor: Colors.white,
          tapDownFunction: () {
            // Switch camera to levelTwo
            game.cam.world = game.levelTwo;
          },
        )..add(
          GlowEffect(
            15,
            EffectController(
              duration: 1.5,
              reverseDuration: 1.5,
              infinite: true,
              alternate: false,
              startDelay: 0,
            ),
          ),
        );

    add(background);
    add(startButton);
  }
}
