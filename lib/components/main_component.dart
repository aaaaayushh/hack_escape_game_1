import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:hack_game/components/notification_component.dart';

class MainComponent extends SpriteComponent
    with HasGameReference, TapCallbacks {
  final Color color;
  final NotificationComponent notification;

  MainComponent({
    super.position,
    super.size,
    required this.notification,
    this.color = const Color.fromARGB(255, 0, 0, 0),
  });

  @override
  void onLoad() {
    paint.color = color;
    sprite = Sprite(game.images.fromCache("mail.png"));
    add(notification);
  }

  @override
  void onTapDown(TapDownEvent event) {
    print("Just pressed");
  }
}
