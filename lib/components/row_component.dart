import 'dart:ui';

import 'package:flame/components.dart';

class RowComponent extends RectangleComponent {
  Color color;
  Vector2 padding;
  double space;

  RowComponent({
    required super.children,
    required this.color,
    required this.padding,
    required this.space,
  });

  @override
  // TODO: implement debugMode
  bool get debugMode => true;

  @override
  Future<void> onLoad() async {
    paint.color = color;
    var index = 0;
    Vector2 previousSize = Vector2.zero();

    for (var (child as PositionComponent) in children) {
      child.position = Vector2(
        previousSize.x + padding.x + space * index,
        padding.y,
      );

      previousSize = child.size;
      index += 1;
    }

    return super.onLoad();
  }
}
