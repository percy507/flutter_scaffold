import 'package:flutter/material.dart';
import 'package:myapp/ui/pages/_test/test_page_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLauncherTest extends StatefulWidget {
  @override
  UrlLauncherTestState createState() => UrlLauncherTestState();
}

class UrlLauncherTestState extends State<UrlLauncherTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('url_launcher'),
      ),
      body: ListView(
        children: [
          TestPageUtils.myButton(
            title: '默认浏览器打开URL',
            onPressed: () {
              launch('https://baidu.com');
            },
          ),
          TestPageUtils.myButton(
            title: 'webview打开URL',
            onPressed: () {
              launch(
                'https://baidu.com',
                forceWebView: true,
                enableJavaScript: true,
                enableDomStorage: true,
              );
            },
          ),
          TestPageUtils.myButton(
            title: '发邮件',
            onPressed: () {
              launch(
                'mailto:email@address.com?subject=<subject>&body=<body>',
              );
            },
          ),
          TestPageUtils.myButton(
            title: '发邮件<use Uri class>',
            onPressed: () {
              final Uri _emailLaunchUri = Uri(
                scheme: 'mailto',
                path: 'smith@example.com',
                queryParameters: <String, String>{
                  'subject': 'Example Subject & Symbols are allowed!',
                  'body': 'This is body',
                },
              );

              launch(_emailLaunchUri.toString());
            },
          ),
          TestPageUtils.myButton(
            title: '打电话',
            onPressed: () {
              launch(
                'tel:+1 555 010 999',
              );
            },
          ),
          TestPageUtils.myButton(
            title: '发短信',
            onPressed: () {
              launch(
                'sms:5550101234',
              );
            },
          ),
          TestPageUtils.myButton(
            title: '打开第三方app(微信)',
            onPressed: () async {
              const String url = 'weixin://';

              if (await canLaunch(url)) {
                launch(url);
              } else {
                TestPageUtils.myDialog(
                  title: 'url无法打开',
                  content: 'url: $url',
                );
              }
            },
          ),
          TestPageUtils.myButton(
            title: '打开第三方app(掘金)',
            onPressed: () async {
              const url = 'juejin://post/5d66565cf265da03e71b0672';

              if (await canLaunch(url)) {
                launch(url);
              } else {
                TestPageUtils.myDialog(
                  title: 'url无法打开',
                  content: 'url: $url',
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
