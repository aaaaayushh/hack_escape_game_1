import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
// ..add(GlowEffect(10.0, EffectController(duration: 2, infinite: true)))
import 'package:flutter/material.dart' hide Route;
import 'package:hack_game/components/panel.dart';
import 'package:hack_game/components/round_rectangle_component.dart';
import 'package:hack_game/screens/server_info.dart';

class LevelTwo extends World with HasGameReference {
  late final RouterComponent router;

  LevelTwo();

  @override
  Future<void> onLoad() async {
    GlowingBox panel =
        GlowingBox(
          position: Vector2(0, 0),
          icon: null,
          size: Vector2(800, 100),
          glowColor: Colors.transparent,
          backgroundColor: Colors.red,
          content: "Alert malware detected",
          fontColor: Colors.red,
          tapDownFunction: () => {},
        )..add(
          GlowEffect(
            10,
            EffectController(
              duration: 1,
              reverseDuration: 1,
              infinite: true,
              alternate: false,
              startDelay: 0,
            ),
          ),
        );

    PositionComponent theMainScreen = PositionComponent();

    final screenWidth = 1920;
    final screenHeight = 1080;
    int rowNoIcons = 4;
    int colNoIcons = 2;
    double iconSize = 200;

    int numberOfServers = 8;
    List<GlowingBox> servers = [];

    final double spaceX =
        (screenWidth - iconSize * rowNoIcons) / (rowNoIcons + 1);
    final double spaceY =
        (screenHeight - iconSize * colNoIcons) / (colNoIcons + 1);

    double x = spaceX, y = spaceY;

    for (int i = 0; i < numberOfServers; i += 1) {
      GlowingBox server =
          GlowingBox(
            position: Vector2(x, y),
            icon: null,
            size: Vector2(iconSize, iconSize),
            glowColor: Colors.transparent,
            backgroundColor: Colors.grey,
            content: "Server ${i + 1}",
            fontColor: Color(0xFF8EC4BB),
            tapDownFunction: () => router.pushNamed("server${i + 1}"),
          )..add(
            GlowEffect(
              10,
              EffectController(
                duration: 1,
                reverseDuration: 1,
                infinite: true,
                alternate: false,
                startDelay: 0,
              ),
            ),
          );
      // Panel server = Panel(
      //   position: Vector2(x, y),
      //   children: [
      //     TextComponent(
      //       position: Vector2(0, 0),
      //       text: "Server",
      //       textRenderer: TextPaint(
      //         style: TextStyle(color: Colors.white, fontSize: 48),
      //       ),
      //     ),
      //   ],
      //   tapDownFunction: () => router.pushNamed('server1'),
      //   size: Vector2(iconSize, iconSize),
      //   paint: Paint()..color = Color(0x0AEB5F58),
      //   color: Colors.green,
      // );

      // assert(server.children.first is TextComponent);
      // var serverText = server.children.first as TextComponent;
      // serverText.position += server.size / 2 - serverText.size / 2;

      x += spaceX + iconSize;
      if (i != 0 && (i + 1) % rowNoIcons == 0) {
        x = spaceX;
        y += spaceY + iconSize;
      }

      servers.add(server);
    }

    theMainScreen.addAll(servers);
    theMainScreen.add(
      RowComponent(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        size: Vector2(1920, 175),
        children: [panel],
      ),
    );
    // addAll(servers);
    // add(panel);

    router = RouterComponent(
      routes: {
        'main': Route(() => theMainScreen),
        'server1': Route(() => ServerInfo(color: Colors.red)),
        'server2': Route(() => ServerInfo(color: Colors.red)),
        'server3': Route(() => ServerInfo(color: Colors.red)),
        'server4': Route(() => ServerInfo(color: Colors.red)),
        'server5': Route(() => ServerInfo(color: Colors.red)),
        'server6': Route(() => ServerInfo(color: Colors.red)),
        'server7': Route(() => ServerInfo(color: Colors.red)),
        'server8': Route(() => ServerInfo(color: Colors.red)),
      },
      initialRoute: 'main',
    );
    add(router);
  }
}
