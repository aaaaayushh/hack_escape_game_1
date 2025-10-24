import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:hack_game/hack_game.dart';
import 'package:hack_game/components/ui/warning_banner.dart';
import 'package:hack_game/components/ui/ios_notification.dart';
import 'package:hack_game/ui/constants.dart';

class PhaseOne extends World with HasGameReference<HackGame>, TapCallbacks {
  late SpriteComponent _background;
  late List<_HackedAppIcon> _appIcons;
  bool isTransitioning = false;
  bool hasStarted = false;

  PhaseOne();

  @override
  Future<void> onLoad() async {
    final screenWidth = game.size.x;
    final screenHeight = game.size.y;

    // Hacker background with binary code pattern
    _background = SpriteComponent(
      sprite: Sprite(
        game.images.fromCache('phase0_icons/hacker_background.png'),
      ),
      size: Vector2(screenWidth, screenHeight),
      position: Vector2(0, 0),
    );
    add(_background);

    // Status bar at top with cyan color scheme (fixed time to match image)
    add(
      _FixedTimeStatusBar(
        screenWidth: screenWidth,
        y: 45,
        timeColor: UiColors.brandTeal,
        centerTime: true,
        showWifiBattery: true,
      ),
    );

    // Add flashing warning banner
    add(
      WarningBanner(
        position: Vector2(0, 90),
        size: Vector2(screenWidth, 60),
        message: 'SYSTEM BREACH - Unauthorized Access Detected',
        color: UiColors.warnRed,
        flash: true,
      ),
    );

    // Left-side error panels (weather + calendar in error state)
    _addLeftErrorPanels(screenWidth, screenHeight);

    // Add hacked app grid on the right in a similar layout to Phase Zero
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

  // Legacy placeholder removed; StatusBar is added directly in onLoad

  // Legacy placeholder removed; WarningBanner is added directly in onLoad

  Future<void> _addHackedAppGrid(
    double screenWidth,
    double screenHeight,
  ) async {
    // App configuration matching the image layout (4x2 grid)
    final apps = [
      // Row 1
      {
        'name': 'Mail',
        'icon': 'phase0_icons/mail_blackout.png',
        'active': false,
      },
      {
        'name': 'Documents',
        'icon': 'phase0_icons/docs_blackout.png',
        'active': false,
      },
      {'name': 'EPD', 'icon': 'phase0_icons/epd_blackout.png', 'active': false},
      {
        'name': 'Network',
        'icon': 'phase0_icons/network_blackout.png',
        'active': false,
      },
      // Row 2
      {
        'name': 'Contacts',
        'icon': 'phase0_icons/contacts_blackout.png',
        'active': false,
      },
      {
        'name': 'Chat',
        'icon': 'phase0_icons/chat_blackout.png',
        'active': false,
      },
      {
        'name': 'Pager',
        'icon': 'phase0_icons/pager_blackout.png',
        'active': false,
      },
      {
        'name': 'Power',
        'icon': 'phase0_icons/power_blackout.png',
        'active': true,
      }, // Only this one is active
    ];

    // Fixed positioning for 4x2 grid layout
    const rightPadding = 140.0;

    // Fixed icon sizing for consistent 4x2 grid layout
    const iconSize = 160.0;
    const iconSpacing = 80.0;

    // Right-aligned grid
    final gridWidth = (iconSize * 4) + (iconSpacing * 3);
    final startX = screenWidth - rightPadding - gridWidth;
    final gridHeight = (iconSize * 2) + iconSpacing + 120;
    final startY = ((screenHeight - gridHeight) / 2).clamp(
      140.0,
      double.infinity,
    );

    _appIcons = [];

    for (int i = 0; i < apps.length; i++) {
      final row = i ~/ 4;
      final col = i % 4;

      final x = startX + (col * (iconSize + iconSpacing));
      final y = startY + (row * (iconSize + iconSpacing + 60));

      final app = apps[i];
      final icon = _HackedAppIcon(
        position: Vector2(x, y),
        size: iconSize,
        appName: app['name'] as String,
        iconAsset: app['icon'] as String,
        isActive: app['active'] as bool,
      );

      _appIcons.add(icon);
      add(icon);
    }
  }

  void _addLeftErrorPanels(double screenWidth, double screenHeight) {
    // Layout matches the image with afterhack assets
    final leftPadding = 120.0;
    final topStart = 180.0;

    const weatherWidth = 620.0;
    const weatherHeight = 430.0;
    const calendarWidth = weatherWidth;
    const calendarHeight = 260.0;
    const verticalGap = 36.0;

    // Weather error panel with afterhack asset
    final weatherPanel = SpriteComponent(
      sprite: Sprite(
        game.images.fromCache('phase0_icons/afterhack_weather.png'),
      ),
      size: Vector2(weatherWidth, weatherHeight),
      position: Vector2(leftPadding, topStart),
    );
    add(weatherPanel);

    // Calendar error panel with afterhack asset
    final calendarTop = topStart + weatherHeight + verticalGap;
    final calendarPanel = SpriteComponent(
      sprite: Sprite(
        game.images.fromCache('phase0_icons/afterhack_calendar.png'),
      ),
      size: Vector2(calendarWidth, calendarHeight),
      position: Vector2(leftPadding, calendarTop),
    );
    add(calendarPanel);
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
      _background.paint.color = UiColors.brandTeal; // Cyan flash
      await Future.delayed(Duration(milliseconds: 50));
      _background.paint.color = Color(0xFF0A0A0A); // Back to dark
      await Future.delayed(Duration(milliseconds: 100));
    }
  }

  void _glitchLogo() {
    // Logo removed - no longer needed for the new design
    // Keeping function for compatibility with hack sequence
  }

  Future<void> _showHackerIntro() async {
    final screenWidth = game.size.x;
    final screenHeight = game.size.y;

    // Semi-transparent dark overlay with cyan tint
    final overlay = RectangleComponent(
      size: Vector2(screenWidth, screenHeight),
      position: Vector2(0, 0),
      paint: Paint()..color = Color(0xEE0A0A0A),
    );
    add(overlay);

    // Hacker silhouette with cyan tint
    final hackerImage = SpriteComponent(
      sprite: Sprite(game.images.fromCache('escape_the hack_logo.png')),
      size: Vector2(700, 700),
      position: Vector2(screenWidth / 2, screenHeight / 2),
      anchor: Anchor.center,
      paint: Paint()
        ..colorFilter = ColorFilter.mode(
          UiColors.brandTeal,
          BlendMode.modulate,
        ),
    );
    add(hackerImage);

    // Wait for dramatic effect (show for 3 seconds)
    await Future.delayed(Duration(milliseconds: 3000));

    // Remove all intro elements with a fade-out effect using opacity on paint
    _fadeOutAndRemove(overlay, 0.8);
    _fadeOutAndRemove(hackerImage, 0.8);

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
            component.paint.color = UiColors.brandTeal.withValues(
              alpha: opacity.clamp(0.0, 1.0),
            );
          } else if (component is RectangleComponent) {
            final currentColor = component.paint.color;
            component.paint.color = currentColor.withValues(alpha: opacity);
          } else if (component is TextComponent) {
            final textPaint = component.textRenderer as TextPaint;
            final style = textPaint.style;
            component.textRenderer = TextPaint(
              style: style.copyWith(
                color: (style.color ?? UiColors.brandTeal).withValues(
                  alpha: opacity,
                ),
              ),
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
    // Show iOS notification instead of pulsing
    _showIOSNotification();
  }

  void _showIOSNotification() {
    final screenWidth = game.size.x;
    final notificationWidth = 800.0;
    final notificationHeight = 180.0;

    // Create notification container
    final notification = IOSNotification(
      position: Vector2(
        (screenWidth - notificationWidth) / 2,
        -notificationHeight,
      ),
      size: Vector2(notificationWidth, notificationHeight),
    );
    add(notification);

    // Animate notification sliding down
    notification.add(
      MoveEffect.to(
        Vector2((screenWidth - notificationWidth) / 2, 160),
        EffectController(duration: 0.5, curve: Curves.easeOut),
      ),
    );

    // Auto-dismiss after 8 seconds with slide up animation
    add(
      TimerComponent(
        period: 8.0,
        repeat: false,
        onTick: () {
          notification.add(
            MoveEffect.to(
              Vector2(
                (screenWidth - notificationWidth) / 2,
                -notificationHeight,
              ),
              EffectController(duration: 0.4, curve: Curves.easeIn),
              onComplete: () => notification.removeFromParent(),
            ),
          );
        },
      ),
    );
  }
}

// Legacy embedded component removed; using reusable IOSNotification component

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
        position: Vector2(iconSize / 2, iconSize / 2),
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
      // Fallback - icon loading failed
    }

    // App name label
    final label = TextComponent(
      text: appName,
      textRenderer: TextPaint(
        style: TextStyle(
          color: isActive ? UiColors.brandTeal : Color(0xFF666666),
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
                color: UiColors.brandTeal.withValues(alpha: newOpacity),
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
    if (isActive) {
      // Power App tapped - transition to Power Dashboard
      // Use Future to ensure the transition happens
      Future.microtask(() {
        game.cam.world = game.powerDashboard;
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
  }) : super(size: size, position: position, anchor: Anchor.center);

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
    // No border or glow since we're using notification instead
  }
}

// Status bar with fixed time to match the image
class _FixedTimeStatusBar extends PositionComponent
    with HasGameReference<HackGame> {
  final double screenWidth;
  @override
  final double y;
  final Color timeColor;
  final bool centerTime;
  final bool showWifiBattery;

  _FixedTimeStatusBar({
    required this.screenWidth,
    required this.y,
    required this.timeColor,
    this.centerTime = true,
    this.showWifiBattery = true,
  });

  @override
  Future<void> onLoad() async {
    const timeString = '8:41';

    final position = centerTime ? Vector2(screenWidth / 2, y) : Vector2(80, y);
    final anchor = centerTime ? Anchor.center : Anchor.centerLeft;

    final timeDisplay = TextComponent(
      text: timeString,
      textRenderer: TextPaint(
        style: TextStyle(
          color: timeColor,
          fontSize: 40,
          fontWeight: FontWeight.w500,
        ),
      ),
      position: position,
      anchor: anchor,
    );
    add(timeDisplay);

    if (showWifiBattery) {
      // Add connection icon (leftmost)
      add(
        SpriteComponent(
          sprite: Sprite(
            game.images.fromCache('phase0_icons/connection_white.png'),
          ),
          size: Vector2(36, 28),
          position: Vector2(screenWidth - 150, y),
          anchor: Anchor.center,
        ),
      );

      // Add WiFi icon (middle)
      add(
        SpriteComponent(
          sprite: Sprite(game.images.fromCache('phase0_icons/wifi_white.png')),
          size: Vector2(40, 32),
          position: Vector2(screenWidth - 90, y),
          anchor: Anchor.center,
        ),
      );

      // Add battery icon (rightmost)
      add(
        SpriteComponent(
          sprite: Sprite(
            game.images.fromCache('phase0_icons/battery_white.png'),
          ),
          size: Vector2(40, 24),
          position: Vector2(screenWidth - 35, y),
          anchor: Anchor.center,
        ),
      );
    }
  }
}
