import 'package:flutter/material.dart';
import 'package:myapp/config/route.dart';

class NavigatorUtils {
  /// only use in MaterialApp navigatorKey property
  static final navigatorKey = GlobalKey<NavigatorState>();

  /// export MaterialApp context as [Global Context]
  static BuildContext get context => navigatorKey.currentContext;

  /// 前往首页
  static void gotoHomePage() {
    Navigator.of(context).pushReplacementNamed(RouteName.home);
  }

  /// 前往登录页
  static void gotoLoginPage() {
    Navigator.of(context).pushNamed(RouteName.login);
  }

  /// 前往协议页
  static void gotoAgreementPage({
    @required String title,
    @required String agreementPath,
  }) {
    Navigator.of(context).pushNamed(
      RouteName.agreement,
      arguments: {
        'title': title,
        'agreementPath': agreementPath,
      },
    );
  }
}
