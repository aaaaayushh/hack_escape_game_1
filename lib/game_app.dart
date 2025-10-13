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
        backgroundColor: Colors.red,
        body: SafeArea(
          child: FittedBox(
            child: SizedBox(
              width: 1920,
              height: 1080,
              child: Center(
                child: GameWidget(
                  game: _game,
                  overlayBuilderMap: {
                    'textInput': (context, game) =>
                        _TextInputOverlay(game: _game),
                  },
                ),
              ),
            ),
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
    // Get the screen dimensions - game is 1920x1080
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
          child: FittedBox(
            child: SizedBox(
              width: 1920,
              height: 1080,
              child: Stack(
                children: [
                  Positioned(
                    left: (1920 - inputBoxWidth) / 2,
                    top: _calculateInputBoxY(),
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
            ),
          ),
        ),
      ),
    );
  }

  double _calculateInputBoxY() {
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

    final startY = (1080 - totalHeight) / 2;
    final logoBoxY = startY;
    final companyLoginTextY =
        logoBoxY + logoBoxHeight + spaceBetweenLogoAndText;
    final inputBoxYPosition =
        companyLoginTextY + 36.0 / 2 + spaceBetweenTextAndInput;

    return inputBoxYPosition;
  }
}
