import 'package:myapp/utils/dio/http.dart';

class CommonService {
  /// 检查更新
  static Future checkUpdate() async {
    const String api = 'http://172.18.1.115:8090/api/app/version';
    return await http.get(api);
  }
}
