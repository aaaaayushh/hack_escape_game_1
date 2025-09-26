import 'dart:ui';

import 'package:flame/components.dart';

class NotificationComponent extends CircleComponent {
  final Color color;

  NotificationComponent({
    required super.position,
    super.radius,
    super.anchor = Anchor.center,
    this.color = const Color.fromARGB(255, 180, 0, 0),
  });

  @override
  Future<void> onLoad() async {
    paint.color = color;
    return super.onLoad();
  }
}
