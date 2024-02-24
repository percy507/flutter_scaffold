import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:myapp/config/config.dart';
import 'package:myapp/config/env.dart';
import 'package:myapp/utils/dio/business_code.dart';
import 'package:myapp/utils/dio/interceptors/exception_interceptor.dart';
import 'package:myapp/utils/dio/interceptors/header_interceptor.dart';
import 'package:myapp/utils/navigator_utils.dart';

export 'package:dio/dio.dart';

class Http {
  factory Http() => _instance;
  Http._internal() {
    if (dio == null) {
      dio = Dio(
        BaseOptions(
          // 请求基地址，如果 `path` 以 "http(s)"开始, 则 `baseURL` 会被忽略
          baseUrl: baseUrl,
          connectTimeout: 60000, // 连接服务器超时时间，单位是毫秒
          receiveTimeout: 30000, // 服务器响应超时时间，单位是毫秒
          contentType: 'application/json; charset=utf-8', // 默认请求 Content-Type
          responseType: ResponseType.json, // 默认响应数据的类型
          headers: <String, dynamic>{
            'Authorization': 'xxx',
          },
        ),
      );

      // 设置拦截器
      dio.interceptors
        ..add(HeaderInterceptor()) // header拦截器
        ..add(HttpExceptionInterceptor()); // 异常拦截器

      // 在调试模式下需要抓包调试，所以我们使用代理，并禁用HTTPS证书校验
      if (enableProxy) {
        (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
          client.findProxy = (uri) {
            return 'PROXY $proxy';
          };

          // 代理工具会提供一个抓包的自签名证书，会通不过证书校验，所以我们禁用证书校验
          client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
        };
      }
    }
  }

  static String baseUrl = envConfig.baseUrl;

  // 代理配置
  static final bool enableProxy = Config.dioEnableProxy;
  static final String proxy = Config.dioProxy;

  static final Http _instance = Http._internal();

  Dio dio;
  // CancelToken _cancelToken = new CancelToken();

  // 处理json格式的响应数据
  dynamic _handleResponseJsonData(Map<String, dynamic> data) {
    final int businessCode = data['code'] as int; // 业务code

    switch (businessCode) {
      case SUCCESS_CODE:
        break;
      case TOKEN_FORMAT_ERROR:
      case TOKEN_CRYPT_ERROR:
      case TOKEN_INVALID:
        return NavigatorUtils.gotoLoginPage();
    }

    return data;
  }

  dynamic _handleResponse(Response response) {
    final String contentType = response.headers.value('Content-Type');
    final dynamic responseData = response.data;

    if (contentType == null) {
      return responseData;
    }

    if (contentType.contains('json')) {
      // 如果 content-type 是 json
      // Dio 会自动将响应数据转换为 Map<String,dynamic>
      return _handleResponseJsonData(response.data as Map<String, dynamic>);
    }

    return responseData;
  }

  Future<dynamic> _request(
    String path, {
    Map<String, dynamic> queryParameters,
    dynamic data,
    CancelToken cancelToken,
    Options options,
    ProgressCallback onSendProgress,
    ProgressCallback onReceiveProgress,
  }) async {
    final Response response = await dio.request<dynamic>(
      path,
      queryParameters: queryParameters,
      data: data,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    return Future<dynamic>.value(_handleResponse(response));
  }

  Future<dynamic> get(
    String path, {
    Map<String, dynamic> queryParameters,
  }) async {
    return _request(
      path,
      queryParameters: queryParameters,
      options: Options(method: 'GET'),
    );
  }

  Future<dynamic> post(
    String path, {
    Map<String, dynamic> queryParameters,
    dynamic data,
    String contentType = PostContentType.json,
  }) async {
    return _request(
      path,
      data: data,
      options: Options(
        method: 'POST',
        contentType: contentType,
      ),
    );
  }

  Future<dynamic> put(
    String path, {
    Map<String, dynamic> queryParameters,
    dynamic data,
  }) async {
    return _request(
      path,
      queryParameters: queryParameters,
      data: data,
      options: Options(
        method: 'PUT',
      ),
    );
  }

  Future<dynamic> delete(
    String path, {
    Map<String, dynamic> queryParameters,
    dynamic data,
  }) async {
    return _request(
      path,
      queryParameters: queryParameters,
      data: data,
      options: Options(
        method: 'DELETE',
      ),
    );
  }

  /// 自定义下载文件逻辑
  /// [path] 下载链接
  /// [savePath] 本地保存文件的路径
  /// 坑：使用dio原配的download方法下载文件后，文件的md5值会发生变化，暂未定位到原因
  Future<dynamic> download(
    String path,
    String savePath, {
    CancelToken cancelToken,
    Function(int, int) onReceiveProgress,
  }) async {
    final dynamic responseData = await _request(
      path,
      options: Options(
        receiveTimeout: 0,
        responseType: ResponseType.bytes,
      ),
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );

    final File file = File(savePath);
    final raf = file.openSync(mode: FileMode.write);
    raf.writeFromSync(responseData as List<int>);
    await raf.close();

    return responseData;
  }
}

class PostContentType {
  /// 使用 application/json 编码
  static const String json = Headers.jsonContentType;

  /// 使用 application/x-www-form-urlencoded 编码
  static const String formUrlEncoded = Headers.formUrlEncodedContentType;

  /// 使用 multipart/form-data 编码，目前仅 post 支持 FormData
  static const String formData = null;
}

final Http http = Http();
