import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:myapp/ui/widgets/route_builders.dart';
import 'package:myapp/ui/pages/home/home.dart';
import 'package:myapp/ui/pages/splash.dart';
import 'package:myapp/ui/pages/agreement.dart';

class RouteName {
  static const String splash = 'splash';
  static const String guide = 'guide';
  static const String home = '/';
  static const String agreement = 'agreement';
  static const String login = 'login';
  static const String register = 'register';
  static const String setting = 'setting';
}

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.splash:
        return NoAnimRouteBuilder(SplashPage());
      case RouteName.guide:
        return NoAnimRouteBuilder(GuidePage());
      case RouteName.home:
        return NoAnimRouteBuilder(HomePage());
      case RouteName.agreement:
        {
          final Map<String, String> args = settings.arguments as Map<String, String>;

          return CupertinoPageRoute<dynamic>(
            builder: (_) => AgreementPage(
              title: args['title'],
              agreementPath: args['agreementPath'],
            ),
          );
        }
      // case RouteName.login:
      //   return CupertinoPageRoute(fullscreenDialog: true, builder: (_) => LoginPage());
      // case RouteName.register:
      //   return CupertinoPageRoute(builder: (_) => RegisterPage());
      // case RouteName.setting:
      //   return CupertinoPageRoute(builder: (_) => SettingPage());
      default:
        return CupertinoPageRoute<dynamic>(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
