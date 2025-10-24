import 'package:flutter/material.dart';

// Centralized UI constants used across Flame worlds/components
class UiColors {
  static const Color brandTeal = Color(0xFF6DC5D9);
  static const Color bgDark = Color(0xFF0A0A0A);
  static const Color bgLight = Color(0xFFF5F5F5);
  static const Color warnRed = Color(0xFFFF0000);
  static const Color warnOrange = Color(0xFFFF8C42);
}

class UiFonts {
  // Prefer system mono with reasonable fallbacks unless bundled fonts are added
  static const String? monoPrimary = null; // use default
  static const List<String> monoFallback = [
    'Consolas',
    'Courier New',
    'monospace',
  ];
}

class OverlayKeys {
  static const String textInput = 'textInput';
}

class UiDims {
  static const double statusBarY = 45.0;
  static const double bannerHeight = 60.0;
}
