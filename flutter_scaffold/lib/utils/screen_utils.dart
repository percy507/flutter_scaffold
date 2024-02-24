import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:myapp/config/config.dart';

class ScreenUtils {
  factory ScreenUtils() => _instance;
  ScreenUtils._internal();

  static final _instance = ScreenUtils._internal();

  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double dpr;
  static double px;

  /// 初始化屏幕适配工具
  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    dpr = window.devicePixelRatio;
    px = screenWidth / Config.designWidth;
  }

  static double setPx(double size) {
    return ScreenUtils.px * size;
  }
}

/// 使用px单位
/// eg: 120.px
extension SizeExtensionInt on double {
  double get px => ScreenUtils.setPx(this);
}
