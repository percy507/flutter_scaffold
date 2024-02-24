import 'package:flutter/material.dart';
import 'package:myapp/ui/pages/_test/test_page_utils.dart';
import 'package:myapp/utils/platform_utils.dart';

class AppUpdatePage extends StatefulWidget {
  @override
  AppUpdatePageState createState() => AppUpdatePageState();
}

class AppUpdatePageState extends State<AppUpdatePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App 升级更新'),
      ),
      body: ListView(children: [
        TestPageUtils.myButton(
          title: '检查更新',
          onPressed: () {
            PlatformUtils.checkUpdate();
          },
        ),
      ]),
    );
  }
}
