import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:hack_game/components/panel.dart';
import 'package:hack_game/components/round_rectangle_component.dart';

enum StatusType { uncertain, suspicious, normal }

class GlowStatusComponent extends GlowingBox {
  GlowStatusComponent({
    required super.size,
    required super.backgroundColor,
    required super.glowColor,
    required super.fontColor,
    required super.content,
    required super.icon,
  });
}

class StatusComponent extends PositionComponent {
  String text;
  Color color;

  StatusComponent({
    required this.text,
    required this.color,
    required super.size,
  });

  @override
  Future<void> onLoad() async {
    TextComponent status = TextComponent(
      text: text,
      textRenderer: TextPaint(
        style: TextStyle(color: Colors.white, fontSize: 48),
      ),
    );

    Panel box = Panel(
      color: color,
      children: [status],
      paint: Paint(),
      size: size,
    );

    // Center text inside the box
    assert(box.children.first is TextComponent);
    var statusText = box.children.first as TextComponent;
    statusText.position += box.size / 2 - statusText.size / 2;

    size = box.size;
    add(box);
    return super.onLoad();
  }
}
