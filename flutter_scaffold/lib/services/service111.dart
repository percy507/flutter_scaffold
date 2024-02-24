import 'package:myapp/utils/dio/http.dart';

class Service111 {
  /// 获取一个随机笑话
  static Future getRandomJoke() async {
    return await http.get('/api/xh?type=json');
  }

  /// 获取bing随机风景图url
  static String getBingRandomImageUrl() {
    return '${Http.baseUrl}/api/bing?type=sj';
  }
}
