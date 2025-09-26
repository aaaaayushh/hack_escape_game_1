import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:hack_game/hack_game.dart';

class GameApp extends StatelessWidget {
  const GameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.red,
        body: SafeArea(
          child: FittedBox(
            child: SizedBox(
              width: 1920,
              height: 1080,
              child: Center(child: GameWidget(game: HackGame())),
            ),
          ),
        ),
      ),
    );
  }
}
