import 'package:flame/components.dart';
import 'package:flame/game.dart';

import 'package:flutter/material.dart';
import 'package:hack_game/screens/level_two.dart';
import 'package:hack_game/screens/loading_screen.dart';
import 'package:hack_game/screens/phase_zero.dart';
import 'package:hack_game/screens/phase_one.dart';
import 'package:hack_game/screens/power_dashboard.dart';

class HackGame extends FlameGame {
  late CameraComponent cam;
  late LoadingScreen loadingScreen;
  late PhaseZero phaseZero;
  late PhaseOne phaseOne;
  late PowerDashboard powerDashboard;
  late LevelTwo levelTwo;

  @override
  Future<void> onLoad() async {
    await images.loadAllImages();
    _loadLevels();
    return super.onLoad();
  }

  @override
  Color backgroundColor() {
    return const Color.fromARGB(255, 0, 0, 0);
  }

  Future<void> _loadLevels() async {
    add(FpsTextComponent());
    phaseZero = PhaseZero();
    phaseOne = PhaseOne();
    powerDashboard = PowerDashboard();
    levelTwo = LevelTwo();
    loadingScreen = LoadingScreen();

    cam = CameraComponent.withFixedResolution(
      world: loadingScreen,
      width: 1920,
      height: 1080,
    );

    cam.viewfinder.anchor = Anchor.topLeft;

    addAll([cam, loadingScreen, phaseZero, phaseOne, powerDashboard, levelTwo]);
  }
}

// Resolution
// final deviceSize = size;
// final deviceAspectRatio = deviceSize.x / deviceSize.y;

// double gameWidth, gameHeight;
// if (deviceAspectRatio > gameSize.x / gameSize.y) {
//   // Wider device: fit to height
//   gameHeight = gameSize.y;
//   gameWidth = gameSize.y * deviceAspectRatio;
// } else {
//   // Taller device: fit to width
//   gameWidth = gameSize.x;
//   gameHeight = gameSize.x / deviceAspectRatio;
// }

// gameSize = Vector2(gameWidth, gameHeight);

// cam = CameraComponent.withFixedResolution(
//   world: world,
//   width: gameSize.x,
//   height: gameSize.y,
// );
