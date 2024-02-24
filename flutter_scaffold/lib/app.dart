import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:myapp/config/route.dart';
import 'package:myapp/utils/navigator_utils.dart';
import 'package:myapp/ui/widgets/wrapper/user_info_wrapper.dart';

class FlutterApp extends StatefulWidget {
  @override
  FlutterAppState createState() => FlutterAppState();
}

class FlutterAppState extends State<FlutterApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OKToast(
      dismissOtherOnShow: true,
      child: UserInfoWrapper(
        data: const <String, dynamic>{
          'id': '12355432',
          'name': 'John Aligator',
          'age': 12,
          'tags': <String>['happy boy', 'red', 'white'],
        },
        child: MaterialApp(
          title: 'Flutter Demo',
          navigatorKey: NavigatorUtils.navigatorKey,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          onGenerateRoute: AppRouter.generateRoute,
          initialRoute: RouteName.splash,
        ),
      ),
    );
  }
}
