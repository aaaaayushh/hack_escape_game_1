import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:hack_game/hack_game.dart';
import 'package:hack_game/components/ui/fadable_rectangle.dart';
import 'package:hack_game/ui/constants.dart';

class LoadingScreen extends World with HasGameReference<HackGame> {
  LoadingScreen();

  late TextComponent companyLoginText;
  late _InputBoxComponent inputBox;
  late _ContinueButton continueButton;

  void updateInputText(String text) {
    inputBox.updateText(text);
  }

  void unfocusInput() {
    inputBox.unfocus();
  }

  @override
  Future<void> onLoad() async {
    final screenWidth = game.size.x;
    final screenHeight = game.size.y;

    // Add background image (same as splash screen)
    final background = SpriteComponent(
      sprite: Sprite(game.images.fromCache('splash_background.png')),
      size: Vector2(screenWidth, screenHeight),
      position: Vector2(0, 0),
    );
    add(background);

    // Logo dimensions
    final logoWidth = 400.0;
    final logoHeight = 400.0;
    final logoBoxPadding = 40.0;
    final logoBoxWidth = logoWidth + logoBoxPadding * 2;
    final logoBoxHeight = logoHeight + logoBoxPadding * 2;

    // Element spacing
    final spaceBetweenLogoAndText = 80.0;
    final spaceBetweenTextAndInput = 70.0;
    final inputBoxWidth = 600.0;
    final inputBoxHeight = 80.0;
    final spaceBetweenInputAndButton = 40.0;
    final buttonWidth = 300.0;
    final buttonHeight = 60.0;

    // Calculate total height of all elements
    final totalHeight =
        logoBoxHeight +
        spaceBetweenLogoAndText +
        36.0 + // Company Login text height (approximate)
        spaceBetweenTextAndInput +
        inputBoxHeight +
        spaceBetweenInputAndButton +
        buttonHeight;

    // Center everything vertically
    final startY = (screenHeight - totalHeight) / 2;

    // Logo box position
    final logoBoxY = startY;

    // Create semi-transparent box behind logo (same as splash screen)
    final logoBoxRect = FadableRectangle(
      position: Vector2((screenWidth - logoBoxWidth) / 2, logoBoxY),
      size: Vector2(logoBoxWidth, logoBoxHeight),
      color: const Color(0x990F1F30),
      isFilled: true,
    );

    // Create outline for the logo box
    final logoBoxOutline = FadableRectangle(
      position: Vector2((screenWidth - logoBoxWidth) / 2, logoBoxY),
      size: Vector2(logoBoxWidth, logoBoxHeight),
      color: UiColors.brandTeal,
      isFilled: false,
      strokeWidth: 3.0,
    );

    // Add logo image
    final logo = SpriteComponent(
      sprite: Sprite(game.images.fromCache('escape_the hack_logo.png')),
      size: Vector2(logoWidth, logoHeight),
      position: Vector2(
        (screenWidth - logoWidth) / 2,
        logoBoxY + logoBoxPadding,
      ),
    );

    add(logoBoxRect);
    add(logoBoxOutline);
    add(logo);

    // "Company Login" text
    final companyLoginTextY =
        logoBoxY + logoBoxHeight + spaceBetweenLogoAndText;
    companyLoginText = TextComponent(
      text: 'Company Login',
      textRenderer: TextPaint(
        style: TextStyle(
          color: UiColors.brandTeal,
          fontSize: 36,
          fontWeight: FontWeight.bold,
          fontFamily: UiFonts.monoPrimary,
          fontFamilyFallback: UiFonts.monoFallback,
        ),
      ),
      position: Vector2(screenWidth / 2, companyLoginTextY),
      anchor: Anchor.center,
    );
    add(companyLoginText);

    // Input box for company code
    final inputBoxYPosition =
        companyLoginTextY + 36.0 / 2 + spaceBetweenTextAndInput;

    inputBox = _InputBoxComponent(
      position: Vector2((screenWidth - inputBoxWidth) / 2, inputBoxYPosition),
      size: Vector2(inputBoxWidth, inputBoxHeight),
      game: game,
    );
    add(inputBox);

    // Continue button
    final buttonYPosition =
        inputBoxYPosition + inputBoxHeight + spaceBetweenInputAndButton;

    continueButton = _ContinueButton(
      position: Vector2((screenWidth - buttonWidth) / 2, buttonYPosition),
      size: Vector2(buttonWidth, buttonHeight),
      onPressed: () {
        // Get the company name from input box and proceed
        game.companyName = inputBox.text.trim().isNotEmpty
            ? inputBox.text.trim()
            : 'Company Name';

        // Switch camera to phaseZero (calm hospital interface)
        game.cam.world = game.phaseZero;
        // Start the sequence for phase zero
        game.phaseZero.startSequence();
      },
    );
    add(continueButton);
  }
}

// _FadableRectangle removed in favor of shared FadableRectangle component

class _InputBoxComponent extends PositionComponent with TapCallbacks {
  final HackGame game;
  String text = '';
  bool isFocused = false;

  _InputBoxComponent({
    required Vector2 position,
    required Vector2 size,
    required this.game,
  }) : super(position: position, size: size);

  @override
  void onTapDown(TapDownEvent event) {
    isFocused = true;
    _showTextInputOverlay();
  }

  void _showTextInputOverlay() {
    final overlay = game.overlays;
    if (!overlay.isActive('textInput')) {
      overlay.add('textInput');
    }
  }

  void updateText(String newText) {
    text = newText;
  }

  void unfocus() {
    isFocused = false;
  }

  @override
  void render(Canvas canvas) {
    // Draw the box background (same style as logo box)
    final bgPaint = Paint()
      ..color =
          Color(0x990F1F30) // 60% opacity
      ..style = PaintingStyle.fill;
    canvas.drawRect(size.toRect(), bgPaint);

    // Draw the box outline
    final outlinePaint = Paint()
      ..color = Color(0xFF6DC5D9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
    canvas.drawRect(size.toRect(), outlinePaint);

    // Only draw the text if the overlay is not active (to prevent text doubling)
    if (!game.overlays.isActive('textInput')) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: text.isEmpty ? 'Enter company code...' : text,
          style: TextStyle(
            color: text.isEmpty ? Color(0x806DC5D9) : Color(0xFF6DC5D9),
            fontSize: 28,
            fontFamily: 'Consolas',
            fontFamilyFallback: ['Courier New', 'monospace'],
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(20, (size.y - textPainter.height) / 2));
    }
  }
}

class _ContinueButton extends PositionComponent
    with TapCallbacks, HoverCallbacks {
  final VoidCallback onPressed;
  bool isHovered = false;

  _ContinueButton({
    required Vector2 position,
    required Vector2 size,
    required this.onPressed,
  }) : super(position: position, size: size);

  @override
  void onTapDown(TapDownEvent event) {
    onPressed();
  }

  @override
  void onHoverEnter() {
    isHovered = true;
  }

  @override
  void onHoverExit() {
    isHovered = false;
  }

  @override
  void render(Canvas canvas) {
    // Draw button background with 80% opacity
    final bgPaint = Paint()
      ..color =
          Color(0xCC6DC5D9) // 80% opacity (CC = 80% of FF)
      ..style = PaintingStyle.fill;

    // Slightly lighter when hovered
    if (isHovered) {
      bgPaint.color = Color(0xE66DC5D9); // 90% opacity when hovered
    }

    canvas.drawRect(size.toRect(), bgPaint);

    // Draw the text "Continue"
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'Continue',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontFamily: 'Consolas',
          fontFamilyFallback: ['Courier New', 'monospace'],
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (size.x - textPainter.width) / 2,
        (size.y - textPainter.height) / 2,
      ),
    );
  }
}
