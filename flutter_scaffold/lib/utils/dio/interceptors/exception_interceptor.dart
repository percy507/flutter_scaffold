import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:oktoast/oktoast.dart';

///
/// 一般错误分为网络错误、请求错误、认证错误、服务器错误，所以实现统一的错误处理。
/// 认证错误需要登录等认证，所以单独一个类型，请求错误也单独设置一个类型，方便我们定位错误
///

/// http异常
class HttpException implements Exception {
  HttpException(
    this._code,
    this._message,
  );

  factory HttpException.create(DioError error) {
    switch (error.type) {
      case DioErrorType.CANCEL:
        return BadRequestException(-1, '请求取消');

      case DioErrorType.CONNECT_TIMEOUT:
        return BadRequestException(-1, '连接超时');

      case DioErrorType.SEND_TIMEOUT:
        return BadRequestException(-1, '请求超时');

      case DioErrorType.RECEIVE_TIMEOUT:
        return BadRequestException(-1, '响应超时');

      case DioErrorType.RESPONSE:
        {
          try {
            final int errCode = error.response.statusCode;

            switch (errCode) {
              case 400:
                return BadRequestException(errCode, '请求语法错误');
              case 401:
                return UnauthorisedException(errCode, '没有权限');
              case 403:
                return UnauthorisedException(errCode, '服务器拒绝执行');
              case 404:
                return UnauthorisedException(errCode, '无法连接服务器');
              case 405:
                return UnauthorisedException(errCode, '请求方法被禁止');
              case 500:
                return UnauthorisedException(errCode, '服务器内部错误');
              case 502:
                return UnauthorisedException(errCode, '无效的请求');
              case 503:
                return UnauthorisedException(errCode, '服务器挂了');
              case 505:
                return UnauthorisedException(errCode, '不支持HTTP协议请求');
              default:
                return HttpException(errCode, error.response.statusMessage);
            }
          } on Exception catch (_) {
            return HttpException(-1, '未知错误');
          }
        }
        break;
      default:
        return HttpException(-1, error.message);
    }
  }

  final String _message;
  final int _code;

  @override
  String toString() {
    return '$_code $_message';
  }
}

/// 请求异常
class BadRequestException extends HttpException {
  BadRequestException([int code, String message]) : super(code, message);
}

/// 未认证异常
class UnauthorisedException extends HttpException {
  UnauthorisedException([int code, String message]) : super(code, message);
}

/// http异常处理拦截器
class HttpExceptionInterceptor extends Interceptor {
  @override
  Future onError(DioError err) {
    final HttpException httpException = HttpException.create(err);

    debugPrint('DioError===: ${httpException.toString()}');

    // 错误提示
    showToast(
      httpException.toString(),
      position: ToastPosition.top,
    );

    err.error = httpException;

    return super.onError(err);
  }
}
