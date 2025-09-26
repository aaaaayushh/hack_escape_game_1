import 'package:flame/components.dart';
import 'package:flame/game.dart';

import 'package:flutter/material.dart';
import 'package:hack_game/screens/level_two.dart';

class HackGame extends FlameGame {
  late CameraComponent cam;
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
    // Level level = Level();
    // MiniGame minigame = MiniGame(color: Colors.white);
    levelTwo = LevelTwo();
    // ServerInfo serverInfo = ServerInfo(color: Colors.grey);

    cam = CameraComponent.withFixedResolution(
      world: levelTwo,
      width: 1920,
      height: 1080,
    );

    cam.viewfinder.anchor = Anchor.topLeft;

    // addAll([cam, level]);
    addAll([cam, levelTwo]);
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
