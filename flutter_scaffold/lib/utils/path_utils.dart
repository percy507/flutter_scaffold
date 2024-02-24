import 'dart:io';
import 'package:path_provider/path_provider.dart';

class PathUtils {
  /// 获取保存文件的默认路径
  static Future<String> getDefaultSavePath() async {
    Directory folder;

    if (Platform.isAndroid) {
      folder = await getExternalStorageDirectory();
    } else if (Platform.isIOS) {
      folder = await getApplicationDocumentsDirectory();
    } else {
      throw Exception('Wrong platform');
    }

    return folder.path;
  }
}
