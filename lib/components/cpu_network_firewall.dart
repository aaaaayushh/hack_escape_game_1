import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/material.dart';
import 'package:hack_game/components/panel.dart';

class CpuNetworkFirewall extends RectangleComponent {
  final String cpuStatus;
  final String networkStatus;
  final String firewallStatus;

  CpuNetworkFirewall({
    required this.cpuStatus,
    required this.networkStatus,
    required this.firewallStatus,
    required super.size,
  });

  @override
  Future<void> onLoad() async {
    paint = Paint()..color = Colors.transparent;
    ColumnComponent columnComponent = ColumnComponent(
      size: size,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ColumnComponent(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextComponent(
              text: "CPU",
              textRenderer: TextPaint(
                style: TextStyle(color: Colors.yellow, fontSize: 48),
              ),
            ),
            TextComponent(
              text: cpuStatus,
              textRenderer: TextPaint(
                style: TextStyle(color: Colors.yellow, fontSize: 48),
              ),
            ),
          ],
        ),
        ColumnComponent(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextComponent(
              text: "Network",
              textRenderer: TextPaint(
                style: TextStyle(color: Colors.greenAccent, fontSize: 48),
              ),
            ),
            TextComponent(
              text: networkStatus,
              textRenderer: TextPaint(
                style: TextStyle(color: Colors.greenAccent, fontSize: 48),
              ),
            ),
          ],
        ),
        ColumnComponent(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextComponent(
              text: "Firewall",
              textRenderer: TextPaint(
                style: TextStyle(color: Colors.grey, fontSize: 48),
              ),
            ),
            TextComponent(
              text: firewallStatus,
              textRenderer: TextPaint(
                style: TextStyle(color: Colors.grey, fontSize: 48),
              ),
            ),
          ],
        ),
      ],
    );

    Panel panel = Panel(
      color: Colors.grey,
      children: [columnComponent],
      paint: Paint(),
      size: size,
    );

    add(panel);
  }
}
