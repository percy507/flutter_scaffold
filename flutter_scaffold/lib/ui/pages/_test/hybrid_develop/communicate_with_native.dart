import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/ui/pages/_test/test_page_utils.dart';

class CommunicateWithNative extends StatelessWidget {
  final MethodChannel channel = MethodChannel('com.flutter.MethodChannel');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('与原生通信的三种方式'),
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: Text(
              'MethodChannel：Flutter 与 Native 端相互调用，调用后可以返回结果，可以 Native 端主动调用，也可以Flutter主动调用，属于双向通信。此方式为最常用的方式， Native 端调用需要在主线程中执行。',
            ),
          ),
          TestPageUtils.myButton(
            title: 'MethodChannel - showToast',
            onPressed: () async {
              TestPageUtils.myDialog(
                title: 'TODO',
                content: '写kotlin代码有点恶心',
              );
              // https://my.oschina.net/willdas/blog/4497784
              // try {
              //   await channel.invokeMethod(
              //     "showToast",
              //     {
              //       "msg": "message from flutter",
              //     },
              //   );
              // } on PlatformException catch (e) {
              //   print(e.toString());
              // }
            },
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: Text(
              'BasicMessageChannel：用于使用指定的编解码器对消息进行编码和解码，属于双向通信，可以 Native 端主动调用，也可以Flutter主动调用。',
            ),
          ),
          TestPageUtils.myButton(
            title: 'BasicMessageChannel',
            onPressed: () async {
              TestPageUtils.myDialog(
                title: 'TODO',
                content: '写kotlin代码有点恶心',
              );
            },
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: Text(
              'EventChannel：用于数据流（event streams）的通信， Native 端主动发送数据给 Flutter，通常用于状态的监听，比如网络变化、传感器数据等。',
            ),
          ),
          TestPageUtils.myButton(
            title: 'EventChannel',
            onPressed: () async {
              TestPageUtils.myDialog(
                title: 'TODO',
                content: '写kotlin代码有点恶心',
              );
            },
          ),
        ],
      ),
    );
  }
}
