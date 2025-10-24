import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:hack_game/hack_game.dart';

class GameApp extends StatefulWidget {
  const GameApp({super.key});

  @override
  State<GameApp> createState() => _GameAppState();
}

class _GameAppState extends State<GameApp> {
  late final HackGame _game;

  @override
  void initState() {
    super.initState();
    _game = HackGame();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Calculate the aspect ratio and scale accordingly
              final screenWidth = constraints.maxWidth;
              final screenHeight = constraints.maxHeight;
              final gameAspectRatio = 1920.0 / 1080.0;
              final screenAspectRatio = screenWidth / screenHeight;

              double gameWidth, gameHeight;
              if (screenAspectRatio > gameAspectRatio) {
                // Screen is wider than game - fit to height
                gameHeight = screenHeight;
                gameWidth = screenHeight * gameAspectRatio;
              } else {
                // Screen is taller than game - fit to width
                gameWidth = screenWidth;
                gameHeight = screenWidth / gameAspectRatio;
              }

              return Center(
                child: SizedBox(
                  width: gameWidth,
                  height: gameHeight,
                  child: GameWidget(
                    game: _game,
                    overlayBuilderMap: {
                      'textInput': (context, game) =>
                          _TextInputOverlay(game: _game),
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _TextInputOverlay extends StatefulWidget {
  final HackGame game;

  const _TextInputOverlay({required this.game});

  @override
  State<_TextInputOverlay> createState() => _TextInputOverlayState();
}

class _TextInputOverlayState extends State<_TextInputOverlay> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Set the initial text from the current input box value
    _controller.text = widget.game.loadingScreen.inputBox.text;
    // Auto-focus the text field when overlay appears
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen dimensions - responsive to actual screen size
    // Input box dimensions from loading_screen.dart
    final inputBoxWidth = 600.0;
    final inputBoxHeight = 80.0;

    return GestureDetector(
      onTap: () {
        // Close overlay when tapping outside
        final inputText = _controller.text.trim();
        if (inputText.isNotEmpty) {
          widget.game.loadingScreen.updateInputText(inputText);
        }
        widget.game.loadingScreen.unfocusInput();
        widget.game.overlays.remove('textInput');
      },
      child: Container(
        color: Colors.transparent,
        child: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final screenWidth = constraints.maxWidth;
              final screenHeight = constraints.maxHeight;
              final gameAspectRatio = 1920.0 / 1080.0;
              final screenAspectRatio = screenWidth / screenHeight;

              double gameWidth, gameHeight;
              if (screenAspectRatio > gameAspectRatio) {
                gameHeight = screenHeight;
                gameWidth = screenHeight * gameAspectRatio;
              } else {
                gameWidth = screenWidth;
                gameHeight = screenWidth / gameAspectRatio;
              }

              return SizedBox(
                width: gameWidth,
                height: gameHeight,
                child: Stack(
                  children: [
                    Positioned(
                      left: (gameWidth - inputBoxWidth) / 2,
                      top: _calculateInputBoxY(gameHeight),
                      width: inputBoxWidth,
                      height: inputBoxHeight,
                      child: GestureDetector(
                        onTap: () {}, // Prevent closing when clicking on input
                        child: TextField(
                          controller: _controller,
                          focusNode: _focusNode,
                          style: TextStyle(
                            color: Color(0xFF6DC5D9),
                            fontSize: 28,
                            fontFamily: 'Consolas',
                            fontFamilyFallback: ['Courier New', 'monospace'],
                          ),
                          decoration: InputDecoration(
                            hintText: 'Enter company code...',
                            hintStyle: TextStyle(
                              color: Color(0x806DC5D9),
                              fontSize: 28,
                              fontFamily: 'Consolas',
                              fontFamilyFallback: ['Courier New', 'monospace'],
                            ),
                            filled: true,
                            fillColor: Colors.transparent,
                            contentPadding: EdgeInsets.only(left: 20, top: 20),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                          onChanged: (value) {
                            widget.game.loadingScreen.updateInputText(value);
                          },
                          onSubmitted: (value) {
                            final inputText = _controller.text.trim();
                            if (inputText.isNotEmpty) {
                              widget.game.loadingScreen.updateInputText(
                                inputText,
                              );
                            }
                            widget.game.loadingScreen.unfocusInput();
                            widget.game.overlays.remove('textInput');
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  double _calculateInputBoxY(double gameHeight) {
    // These values match loading_screen.dart calculations
    final logoBoxHeight = 480.0; // 400 + 40*2
    final spaceBetweenLogoAndText = 80.0;
    final spaceBetweenTextAndInput = 70.0;
    final inputBoxHeight = 80.0;
    final spaceBetweenInputAndButton = 40.0;
    final buttonHeight = 60.0;

    final totalHeight =
        logoBoxHeight +
        spaceBetweenLogoAndText +
        36.0 +
        spaceBetweenTextAndInput +
        inputBoxHeight +
        spaceBetweenInputAndButton +
        buttonHeight;

    final startY = (gameHeight - totalHeight) / 2;
    final logoBoxY = startY;
    final companyLoginTextY =
        logoBoxY + logoBoxHeight + spaceBetweenLogoAndText;
    final inputBoxYPosition =
        companyLoginTextY + 36.0 / 2 + spaceBetweenTextAndInput;

    return inputBoxYPosition;
  }
}
