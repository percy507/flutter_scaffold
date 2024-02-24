import 'package:flutter/material.dart';

enum EnvType {
  dev,
  prod,
}

// dev 环境配置
const devConfig = {
  'baseUrl': 'http://dev.api.com',
};

// prod 环境配置
const prodConfig = {
  'baseUrl': 'http://prod.api.com',
};

class AppConfig {
  factory AppConfig(Map<String, dynamic> config) {
    _instance.baseUrl = config['baseUrl'] as String;

    return _instance;
  }

  AppConfig._internal({this.baseUrl});

  static final AppConfig _instance = AppConfig._internal();

  String baseUrl;
}

class AppConfigWrapper extends StatelessWidget {
  AppConfigWrapper({
    @required this.envType,
    @required this.child,
  });

  final EnvType envType;
  final Widget child;

  static AppConfig of(BuildContext context) {
    final inheritedConfig = context.dependOnInheritedWidgetOfExactType<_InheritedConfig>();
    return inheritedConfig.config;
  }

  Map<String, dynamic> get config => envType == EnvType.dev
      ? devConfig
      : envType == EnvType.prod
          ? prodConfig
          : throw Exception('unknown envType: ${envType.toString()}');

  @override
  Widget build(BuildContext context) {
    print('AppConfigWrapper build: ${envType.toString()}');
    return _InheritedConfig(
      config: AppConfig(config),
      child: child,
    );
  }
}

class _InheritedConfig extends InheritedWidget {
  _InheritedConfig({
    Key key,
    @required this.config,
    @required Widget child,
  }) : super(key: key, child: child);

  final AppConfig config;

  @override
  bool updateShouldNotify(_InheritedConfig oldWidget) {
    return oldWidget.config.baseUrl != config.baseUrl;
  }
}
