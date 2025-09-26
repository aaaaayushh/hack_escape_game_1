import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/text.dart';
import 'package:flame_markdown/flame_markdown.dart';
import 'package:flutter/material.dart';
import 'package:hack_game/components/panel.dart';
import 'package:hack_game/components/round_rectangle_component.dart';

class MiniGame extends World with HasGameReference {
  Color color;

  MiniGame({required this.color});

  @override
  Future<void> onLoad() async {
    var textComponent = TextComponent(
      text: "Filter incoming information",
      position: Vector2(game.size.x / 2, 80),
      textRenderer: TextPaint(
        style: TextStyle(color: Colors.white, fontSize: 40),
      ),
    );

    var panel = Panel(
      children: [],
      paint: Paint(),
      color: Colors.white,
      position: Vector2(game.size.x / 2, 200),
      size: Vector2(900, 700),
    );
    textComponent.position.x =
        textComponent.position.x - textComponent.size.x / 2;
    panel.position.x = panel.position.x - panel.size.x / 2;

    final component = TextElementComponent.fromDocument(
      document: FlameMarkdown.toDocument(
        'From: IT support\n'
        'support@h0spital.com\n'
        '# **Urgent Patch** \n'
        '\n'
        'Click here to restore system immediately\n',
      ),
      style: DocumentStyle(
        text: InlineTextStyle(color: Colors.black, fontSize: 40),
      ),
      position: Vector2(panel.position.x + 48, panel.position.y + 48),
      size: Vector2(panel.size.x, panel.size.y),
    );

    final redButton = RoundedRectangleComponent(
      position: Vector2(
        panel.position.x + 400,
        panel.position.y + panel.size.y,
      ),
      size: Vector2(300, 100),
      borderRadius: 16,
      paint: Paint()..color = Colors.red,
      children: [
        TextComponent(
          text: "Fake",
          textRenderer: TextPaint(
            style: TextStyle(color: Colors.white, fontSize: 48),
          ),
        ),
      ],
    );

    final greenButton = RoundedRectangleComponent(
      position: Vector2(panel.position.x + 48, panel.position.y + panel.size.y),
      size: Vector2(300, 100),
      borderRadius: 16,
      paint: Paint()..color = Colors.green,
      children: [
        TextComponent(
          position: Vector2(0, 0),
          text: "Real",
          textRenderer: TextPaint(
            style: TextStyle(color: Colors.white, fontSize: 48),
          ),
        ),
      ],
    );
    assert(greenButton.children.first is TextComponent);
    assert(redButton.children.first is TextComponent);

    TextComponent gBText = (greenButton.children.first as TextComponent);
    greenButton.position.y -= greenButton.size.y * 2;
    gBText.position += greenButton.size / 2 - gBText.size / 2;

    TextComponent rBText = (redButton.children.first as TextComponent);
    redButton.position.y -= redButton.size.y * 2;
    rBText.position += redButton.size / 2 - rBText.size / 2;

    add(textComponent);
    add(panel);
    add(component);
    add(redButton);
    add(greenButton);

    return super.onLoad();
  }
}
