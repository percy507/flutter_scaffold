import 'package:dokit/dokit.dart';
import 'package:flutter/material.dart';
import 'package:myapp/app.dart';
import 'package:myapp/config/env.dart';
import 'package:myapp/utils/exception_utils.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  EnvConfig.init(envType: EnvType.test);

  ExceptionUtils.zoneWrapper(() {
    DoKit.runApp(
      app: DoKitApp(FlutterApp()),
      // 是否在release包内使用，默认release包会禁用
      useInRelease: true,
      releaseAction: () {
        // release模式下执行该函数，一些用到runZone之类实现的可以放到这里，该值为空则会直接调用系统的runApp(MyApp())，
      },
    );
  });
}
