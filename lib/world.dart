import 'package:flame/components.dart';
import 'package:hack_game/components/main_component.dart';
import 'package:hack_game/components/notification_component.dart';
import 'package:hack_game/hack_game.dart';

class Level extends World with HasGameReference<HackGame> {
  Level();

  @override
  Future<void> onLoad() async {
    // Use actual game screen dimensions
    final screenWidth = game.size.x;
    final screenHeight = game.size.y;
    // ---

    final rowNoIcons = 3;
    final colNoIcons = 3;
    final double iconSize = 200;

    final double spaceX =
        (screenWidth - iconSize * rowNoIcons) / (rowNoIcons + 1);
    final double spaceY =
        (screenHeight - iconSize * colNoIcons) / (colNoIcons + 1);

    double x = spaceX, y = spaceY;

    List<MainComponent> icons = [];

    for (int i = 0; i < rowNoIcons * colNoIcons; i++) {
      final icon = MainComponent(
        notification: NotificationComponent(
          position: Vector2(iconSize - 10, 10),
          radius: 20,
        ),
        position: Vector2(x, y),
        size: Vector2(iconSize, iconSize),
      );
      icons.insert(i, icon);

      x += spaceX + iconSize;
      if (i != 0 && (i + 1) % rowNoIcons == 0) {
        x = spaceX;
        y += spaceY + iconSize;
      }
    }

    addAll(icons);
    return super.onLoad();
  }
}
