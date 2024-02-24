/// app 所有配置
class Config {
  /// 默认设计稿尺寸，单位px
  static double designWidth = 375;

  /// dio
  static bool dioEnableProxy = false; // 是否启动代理
  static String dioProxy = '127.0.0.1:12888'; // 代理地址

  /// dev 环境配置
  static Map<String, dynamic> devConfig = <String, dynamic>{
    'baseUrl': 'https://api.vvhan.com',
  };

  /// test 环境配置
  static Map<String, dynamic> testConfig = <String, dynamic>{
    'baseUrl': 'https://api.vvhan.com',
  };

  /// show 环境配置
  static Map<String, dynamic> showConfig = <String, dynamic>{
    'baseUrl': 'https://api.vvhan.com',
  };

  /// prod 环境配置
  static Map<String, dynamic> prodConfig = <String, dynamic>{
    'baseUrl': 'https://api.vvhan.com',
  };
}
