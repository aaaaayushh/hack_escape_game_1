import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:hack_game/hack_game.dart';
import 'package:hack_game/components/ui/status_bar.dart';
import 'package:hack_game/components/ui/warning_banner.dart';
import 'package:hack_game/ui/constants.dart';
import 'package:hack_game/screens/power_circuit_minigame.dart';

class PowerDashboard extends World with HasGameReference<HackGame> {
  late TextComponent timerDisplay;
  late _DashboardPowerButton powerButton;
  int elapsedTime = 0;
  List<_PowerPanel> panels = [];
  Set<int> completedPanels = {};
  PowerCircuitMinigame? currentMinigame;

  PowerDashboard();

  @override
  Future<void> onLoad() async {
    final screenWidth = game.size.x;
    final screenHeight = game.size.y;

    // Background with matrix pattern
    final background = RectangleComponent(
      size: Vector2(screenWidth, screenHeight),
      position: Vector2(0, 0),
      paint: Paint()..color = Color(0xFF001219),
    );
    add(background);

    // Add matrix pattern overlay
    add(_MatrixBackground(size: Vector2(screenWidth, screenHeight)));

    // Header bar with title and time
    _addHeader(screenWidth);

    // Warning banner
    add(
      WarningBanner(
        position: Vector2((screenWidth - (screenWidth - 200)) / 2, 140),
        size: Vector2(screenWidth - 200, 90),
        message:
            'Emergency generators offline – Restore all 4 circuits to enable backup power.',
        color: UiColors.warnRed,
        flash: false,
      ),
    );

    // Four power panels in 2x2 grid
    _addPowerPanels(screenWidth, screenHeight);

    // Bottom power button
    _addPowerButton(screenWidth, screenHeight);

    // Start countdown timer
    _startCountdown();
  }

  void _addHeader(double screenWidth) {
    // Status bar at the very top
    add(
      StatusBar(
        screenWidth: screenWidth,
        y: 20,
        timeColor: Colors.white,
        centerTime: false,
        showWifiBattery: true,
      ),
    );

    // Title (center)
    add(
      TextComponent(
        text: 'Power Dashboard',
        textRenderer: TextPaint(
          style: TextStyle(
            color: Color(0xFF8EC4BB),
            fontSize: 36,
            fontWeight: FontWeight.w500,
          ),
        ),
        position: Vector2(screenWidth / 2, 70),
        anchor: Anchor.center,
      ),
    );

    // Countdown timer (top right, below status bar)
    timerDisplay = TextComponent(
      text: '0:00',
      textRenderer: TextPaint(
        style: TextStyle(
          color: const Color(0xFFFF6B35),
          fontSize: 40,
          fontWeight: FontWeight.bold,
        ),
      ),
      position: Vector2(screenWidth - 60, 70),
      anchor: Anchor.centerRight,
    );
    add(timerDisplay);

    // Timer icon (with proper spacing to avoid overlap)
    add(
      TextComponent(
        text: '⏱',
        textRenderer: TextPaint(
          style: const TextStyle(color: Color(0xFFFF6B35), fontSize: 32),
        ),
        position: Vector2(screenWidth - 145, 70),
        anchor: Anchor.center,
      ),
    );
  }

  // Legacy placeholder removed; WarningBanner is added directly in onLoad

  void _addPowerPanels(double screenWidth, double screenHeight) {
    final panelWidth = 750.0;
    final panelHeight = 300.0;
    final horizontalGap = 80.0;
    final verticalGap = 80.0;

    // Calculate starting position to center the grid
    final totalWidth = (panelWidth * 2) + horizontalGap;
    final startX = (screenWidth - totalWidth) / 2;
    final startY = 270.0;

    final panelData = [
      {'name': 'Panel 1', 'number': 1, 'row': 0, 'col': 0},
      {'name': 'Panel 2', 'number': 2, 'row': 0, 'col': 1},
      {'name': 'Panel 3', 'number': 3, 'row': 1, 'col': 0},
      {'name': 'Panel 4', 'number': 4, 'row': 1, 'col': 1},
    ];

    for (var data in panelData) {
      final row = data['row'] as int;
      final col = data['col'] as int;
      final name = data['name'] as String;
      final number = data['number'] as int;

      final x = startX + (col * (panelWidth + horizontalGap));
      final y = startY + (row * (panelHeight + verticalGap));

      final panel = _PowerPanel(
        panelName: name,
        panelNumber: number,
        dashboard: this,
        position: Vector2(x, y),
        size: Vector2(panelWidth, panelHeight),
      );

      panels.add(panel);
      add(panel);
    }
  }

  void _addPowerButton(double screenWidth, double screenHeight) {
    powerButton = _DashboardPowerButton(
      position: Vector2(screenWidth / 2, screenHeight - 50),
      size: Vector2(400, 75),
      onTap: _onMainPowerButtonPressed,
    );
    add(powerButton);
  }

  void _onMainPowerButtonPressed() {
    if (completedPanels.length == 4) {
      // All panels restored - trigger next phase
      print('Main power button pressed - all panels restored!');
      // TODO: Transition to next phase/level
    }
  }

  void _startCountdown() {
    add(
      TimerComponent(
        period: 1.0,
        repeat: true,
        onTick: () {
          elapsedTime++;
          final minutes = elapsedTime ~/ 60;
          final seconds = elapsedTime % 60;
          timerDisplay.text = '$minutes:${seconds.toString().padLeft(2, '0')}';

          // Change color as time goes on
          if (elapsedTime >= 90) {
            final textPaint = timerDisplay.textRenderer as TextPaint;
            timerDisplay.textRenderer = TextPaint(
              style: textPaint.style.copyWith(color: Color(0xFFFF0000)),
            );
          } else if (elapsedTime >= 60) {
            final textPaint = timerDisplay.textRenderer as TextPaint;
            timerDisplay.textRenderer = TextPaint(
              style: textPaint.style.copyWith(color: Color(0xFFFF8C42)),
            );
          }
        },
      ),
    );
  }

  void _onPanelComplete(int panelNumber) {
    completedPanels.add(panelNumber);

    // Update the panel status
    final panel = panels[panelNumber - 1];
    panel.markAsOnline();

    // Clean up and return to dashboard
    if (currentMinigame != null) {
      game.remove(currentMinigame!);
      currentMinigame = null;
    }
    game.cam.world = this;

    // Check if all panels are complete
    if (completedPanels.length == 4) {
      powerButton.activate();
      print('All panels restored! Power button activated.');
    }
  }

  void _launchMinigame(int panelNumber) {
    currentMinigame = PowerCircuitMinigame(
      panelNumber: panelNumber,
      onComplete: _onPanelComplete,
    );
    game.add(currentMinigame!);
    game.cam.world = currentMinigame!;
  }
}

// Power Panel Component
class _PowerPanel extends PositionComponent
    with TapCallbacks, HasGameReference<HackGame> {
  final String panelName;
  final int panelNumber;
  final PowerDashboard dashboard;
  bool isOffline = true;
  late List<_StatusLight> statusLights;
  late TextComponent statusText;
  late TextComponent offlineText;

  _PowerPanel({
    required this.panelName,
    required this.panelNumber,
    required this.dashboard,
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    // Panel border with neon effect
    add(_PanelBorder(size: size, borderColor: Color(0xFF8EC4BB)));

    // Panel background
    add(
      RectangleComponent(size: size, paint: Paint()..color = Color(0x15000000)),
    );

    // Panel header with name and status
    statusText = TextComponent(
      text: '$panelName – Offline',
      textRenderer: TextPaint(
        style: TextStyle(
          color: Color(0xFF8EC4BB),
          fontSize: 28,
          fontWeight: FontWeight.w400,
        ),
      ),
      position: Vector2(30, 35),
      anchor: Anchor.centerLeft,
    );
    add(statusText);

    // Status lights (3 small circles)
    statusLights = [];
    for (int i = 0; i < 3; i++) {
      final light = _StatusLight(
        position: Vector2(size.x - 120 + (i * 30), 35),
        isActive: false,
      );
      statusLights.add(light);
      add(light);
    }

    // Large OFFLINE text
    offlineText = TextComponent(
      text: 'OFFLINE',
      textRenderer: TextPaint(
        style: TextStyle(
          color: Color(0xFFFF8C42),
          fontSize: 80,
          fontWeight: FontWeight.bold,
          letterSpacing: 4,
        ),
      ),
      position: Vector2(size.x / 2, size.y / 2 + 20),
      anchor: Anchor.center,
    );
    add(offlineText);

    // Add flickering effect to lights
    _startFlickering();
  }

  void _startFlickering() {
    add(
      TimerComponent(
        period: 0.3,
        repeat: true,
        onTick: () {
          // Random flickering of status lights
          for (var light in statusLights) {
            if (DateTime.now().millisecond % 3 == 0) {
              light.flicker();
            }
          }
        },
      ),
    );
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (isOffline) {
      dashboard._launchMinigame(panelNumber);
    }
  }

  void markAsOnline() {
    isOffline = false;

    // Update status text
    statusText.text = '$panelName – Online';
    final textPaint = statusText.textRenderer as TextPaint;
    statusText.textRenderer = TextPaint(
      style: textPaint.style.copyWith(color: Color(0xFF00FF00)),
    );

    // Update status lights to green
    for (var light in statusLights) {
      light.isActive = true;
      light.currentColor = Color(0xFF00FF00);
    }

    // Change OFFLINE to ONLINE
    offlineText.text = 'ONLINE';
    final offlinePaint = offlineText.textRenderer as TextPaint;
    offlineText.textRenderer = TextPaint(
      style: offlinePaint.style.copyWith(color: Color(0xFF00FF00)),
    );
  }
}

// Panel Border Component
class _PanelBorder extends PositionComponent {
  final Color borderColor;

  _PanelBorder({required Vector2 size, required this.borderColor})
    : super(size: size);

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size.toSize(),
      Radius.circular(8),
    );

    canvas.drawRRect(rrect, paint);
  }
}

// Status Light Component
class _StatusLight extends PositionComponent {
  bool isActive;
  Color currentColor;

  _StatusLight({required Vector2 position, required this.isActive})
    : currentColor = isActive ? Color(0xFF00FF00) : Color(0xFFFF0000),
      super(position: position, size: Vector2(12, 12), anchor: Anchor.center);

  void flicker() {
    // Alternate between red and amber for offline state
    if (!isActive) {
      currentColor = currentColor == Color(0xFFFF0000)
          ? Color(0xFFFF8C42)
          : Color(0xFFFF0000);
    }
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = currentColor;

    canvas.drawCircle(Offset(size.x / 2, size.y / 2), size.x / 2, paint);

    // Add glow effect
    final glowPaint = Paint()
      ..color = currentColor.withOpacity(0.5)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 6);

    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2),
      size.x / 2 + 3,
      glowPaint,
    );
  }
}

// Matrix-style background component
class _MatrixBackground extends PositionComponent {
  final List<_MatrixColumn> columns = [];

  _MatrixBackground({required Vector2 size}) : super(size: size);

  @override
  Future<void> onLoad() async {
    // Create matrix columns
    for (double x = 0; x < size.x; x += 30) {
      final column = _MatrixColumn(position: Vector2(x, 0), height: size.y);
      columns.add(column);
      add(column);
    }
  }
}

// Individual matrix column
class _MatrixColumn extends PositionComponent {
  final double height;
  double offset = 0;

  _MatrixColumn({required Vector2 position, required this.height})
    : super(position: position) {
    offset = (position.x * 10) % height;
  }

  @override
  void render(Canvas canvas) {
    final textPaint = TextPaint(
      style: TextStyle(
        color: Color(0xFF00FF41).withOpacity(0.1),
        fontSize: 12,
        fontFamily: 'monospace',
      ),
    );

    // Draw falling characters
    for (double y = offset % 40; y < height; y += 40) {
      if (y % 80 == 0) {
        final char = ['0', '1', '|', '/', '\\'][((position.x + y) ~/ 10) % 5];
        textPaint.render(canvas, char, Vector2(0, y));
      }
    }
  }
}

// Dashboard Power Button Component
class _DashboardPowerButton extends PositionComponent with TapCallbacks {
  bool isActive = false;
  final Function() onTap;

  _DashboardPowerButton({
    required Vector2 position,
    required Vector2 size,
    required this.onTap,
  }) : super(position: position, size: size, anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    _updateButton();
  }

  void activate() {
    if (!isActive) {
      isActive = true;
      _updateButton();
    }
  }

  void deactivate() {
    if (isActive) {
      isActive = false;
      _updateButton();
    }
  }

  void _updateButton() {
    removeAll(children);

    final bgColor = isActive ? Color(0xFF0D4761) : Color(0xFF1A1A1A);
    final borderColor = isActive ? Color(0xFF6DC5D9) : Color(0xFF444444);
    final textColor = isActive ? Color(0xFF6DC5D9) : Color(0xFF666666);

    // Background
    add(RectangleComponent(size: size, paint: Paint()..color = bgColor));

    // Border
    add(
      RectangleComponent(
        size: size,
        paint: Paint()
          ..color = borderColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4,
      ),
    );

    // Text
    add(
      TextComponent(
        text: 'Turn Power On',
        textRenderer: TextPaint(
          style: TextStyle(
            color: textColor,
            fontSize: 42,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        position: size / 2,
        anchor: Anchor.center,
      ),
    );

    // Add glow effect when active
    if (isActive) {
      add(
        RectangleComponent(
          size: size,
          paint: Paint()
            ..color = Color(0xFF6DC5D9).withOpacity(0.3)
            ..maskFilter = MaskFilter.blur(BlurStyle.normal, 10),
        ),
      );
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (isActive) {
      onTap();
    }
  }
}
