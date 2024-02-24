import 'package:flutter/material.dart';

class ThemeColorChangeEvent {
  ThemeColorChangeEvent(this.color);

  final Color color;
}

class AppFontChangeEvent {
  AppFontChangeEvent(this.fontName);

  final String fontName;
}
