import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:hack_game/hack_game.dart';
import 'package:hack_game/components/ui/status_bar.dart';
import 'package:hack_game/components/ui/ios_notification.dart';

class PhaseZero extends World with HasGameReference<HackGame>, TapCallbacks {
  PhaseZero();
  bool hasTransitioned = false;
  bool hasStarted = false;
  late TextComponent companyNameText;

  @override
  Future<void> onLoad() async {
    final screenWidth = game.size.x;
    final screenHeight = game.size.y;

    // Background image
    add(
      SpriteComponent(
        sprite: Sprite(game.images.fromCache('background_basescreen.png')),
        size: Vector2(screenWidth, screenHeight),
        position: Vector2(0, 0),
      ),
    );

    // Status bar at top
    add(
      StatusBar(
        screenWidth: screenWidth,
        y: 45,
        timeColor: const Color(0xFFFFFFFF),
        centerTime: false,
        showWifiBattery: true,
      ),
    );

    // Prepare company name for later update (not shown on this screen)
    companyNameText = TextComponent(text: '');

    // Left-side info panels (static images for now)
    _addLeftInfoPanels(screenWidth, screenHeight);

    // App grid - 2 rows, 4 columns, aligned to the right
    _addAppGrid(screenWidth, screenHeight);
  }

  void startSequence() {
    if (hasStarted) return;
    hasStarted = true;

    // Update the company name text with the value entered by user
    companyNameText.text = game.companyName;

    // Show notifications before transition
    _showNotifications();

    // Trigger hack transition after notifications
    add(
      TimerComponent(
        period: 8.0,
        repeat: false,
        onTick: () {
          if (!hasTransitioned) {
            _triggerHackTransition();
          }
        },
      ),
    );
  }

  void _triggerHackTransition() {
    hasTransitioned = true;
    // Transition to splash screen, which will then go to phase one
    game.cam.world = game.splashScreen;
    game.splashScreen.prepareForTransitionToPhaseOne();
  }

  void _showNotifications() {
    final screenWidth = game.size.x;
    final notificationWidth = 900.0;
    final notificationHeight = 140.0;
    final startY = 100.0;
    final spacing = 20.0;

    // Notification 1: Technical Services - System Alert
    final notification1 = IOSNotification(
      position: Vector2(
        (screenWidth - notificationWidth) / 2,
        -notificationHeight,
      ),
      size: Vector2(notificationWidth, notificationHeight),
      title: 'Technical Services - System Alert',
      message:
          'Network latency detected in several hospital systems. IT is investigating possible connection issues.',
      timeLabel: 'now',
      accentColor: const Color(0xFF007AFF),
      iconEmoji: '💻',
      backgroundColor: const Color(0xEEF5F5F5),
      titleColor: const Color(0xFF1A1A1A),
      messageColor: const Color(0xFF666666),
    );
    add(notification1);

    // Animate notification 1 sliding down
    notification1.add(
      MoveEffect.to(
        Vector2((screenWidth - notificationWidth) / 2, startY),
        EffectController(duration: 0.5, curve: Curves.easeOut),
      ),
    );

    // Notification 2: Security threat emerging (delayed)
    add(
      TimerComponent(
        period: 1.5,
        repeat: false,
        onTick: () {
          final notification2 = IOSNotification(
            position: Vector2(
              (screenWidth - notificationWidth) / 2,
              -notificationHeight,
            ),
            size: Vector2(notificationWidth, notificationHeight),
            title: 'Security threat emerging',
            message:
                "We're receiving unusual login attempts to your account. Please check your verification.",
            timeLabel: 'now',
            accentColor: const Color(0xFF007AFF),
            iconEmoji: '✉',
            backgroundColor: const Color(0xEEF5F5F5),
            titleColor: const Color(0xFF1A1A1A),
            messageColor: const Color(0xFF666666),
          );
          add(notification2);

          notification2.add(
            MoveEffect.to(
              Vector2(
                (screenWidth - notificationWidth) / 2,
                startY + notificationHeight + spacing,
              ),
              EffectController(duration: 0.5, curve: Curves.easeOut),
            ),
          );

          // Notification 3: MedNews24 - Live Update (delayed further)
          add(
            TimerComponent(
              period: 1.5,
              repeat: false,
              onTick: () {
                final notification3 = IOSNotification(
                  position: Vector2(
                    (screenWidth - notificationWidth) / 2,
                    -notificationHeight,
                  ),
                  size: Vector2(notificationWidth, notificationHeight),
                  title: 'MedNews24 - Live Update',
                  message:
                      'Breaking: Hospitals in the region report temporary IT disruptions. No cause identified yet. Patient care is affected.',
                  timeLabel: 'now',
                  accentColor: const Color(0xFFFF3B30),
                  iconEmoji: '📰',
                  backgroundColor: const Color(0xEEF5F5F5),
                  titleColor: const Color(0xFF1A1A1A),
                  messageColor: const Color(0xFF666666),
                );
                add(notification3);

                notification3.add(
                  MoveEffect.to(
                    Vector2(
                      (screenWidth - notificationWidth) / 2,
                      startY + (notificationHeight + spacing) * 2,
                    ),
                    EffectController(duration: 0.5, curve: Curves.easeOut),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  // Legacy placeholder removed; StatusBar is added directly in onLoad

  void _addLeftInfoPanels(double screenWidth, double screenHeight) {
    // Sizes tuned to closely match the reference
    final leftPadding = 120.0;
    final topStart = 200.0;

    // Weather card
    // Reduced sizes to remove blur
    const weatherWidth = 560.0;
    const weatherHeight = 390.0;
    add(
      SpriteComponent(
        sprite: Sprite(game.images.fromCache('phase0_icons/weather.png')),
        size: Vector2(weatherWidth, weatherHeight),
        position: Vector2(leftPadding, topStart),
      ),
    );

    // Calendar card (static)
    const calendarWidth = weatherWidth;
    const calendarHeight = 220.0;
    const verticalGap = 28.0;
    add(
      SpriteComponent(
        sprite: Sprite(game.images.fromCache('phase0_icons/calendar.png')),
        size: Vector2(calendarWidth, calendarHeight),
        position: Vector2(leftPadding, topStart + weatherHeight + verticalGap),
      ),
    );
  }

  void _addAppGrid(double screenWidth, double screenHeight) {
    // App configuration
    final apps = [
      // Row 1
      {'name': 'Mail', 'icon': 'phase0_icons/mail.png'},
      {'name': 'Chat', 'icon': 'phase0_icons/chat.png'},
      {'name': 'Contacts', 'icon': 'phase0_icons/contacts.png'},
      {'name': 'EPD', 'icon': 'phase0_icons/epd.png'},
      // Row 2
      {'name': 'Docs', 'icon': 'phase0_icons/docs.png'},
      {'name': 'Power App', 'icon': 'phase0_icons/power.png'},
      {'name': 'Network\nDashboard', 'icon': 'phase0_icons/network.png'},
      {'name': 'Pager', 'icon': 'phase0_icons/pager.png'},
    ];

    // Reserve space for the left weather + calendar panels
    const leftPadding = 120.0;
    const weatherWidth = 560.0;
    const gapRightOfPanels = 100.0;
    const rightPadding = 140.0;

    final availableRightWidth =
        screenWidth -
        (leftPadding + weatherWidth + gapRightOfPanels) -
        rightPadding;

    // Compute icon size to fit 4 columns with spacing, with reasonable clamps
    const minIconSize = 150.0;
    const maxIconSize = 210.0;
    const iconSpacing = 76.0;
    final computedIconSize = (availableRightWidth - (3 * iconSpacing)) / 4.0;
    final iconSize = computedIconSize.clamp(minIconSize, maxIconSize);

    // Calculate grid positioning (flush-right within the available area)
    final gridWidth = (iconSize * 4) + (iconSpacing * 3);
    final startX = screenWidth - rightPadding - gridWidth;
    final gridHeight = (iconSize * 2) + iconSpacing + 120;
    final startY = ((screenHeight - gridHeight) / 2).clamp(
      140.0,
      double.infinity,
    );

    for (int i = 0; i < apps.length; i++) {
      final row = i ~/ 4;
      final col = i % 4;

      final x = startX + (col * (iconSize + iconSpacing));
      final y = startY + (row * (iconSize + iconSpacing + 60));

      // Create app icon container
      _addAppIcon(
        position: Vector2(x, y),
        size: iconSize,
        appName: apps[i]['name']!,
        iconAsset: apps[i]['icon']!,
      );
    }
  }

  void _addAppIcon({
    required Vector2 position,
    required double size,
    required String appName,
    required String iconAsset,
  }) {
    // Try to load icon image if available, otherwise show placeholder
    try {
      final iconSprite = SpriteComponent(
        sprite: Sprite(game.images.fromCache(iconAsset)),
        size: Vector2(size, size),
        position: position + Vector2(size / 2, size / 2),
        anchor: Anchor.center,
      );
      add(iconSprite);
    } catch (e) {
      // Placeholder icon (blue/grey circle)
      final placeholder = CircleComponent(
        radius: size * 0.3,
        position: position + Vector2(size / 2, size / 2),
        paint: Paint()..color = Color(0xFF5B9BD5),
        anchor: Anchor.center,
      );
      add(placeholder);

      // Add a simple icon letter in the center
      final iconLetter = appName.split('\n').first[0];
      add(
        TextComponent(
          text: iconLetter,
          textRenderer: TextPaint(
            style: TextStyle(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
          position: position + Vector2(size / 2, size / 2),
          anchor: Anchor.center,
        ),
      );
    }

    // App name label below icon
    add(
      TextComponent(
        text: appName,
        textRenderer: TextPaint(
          style: TextStyle(
            color: const Color(0xFF1A1A1A),
            fontSize: 32,
            fontWeight: FontWeight.w500,
          ),
        ),
        position: position + Vector2(size / 2, size + 20),
        anchor: Anchor.topCenter,
      ),
    );

    // Make icon tappable (for future interaction)
    final tapArea = RectangleComponent(
      size: Vector2(size, size + 120),
      position: position,
      paint: Paint()..color = Colors.transparent,
    );
    add(tapArea);
  }
}
