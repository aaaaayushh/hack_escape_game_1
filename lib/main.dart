import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:hack_game/game_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  Flame.device.setLandscape();

  runApp(GameApp());
}
