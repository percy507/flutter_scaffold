import 'dart:io';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';

class CryptoUtils {
  /// 计算文件的md5
  static Future<String> md5File(String path) async {
    final File file = File(path);
    final Uint8List bytes = await file.readAsBytes();
    return md5.convert(bytes).toString();
  }
}
