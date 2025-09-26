import 'package:flame/components.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';
import 'package:hack_game/components/panel.dart';

class MarkButton extends RectangleComponent {
  String content;
  Color color;

  Color fontColor;

  MarkButton({
    required this.content,
    required this.color,
    required super.size,
    required this.fontColor,
  });

  @override
  Future<void> onLoad() async {
    paint = Paint()..color = Colors.transparent;

    TextComponent text = TextComponent(
      text: content,
      textRenderer: TextPaint(style: TextStyle(color: fontColor, fontSize: 48)),
    );

    ColoredPanel box = ColoredPanel(
      color: color,
      children: [text],
      paint: paint,
      size: size,
    );

    assert(box.children.first is TextComponent);
    var statusText = box.children.first as TextComponent;
    statusText.position += box.size / 2 - statusText.size / 2;

    add(box);
    return super.onLoad();
  }
}
