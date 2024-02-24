import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

export 'package:shared_preferences/shared_preferences.dart';
export 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageUtils {
  /// [shared_preferences]
  /// 简单数据键值对存储
  static SharedPreferences sp;

  /// [flutter_secure_storage]
  /// 敏感数据存储
  static FlutterSecureStorage secureStorage;

  /// 初始化 [shared_preferences] 和 [flutter_secure_storage]
  static Future<void> init() async {
    sp = await SharedPreferences.getInstance();
    secureStorage = FlutterSecureStorage();
  }
}
