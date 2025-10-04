import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Button extends RectangleComponent {
  final Color color;

  Button({required super.size, required super.position, required this.color});

  @override
  Future<void> onLoad() async {
    add(
      TextBoxComponent(
        text: "Mircea",
        textRenderer: TextPaint(
          style: TextStyle(color: Colors.white, fontSize: 40),
        ),
        boxConfig: TextBoxConfig(margins: EdgeInsets.all(8.0)),
      ),
    );
    paint.color = color;
    return super.onLoad();
  }
}
