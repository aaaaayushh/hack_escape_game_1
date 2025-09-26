import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/material.dart';
import 'package:hack_game/components/status_component.dart';

class StatusWithDesc extends PositionComponent {
  GlowStatusComponent statusComponent;
  String description;

  StatusWithDesc({required this.statusComponent, required this.description});

  @override
  Future<void> onLoad() async {
    TextComponent textComponent = TextComponent(
      text: description,
      textRenderer: TextPaint(
        style: TextStyle(color: Colors.white, fontSize: 48),
      ),
    );

    RowComponent rowComponent = RowComponent(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [statusComponent, textComponent],
      gap: 24,
    );

    Vector2 maxSize = Vector2.zero();
    for (var (child as PositionComponent) in rowComponent.children) {
      if (maxSize.y < child.size.y) {
        maxSize.y = child.size.y;
      }
      maxSize.x += child.size.x;
    }

    size = maxSize;
    add(rowComponent);

    return super.onLoad();
  }
}
