import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:myapp/ui/widgets/custom_webview.dart';

class WebviewFlutterTest extends StatefulWidget {
  @override
  WebviewFlutterTestState createState() => WebviewFlutterTestState();
}

class WebviewFlutterTestState extends State<WebviewFlutterTest> {
  @override
  Widget build(BuildContext context) {
    const String url = 'https://juejin.cn/';

    return CustomWebView(
      initialUrl: url,
    );
  }
}
