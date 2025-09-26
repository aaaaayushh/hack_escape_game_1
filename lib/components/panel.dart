import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:hack_game/components/round_rectangle_component.dart';

class Panel extends RoundedRectangleComponent with HasPaint, TapCallbacks {
  Color color;

  void Function()? tapDownFunction;

  Panel({
    super.position,
    super.size,
    super.borderRadius = 4.0,
    required this.color,
    required super.children,
    required super.paint,
    this.tapDownFunction,
  });

  @override
  Future<void> onLoad() async {
    paint.color = color;
  }

  @override
  void onTapDown(TapDownEvent event) {
    tapDownFunction?.call();
  }
}

class ColoredPanel extends ColoredRoundedRectangleComponent
    with HasPaint, TapCallbacks {
  Color color;
  Function(TapDownEvent event)? tapDownFunction;

  ColoredPanel({
    super.position,
    super.size,
    super.borderRadius = 4.0,
    required this.color,
    required super.children,
    required super.paint,
  });

  @override
  Future<void> onLoad() async {
    paint = Paint()..color = color;
  }

  @override
  void onTapDown(TapDownEvent event) => tapDownFunction!(event);
}
