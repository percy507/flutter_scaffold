import 'dart:async';
import 'package:flutter/material.dart';

class ExceptionUtils {
  static Future<void> _reportError(Object error, StackTrace stackTrace) async {
    print('_reportError error:\n$error');
    print('_reportError stackTrace:\n$stackTrace');
    // 接日志系统
    // 异常上报平台 Sentry（一个商业级的日志管理系统）
  }

  /// 包裹 app，以捕获 app 中未捕获的异常
  static void zoneWrapper(Function runAppFunc) {
    // Zone 表示指定代码执行的环境
    // require Dart 2.8+
    runZonedGuarded(
      () {
        // 捕获 Flutter framework 异常
        FlutterError.onError = (FlutterErrorDetails details) {
          Zone.current.handleUncaughtError(details.exception, details.stack);
        };

        runAppFunc();
      },
      // 处理 Zone 中的未捕获异常
      (Object error, StackTrace stackTrace) {
        _reportError(error, stackTrace);
      },
      // zoneValues: Zone 的私有数据，可以通过实例zone[key]获取，可以理解为每个“沙箱”的私有数据
      zoneValues: {},
      // zoneSpecification: Zone 的一些配置，可以自定义一些代码行为，比如拦截日志输出行为等
      zoneSpecification: ZoneSpecification(
          // 拦截 print 日志输出
          // print: (Zone self, ZoneDelegate parent, Zone zone, String line) {
          //   parent.print(zone, 'zoneSpecification-print:\n$line');
          // },
          ),
    );
  }
}
