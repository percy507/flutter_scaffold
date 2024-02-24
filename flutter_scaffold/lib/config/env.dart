import 'package:myapp/config/config.dart';

enum EnvType {
  dev,
  test,
  show,
  prod,
}

EnvConfig get envConfig => _env;
EnvConfig _env;

class EnvConfig {
  EnvConfig._init(EnvType envType) {
    switch (envType) {
      case EnvType.dev:
        _fromJson(<String, dynamic>{'env': envType, ...Config.devConfig});
        break;
      case EnvType.test:
        _fromJson(<String, dynamic>{'env': envType, ...Config.testConfig});
        break;
      case EnvType.show:
        _fromJson(<String, dynamic>{'env': envType, ...Config.showConfig});
        break;
      case EnvType.prod:
        _fromJson(<String, dynamic>{'env': envType, ...Config.prodConfig});
        break;
    }
  }

  EnvType envType;
  String baseUrl;

  void _fromJson(Map<String, dynamic> config) {
    print(config);
    baseUrl = config['baseUrl'] as String;
  }

  static void init({EnvType envType}) {
    _env ??= EnvConfig._init(envType);
  }
}
