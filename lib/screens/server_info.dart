import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/material.dart';
import 'package:hack_game/components/cpu_network_firewall.dart';
import 'package:hack_game/components/panel.dart';
import 'package:hack_game/components/round_rectangle_component.dart';
import 'package:hack_game/components/status_component.dart';
import 'package:hack_game/components/status_with_desc.dart';
import 'package:hack_game/hack_game.dart';

enum ServerStatus { infected, unknown, safe, observation }

// Server Info level
// Here it should be the whole panel
class ServerInfo extends PositionComponent with HasGameReference<HackGame> {
  Color color;

  ServerInfo({required this.color});

  @override
  get debugMode => false;

  @override
  Future<void> onLoad() async {
    RectangleComponent rightMargin = RectangleComponent(
      size: Vector2(64, 600),
      paint: Paint()..color = Colors.transparent,
    );
    ColumnComponent information = ColumnComponent(
      size: Vector2(1350, 600),
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StatusWithDesc(
          description: "Some content",
          statusComponent:
              GlowStatusComponent(
                icon: null,
                size: Vector2(300, 100),
                backgroundColor: Colors.grey,
                glowColor: Colors.transparent,
                fontColor: Colors.white,
                content: 'Uncertain',
              )..add(
                GlowEffect(
                  10,
                  EffectController(
                    duration: 5,
                    reverseDuration: 5,
                    infinite: true,
                  ),
                ),
              ),
        ),
        StatusWithDesc(
          description: "Another spike",
          statusComponent:
              GlowStatusComponent(
                icon: null,
                size: Vector2(300, 100),
                backgroundColor: Colors.grey,
                glowColor: Colors.transparent,
                fontColor: Colors.white,
                content: 'Uncertain',
              )..add(
                GlowEffect(
                  10,
                  EffectController(
                    duration: 5,
                    reverseDuration: 5,
                    infinite: true,
                  ),
                ),
              ),
        ),
        StatusWithDesc(
          description: "Something did not work as expected",
          statusComponent:
              GlowStatusComponent(
                icon: null,
                size: Vector2(300, 100),
                backgroundColor: Colors.grey,
                glowColor: Colors.transparent,
                fontColor: Colors.white,
                content: 'Uncertain',
              )..add(
                GlowEffect(
                  10,
                  EffectController(
                    duration: 5,
                    reverseDuration: 5,
                    infinite: true,
                  ),
                ),
              ),
        ),
        StatusWithDesc(
          description: "CPU usage spike detected",
          statusComponent:
              GlowStatusComponent(
                icon: null,
                size: Vector2(300, 100),
                backgroundColor: Colors.grey,
                glowColor: Colors.transparent,
                fontColor: Colors.white,
                content: 'Uncertain',
              )..add(
                GlowEffect(
                  10,
                  EffectController(
                    duration: 5,
                    reverseDuration: 5,
                    infinite: true,
                  ),
                ),
              ),
        ),
      ],
      gap: 24,
    );
    RowComponent infoRow = RowComponent(children: [rightMargin, information]);

    Panel infoPanel = Panel(
      color: Colors.grey,
      children: [infoRow],
      paint: Paint(),
      size: Vector2(1420, 600),
    );

    RowComponent rowComponent = RowComponent(
      size: Vector2(1792, 180),
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GlowingBox(
          icon: "Infected.png",
          size: Vector2(400, 150),
          backgroundColor: Color(0xFFFF0000),
          glowColor: Color(0xFF361114),
          content: "Infected",
          fontColor: Color(0xFFE2A69D),
          tapDownFunction: () => game.levelTwo.router.pop(),
        )..add(
          GlowEffect(
            10,
            EffectController(duration: 3, reverseDuration: 1, infinite: true),
          ),
        ),
        GlowingBox(
          icon: "Safe.png",
          size: Vector2(400, 150),
          glowColor: Color(0xFF0D3128),
          backgroundColor: Color(0xFF00FF00),
          content: "Safe",
          fontColor: Color(0xFF8EC4BB),
          tapDownFunction: () => game.levelTwo.router.pop(),
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
        ),
        GlowingBox(
          icon: "Observation.png",
          size: Vector2(400, 150),
          glowColor: Color(0xFF0B2433),
          backgroundColor: Color(0xFF0000FF),
          content: "Observation",
          fontColor: Color(0xFF9CCDD8),
          tapDownFunction: () => game.levelTwo.router.pop(),
        )..add(
          GlowEffect(
            10,
            EffectController(
              duration: 3,
              reverseDuration: 1,
              infinite: true,
              startDelay: 0,
            ),
          ),
        ),
      ],
    );

    CpuNetworkFirewall cpuNetworkFirewall = CpuNetworkFirewall(
      size: Vector2(350, 600),
      cpuStatus: 'Spiking',
      networkStatus: 'Stable',
      firewallStatus: 'Unsafe',
    );

    RowComponent anotherRowComponent = RowComponent(
      size: Vector2(1792, 600),
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: [infoPanel, cpuNetworkFirewall],
    );

    ColumnComponent another = ColumnComponent(
      size: Vector2(1920, 1080),
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RowComponent(
          children: [
            GlowStatusComponent(
              icon: null,
              size: Vector2(800, 100),
              backgroundColor: Colors.grey,
              glowColor: Colors.grey,
              fontColor: Colors.white,
              content: 'Server 2 - Status unknown',
            )..add(
              GlowEffect(
                30,
                EffectController(
                  duration: 3,
                  reverseDuration: 7,
                  infinite: true,
                ),
              ),
            ),
          ],
        ),
        anotherRowComponent,
        rowComponent,
      ],
    );

    add(another);
    // add(information);
    // add(rowComponent);
    return super.onLoad();
  }
}
