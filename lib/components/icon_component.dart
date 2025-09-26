import 'package:flame/components.dart';
import 'dart:ui';

class Icon extends PositionComponent with HasGameReference {
  Color color;

  Icon({
    this.color = const Color.fromARGB(255, 0, 100, 100),
    super.anchor = Anchor.center,
  }) : super(size: Vector2(50, 50));

  @override
  Future<void> onLoad() async {
    position = Vector2(0, 0);
    size = Vector2(50, 50);

    anchor = Anchor.center;
    return super.onLoad();
  }
}
