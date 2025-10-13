import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:hack_game/hack_game.dart';

class PowerDashboard extends World with HasGameReference<HackGame> {
  late TextComponent timerDisplay;
  int elapsedTime = 0;
  List<_PowerPanel> panels = [];

  PowerDashboard();

  @override
  Future<void> onLoad() async {
    final screenWidth = 1920.0;
    final screenHeight = 1080.0;

    // Dark background
    final background = RectangleComponent(
      size: Vector2(screenWidth, screenHeight),
      position: Vector2(0, 0),
      paint: Paint()..color = Color(0xFF0A0A0A),
    );
    add(background);

    // Header bar with title and time
    _addHeader(screenWidth);

    // Warning banner
    _addWarningBanner(screenWidth);

    // Four power panels in 2x2 grid
    _addPowerPanels(screenWidth, screenHeight);

    // Bottom instruction bar
    _addInstructionBar(screenWidth, screenHeight);

    // Start countdown timer
    _startCountdown();
  }

  void _addHeader(double screenWidth) {
    // Time display (top left) - real time
    final now = DateTime.now();
    final timeString =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    final timeDisplay = TextComponent(
      text: timeString,
      textRenderer: TextPaint(
        style: TextStyle(
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.w400,
        ),
      ),
      position: Vector2(60, 45),
      anchor: Anchor.centerLeft,
    );
    add(timeDisplay);

    // Update time every minute
    add(
      TimerComponent(
        period: 60.0,
        repeat: true,
        onTick: () {
          final now = DateTime.now();
          timeDisplay.text =
              '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
        },
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
        position: Vector2(screenWidth / 2, 45),
        anchor: Anchor.center,
      ),
    );

    // Countdown timer (top right)
    timerDisplay = TextComponent(
      text: '0:00',
      textRenderer: TextPaint(
        style: TextStyle(
          color: Color(0xFFFF6B35),
          fontSize: 40,
          fontWeight: FontWeight.bold,
        ),
      ),
      position: Vector2(screenWidth - 60, 45),
      anchor: Anchor.centerRight,
    );
    add(timerDisplay);

    // Battery/timer icon
    add(
      TextComponent(
        text: '⏱',
        textRenderer: TextPaint(
          style: TextStyle(color: Color(0xFFFF6B35), fontSize: 32),
        ),
        position: Vector2(screenWidth - 130, 45),
        anchor: Anchor.center,
      ),
    );
  }

  void _addWarningBanner(double screenWidth) {
    // Warning background bar
    final warningBar = RectangleComponent(
      size: Vector2(screenWidth - 200, 90),
      position: Vector2(100, 110),
      paint: Paint()
        ..color = Color(0xFFFF8C42)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
    add(warningBar);

    // Warning background fill
    add(
      RectangleComponent(
        size: Vector2(screenWidth - 200, 90),
        position: Vector2(100, 110),
        paint: Paint()..color = Color(0x20FF8C42),
      ),
    );

    // Warning icon
    add(
      TextComponent(
        text: '⚠',
        textRenderer: TextPaint(
          style: TextStyle(
            color: Color(0xFFFF8C42),
            fontSize: 48,
            fontWeight: FontWeight.bold,
          ),
        ),
        position: Vector2(150, 155),
        anchor: Anchor.center,
      ),
    );

    // Warning text
    add(
      TextComponent(
        text:
            'Emergency generators offline – Restore all 4 circuits to enable backup power.',
        textRenderer: TextPaint(
          style: TextStyle(
            color: Color(0xFFFF8C42),
            fontSize: 32,
            fontWeight: FontWeight.w500,
          ),
        ),
        position: Vector2(220, 155),
        anchor: Anchor.centerLeft,
      ),
    );
  }

  void _addPowerPanels(double screenWidth, double screenHeight) {
    final panelWidth = 750.0;
    final panelHeight = 300.0;
    final horizontalGap = 80.0;
    final verticalGap = 80.0;

    // Calculate starting position to center the grid
    final totalWidth = (panelWidth * 2) + horizontalGap;
    final startX = (screenWidth - totalWidth) / 2;
    final startY = 280.0;

    final panelData = [
      {'name': 'Panel 1', 'row': 0, 'col': 0},
      {'name': 'Panel 2', 'row': 0, 'col': 1},
      {'name': 'Panel 3', 'row': 1, 'col': 0},
      {'name': 'Panel 4', 'row': 1, 'col': 1},
    ];

    for (var data in panelData) {
      final row = data['row'] as int;
      final col = data['col'] as int;
      final name = data['name'] as String;

      final x = startX + (col * (panelWidth + horizontalGap));
      final y = startY + (row * (panelHeight + verticalGap));

      final panel = _PowerPanel(
        panelName: name,
        position: Vector2(x, y),
        size: Vector2(panelWidth, panelHeight),
      );

      panels.add(panel);
      add(panel);
    }
  }

  void _addInstructionBar(double screenWidth, double screenHeight) {
    add(
      TextComponent(
        text: 'Tap a panel to inspect and repair circuits.',
        textRenderer: TextPaint(
          style: TextStyle(
            color: Color(0xFF8EC4BB),
            fontSize: 32,
            fontWeight: FontWeight.w400,
          ),
        ),
        position: Vector2(screenWidth / 2, screenHeight - 80),
        anchor: Anchor.center,
      ),
    );
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
}

// Power Panel Component
class _PowerPanel extends PositionComponent
    with TapCallbacks, HasGameReference<HackGame> {
  final String panelName;
  bool isOffline = true;
  late List<_StatusLight> statusLights;

  _PowerPanel({
    required this.panelName,
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
    add(
      TextComponent(
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
      ),
    );

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
    add(
      TextComponent(
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
      ),
    );

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
      print('Tapped $panelName - Opening repair mini-game');
      // TODO: Transition to repair mini-game for this panel
    }
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
