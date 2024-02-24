import 'package:dio/dio.dart';
import 'package:myapp/utils/platform_utils.dart';

class HeaderInterceptor extends InterceptorsWrapper {
  @override
  Future<RequestOptions> onRequest(RequestOptions options) async {
    options.connectTimeout = 1000 * 45;
    options.receiveTimeout = 1000 * 45;

    final appVersion = await PlatformUtils.getAppVersion();
    final version = {}..addAll(<String, dynamic>{
        'appVerison': appVersion,
      });
    options.headers['version'] = version;
    options.headers['platform'] = Platform.operatingSystem;

    return options;
  }
}
