import 'package:flutter/material.dart';
import 'package:myapp/app.dart';
import 'package:myapp/config/env.dart';
import 'package:myapp/utils/exception_utils.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  EnvConfig.init(envType: EnvType.show);

  ExceptionUtils.zoneWrapper(() {
    runApp(FlutterApp());
  });
}
