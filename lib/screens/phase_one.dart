import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:hack_game/hack_game.dart';

class PhaseOne extends World with HasGameReference<HackGame>, TapCallbacks {
  late RectangleComponent background;
  late TextComponent hospitalLogo;
  late List<_HackedAppIcon> appIcons;
  bool isTransitioning = false;
  bool hasStarted = false;

  PhaseOne();

  @override
  Future<void> onLoad() async {
    final screenWidth = 1920.0;
    final screenHeight = 1080.0;

    // Dark background (will transition from white)
    background = RectangleComponent(
      size: Vector2(screenWidth, screenHeight),
      position: Vector2(0, 0),
      paint: Paint()..color = Color(0xFF0A0A0A),
    );
    add(background);

    // Status bar at top
    _addStatusBar(screenWidth);

    // Add flashing warning banner
    _addWarningBanner(screenWidth);

    // Hospital logo (will be glitched)
    hospitalLogo = TextComponent(
      text: 'St. Aegis Medical',
      textRenderer: TextPaint(
        style: TextStyle(
          color: Color(0xFF8EC4BB),
          fontSize: 56,
          fontWeight: FontWeight.w300,
          letterSpacing: 3,
        ),
      ),
      position: Vector2(screenWidth / 2, 200),
      anchor: Anchor.center,
    );
    add(hospitalLogo);

    // Add hacked app grid
    await _addHackedAppGrid(screenWidth, screenHeight);
  }

  void startSequence() {
    if (hasStarted) return;
    hasStarted = true;

    // Start the hack transition sequence after a short delay
    add(
      TimerComponent(
        period: 2.0,
        repeat: false,
        onTick: () {
          _startHackSequence();
        },
      ),
    );
  }

  void _addStatusBar(double screenWidth) {
    // Time display (glitched)
    add(
      TextComponent(
        text: '08:41',
        textRenderer: TextPaint(
          style: TextStyle(
            color: Color(0xFF8EC4BB),
            fontSize: 40,
            fontWeight: FontWeight.w500,
          ),
        ),
        position: Vector2(screenWidth / 2, 45),
        anchor: Anchor.center,
      ),
    );

    // WiFi icon (glitched - red/warning)
    add(
      TextComponent(
        text: '⚠️',
        textRenderer: TextPaint(
          style: TextStyle(color: Color(0xFFFF3333), fontSize: 36),
        ),
        position: Vector2(screenWidth - 150, 40),
        anchor: Anchor.center,
      ),
    );

    // Battery icon (warning)
    add(
      TextComponent(
        text: '🔋',
        textRenderer: TextPaint(
          style: TextStyle(color: Color(0xFFFF3333), fontSize: 36),
        ),
        position: Vector2(screenWidth - 80, 40),
        anchor: Anchor.center,
      ),
    );
  }

  void _addWarningBanner(double screenWidth) {
    // Warning background bar
    final warningBar = RectangleComponent(
      size: Vector2(screenWidth, 100),
      position: Vector2(0, 100),
      paint: Paint()..color = Color(0xFFFF0000).withOpacity(0.2),
    );
    add(warningBar);

    // Warning icon
    final warningIcon = TextComponent(
      text: '⚠',
      textRenderer: TextPaint(
        style: TextStyle(
          color: Color(0xFFFF0000),
          fontSize: 48,
          fontWeight: FontWeight.bold,
        ),
      ),
      position: Vector2(screenWidth / 2 - 550, 140),
      anchor: Anchor.center,
    );
    add(warningIcon);

    // Warning text
    final warningText = TextComponent(
      text: 'SYSTEM BREACH - Unauthorized Access Detected',
      textRenderer: TextPaint(
        style: TextStyle(
          color: Color(0xFFFF0000),
          fontSize: 40,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
      ),
      position: Vector2(screenWidth / 2 + 50, 140),
      anchor: Anchor.center,
    );
    add(warningText);

    // Add flashing effect to warning text
    bool isVisible = true;
    add(
      TimerComponent(
        period: 0.6,
        repeat: true,
        onTick: () {
          isVisible = !isVisible;
          final newOpacity = isVisible ? 1.0 : 0.3;

          final textPaint = warningText.textRenderer;
          warningText.textRenderer = TextPaint(
            style: textPaint.style.copyWith(
              color: Color(0xFFFF0000).withOpacity(newOpacity),
            ),
          );

          // Also flash the icon
          final iconPaint = warningIcon.textRenderer;
          warningIcon.textRenderer = TextPaint(
            style: iconPaint.style.copyWith(
              color: Color(0xFFFF0000).withOpacity(newOpacity),
            ),
          );

          // Flash the bar background
          warningBar.paint.color = Color(
            0xFFFF0000,
          ).withOpacity(newOpacity * 0.3);
        },
      ),
    );
  }

  Future<void> _addHackedAppGrid(
    double screenWidth,
    double screenHeight,
  ) async {
    // App configuration with blackout icons
    final apps = [
      // Row 1
      {
        'name': 'Mail',
        'icon': 'phase0_icons/mail_blackout.png',
        'active': false,
      },
      {
        'name': 'Chat',
        'icon': 'phase0_icons/chat_blackout.png',
        'active': false,
      },
      {
        'name': 'Contacts',
        'icon': 'phase0_icons/contacts_blackout.png',
        'active': false,
      },
      {'name': 'EPD', 'icon': 'phase0_icons/epd_blackout.png', 'active': false},
      // Row 2
      {
        'name': 'Docs',
        'icon': 'phase0_icons/docs_blackout.png',
        'active': false,
      },
      {
        'name': 'Power',
        'icon': 'phase0_icons/power_blackout.png',
        'active': true,
      }, // Only this one is active
      {
        'name': 'Network\nDashboard',
        'icon': 'phase0_icons/network_blackout.png',
        'active': false,
      },
      {
        'name': 'Pager',
        'icon': 'phase0_icons/pager_blackout.png',
        'active': false,
      },
    ];

    final iconSize = 200.0;
    final iconSpacing = 100.0;

    // Calculate grid positioning
    final gridWidth = (iconSize * 4) + (iconSpacing * 3);
    final gridHeight = (iconSize * 2) + (iconSpacing * 1) + 140;
    final startX = (screenWidth - gridWidth) / 2;
    final startY = (screenHeight - gridHeight) / 2 + 100;

    appIcons = [];

    for (int i = 0; i < apps.length; i++) {
      final row = i ~/ 4;
      final col = i % 4;

      final x = startX + (col * (iconSize + iconSpacing));
      final y = startY + (row * (iconSize + iconSpacing + 140));

      final app = apps[i];
      final icon = _HackedAppIcon(
        position: Vector2(x, y),
        size: iconSize,
        appName: app['name'] as String,
        iconAsset: app['icon'] as String,
        isActive: app['active'] as bool,
      );

      appIcons.add(icon);
      add(icon);
    }
  }

  Future<void> _startHackSequence() async {
    if (isTransitioning) return;
    isTransitioning = true;

    // Step 1: Flicker effect (rapid color changes)
    await _flickerEffect();

    // Step 2: Glitch the hospital logo
    _glitchLogo();

    // Step 3: Show hacker silhouette with message
    await _showHackerIntro();

    // Step 4: Transform icons to glitched versions (already loaded)
    // Step 5: Make Power App pulse
    _activatePowerApp();
  }

  Future<void> _flickerEffect() async {
    // Create rapid flicker by changing background opacity
    for (int i = 0; i < 8; i++) {
      background.paint.color = Color(0xFFFFFFFF);
      await Future.delayed(Duration(milliseconds: 50));
      background.paint.color = Color(0xFF0A0A0A);
      await Future.delayed(Duration(milliseconds: 100));
    }
  }

  void _glitchLogo() {
    // Add shake/vibrate effect to hospital logo
    hospitalLogo.add(
      MoveEffect.by(
        Vector2(10, 0),
        EffectController(duration: 0.05, reverseDuration: 0.05, infinite: true),
      ),
    );

    // Add color glitch effect
    int glitchCount = 0;
    add(
      TimerComponent(
        period: 0.2,
        repeat: true,
        onTick: () {
          glitchCount++;
          if (glitchCount > 10) {
            hospitalLogo.removeAll(
              hospitalLogo.children.whereType<MoveEffect>(),
            );
          } else {
            final colors = [
              Color(0xFF8EC4BB),
              Color(0xFFFF3333),
              Color(0xFF00FF00),
              Color(0xFF8EC4BB),
            ];
            final style = hospitalLogo.textRenderer as TextPaint;
            hospitalLogo.textRenderer = TextPaint(
              style: style.style.copyWith(
                color: colors[glitchCount % colors.length],
              ),
            );
          }
        },
      ),
    );
  }

  Future<void> _showHackerIntro() async {
    final screenWidth = 1920.0;
    final screenHeight = 1080.0;

    // Semi-transparent dark overlay
    final overlay = RectangleComponent(
      size: Vector2(screenWidth, screenHeight),
      position: Vector2(0, 0),
      paint: Paint()..color = Color(0xEE000000),
    );
    add(overlay);

    // Hacker silhouette
    final hackerImage = SpriteComponent(
      sprite: Sprite(game.images.fromCache('hacker.png')),
      size: Vector2(400, 400),
      position: Vector2(screenWidth / 2, screenHeight / 2 - 80),
      anchor: Anchor.center,
    );
    add(hackerImage);

    // Hacker message
    final hackerMessage = TextComponent(
      text: 'Your systems are mine.\nTry to stop me…',
      textRenderer: TextPaint(
        style: TextStyle(
          color: Color(0xFF00FF00),
          fontSize: 64,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
      ),
      position: Vector2(screenWidth / 2, screenHeight / 2 + 280),
      anchor: Anchor.center,
    );
    add(hackerMessage);

    // Wait for dramatic effect (show for 3 seconds)
    await Future.delayed(Duration(milliseconds: 3000));

    // Remove all intro elements with a fade-out effect using opacity on paint
    _fadeOutAndRemove(overlay, 0.8);
    _fadeOutAndRemove(hackerImage, 0.8);
    _fadeOutAndRemove(hackerMessage, 0.8);

    // Wait for fade out to complete before continuing
    await Future.delayed(Duration(milliseconds: 800));
  }

  void _fadeOutAndRemove(PositionComponent component, double duration) {
    final steps = 20;
    final stepDuration = duration / steps;
    int currentStep = 0;

    add(
      TimerComponent(
        period: stepDuration,
        repeat: true,
        onTick: () {
          currentStep++;
          final opacity = (1.0 - (currentStep / steps)).clamp(0.0, 1.0);

          if (component is SpriteComponent) {
            component.paint.color = Color.fromRGBO(
              255,
              255,
              255,
              opacity.clamp(0.0, 1.0),
            );
          } else if (component is RectangleComponent) {
            final currentColor = component.paint.color;
            component.paint.color = currentColor.withOpacity(opacity);
          } else if (component is TextComponent) {
            final textPaint = component.textRenderer as TextPaint;
            final style = textPaint.style;
            component.textRenderer = TextPaint(
              style: style.copyWith(color: style.color?.withOpacity(opacity)),
            );
          }

          if (currentStep >= steps) {
            component.removeFromParent();
          }
        },
      ),
    );
  }

  void _activatePowerApp() {
    // Find and activate the Power App (index 5)
    if (appIcons.length > 5) {
      appIcons[5].startPulsing();
    }
  }
}

// Custom component for hacked app icons
class _HackedAppIcon extends PositionComponent
    with TapCallbacks, HasGameReference<HackGame> {
  final String appName;
  final String iconAsset;
  final bool isActive;
  late final double iconSize;

  _HackedAppIcon({
    required Vector2 position,
    required double size,
    required this.appName,
    required this.iconAsset,
    required this.isActive,
  }) : iconSize = size,
       super(position: position, size: Vector2(size, size + 120));

  @override
  Future<void> onLoad() async {
    // Dark icon container
    add(
      _DarkRoundedIconContainer(
        position: Vector2.zero(),
        size: Vector2(iconSize, iconSize),
        borderRadius: 24,
        isActive: isActive,
      ),
    );

    // Icon sprite
    try {
      final iconSprite = SpriteComponent(
        sprite: Sprite(game.images.fromCache(iconAsset)),
        size: Vector2(iconSize * 0.6, iconSize * 0.6),
        position: Vector2(iconSize * 0.2, iconSize * 0.2),
      );
      add(iconSprite);
    } catch (e) {
      // Fallback
      print('Error loading icon: $iconAsset');
    }

    // App name label
    final label = TextComponent(
      text: appName,
      textRenderer: TextPaint(
        style: TextStyle(
          color: isActive ? Color(0xFFFF0000) : Color(0xFF666666),
          fontSize: 32,
          fontWeight: FontWeight.w500,
        ),
      ),
      position: Vector2(iconSize / 2, iconSize + 20),
      anchor: Anchor.topCenter,
    );
    add(label);

    // Add transparent tap area to ensure taps are captured
    final tapArea = RectangleComponent(
      size: size,
      position: Vector2.zero(),
      paint: Paint()..color = Colors.transparent,
    );
    add(tapArea);

    // Store label reference if active for pulsing
    if (isActive) {
      bool labelVisible = true;
      add(
        TimerComponent(
          period: 0.8,
          repeat: true,
          onTick: () {
            labelVisible = !labelVisible;
            final newOpacity = labelVisible ? 1.0 : 0.4;
            final textPaint = label.textRenderer;
            label.textRenderer = TextPaint(
              style: textPaint.style.copyWith(
                color: Color(0xFFFF0000).withOpacity(newOpacity),
              ),
            );
          },
        ),
      );
    }
  }

  void startPulsing() {
    // Add pulsing glow effect
    final container = children.whereType<_DarkRoundedIconContainer>().first;
    container.add(
      ScaleEffect.by(
        Vector2.all(1.15),
        EffectController(duration: 0.8, reverseDuration: 0.8, infinite: true),
      ),
    );

    // Add pulsing to icon glow
    container.startGlowPulse();
  }

  @override
  bool containsLocalPoint(Vector2 point) {
    return size.toRect().contains(point.toOffset());
  }

  @override
  void onTapDown(TapDownEvent event) {
    print('Tapped $appName - isActive: $isActive');
    if (isActive) {
      // Power App tapped - transition to Power Dashboard
      print('Power App activated! Transitioning to dashboard...');
      print('Current world: ${game.cam.world}');
      print('PowerDashboard: ${game.powerDashboard}');
      print('PowerDashboard isMounted: ${game.powerDashboard.isMounted}');

      // Use Future to ensure the transition happens
      Future.microtask(() {
        game.cam.world = game.powerDashboard;
        print('World changed to: ${game.cam.world}');
      });
    }
  }
}

// Dark rounded icon container for hacked state
class _DarkRoundedIconContainer extends PositionComponent {
  final double borderRadius;
  final bool isActive;
  double glowIntensity = 1.0;

  _DarkRoundedIconContainer({
    required Vector2 size,
    required Vector2 position,
    required this.borderRadius,
    required this.isActive,
  }) : super(size: size, position: position);

  void startGlowPulse() {
    // Pulse the glow intensity
    add(
      TimerComponent(
        period: 0.05,
        repeat: true,
        onTick: () {
          glowIntensity =
              0.5 +
              (0.5 * ((DateTime.now().millisecondsSinceEpoch % 1600) / 1600));
        },
      ),
    );
  }

  @override
  void render(Canvas canvas) {
    final bgPaint = Paint()
      ..color = Color(0xFF1A1A1A)
      ..style = PaintingStyle.fill;

    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size.toSize(),
      Radius.circular(borderRadius),
    );

    // Draw background
    canvas.drawRRect(rrect, bgPaint);

    // Draw neon border if active (RED instead of green)
    if (isActive) {
      final borderPaint = Paint()
        ..color = Color(0xFFFF0000)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4;

      canvas.drawRRect(rrect, borderPaint);

      // Add pulsing red glow effect
      final glowOpacity = (0x66 * glowIntensity).toInt();
      final glowPaint = Paint()
        ..color = Color.fromRGBO(255, 0, 0, glowOpacity / 255)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 12
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 16 * glowIntensity);

      canvas.drawRRect(rrect, glowPaint);

      // Add outer glow
      final outerGlowPaint = Paint()
        ..color = Color.fromRGBO(255, 0, 0, (glowOpacity / 2) / 255)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 20
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 24 * glowIntensity);

      canvas.drawRRect(rrect, outerGlowPaint);
    }
  }
}
