import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/ui/pages/_test/test_page_utils.dart';

class CatchExceptionPage extends StatefulWidget {
  @override
  CatchExceptionPageState createState() => CatchExceptionPageState();
}

class CatchExceptionPageState extends State<CatchExceptionPage> {
  String _text = 'Flutter Framework';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('异常收集/上报'),
      ),
      body: ListView(
        children: [
          TestPageUtils.myButton(
            title: '单纯地 print',
            onPressed: () {
              print('单纯地 print');
            },
          ),
          TestPageUtils.myButton(
            title: 'Dart 同步代码异常[手动捕获]\n使用 try-catch 捕获',
            onPressed: () {
              try {
                final List<String> numList = ['1', '2'];
                print(numList[5]);
              } catch (e) {
                print('Dart 同步代码异常[手动捕获]\n$e');
              }
            },
          ),
          TestPageUtils.myButton(
            title: 'Dart 异步代码异常[手动捕获]\n使用 catchError 捕获，不能用 try-catch',
            onPressed: () {
              Future<dynamic>.delayed(Duration(seconds: 1))
                  .then(
                    (dynamic value) => throw StateError('Dart 异步代码异常[手动捕获]'),
                  )
                  .catchError((dynamic e) => print(e));
            },
          ),
          TestPageUtils.myButton(
            title: 'Dart 同步代码异常[未捕获]',
            onPressed: () {
              final List<String> numList = ['1', '2'];
              print(numList[5]);
            },
          ),
          TestPageUtils.myButton(
            title: 'Dart 异步代码异常[未捕获]',
            onPressed: () {
              Future<dynamic>.delayed(Duration(seconds: 1)).then(
                (dynamic value) => throw StateError('Dart 异步代码异常[未捕获]'),
              );
            },
          ),
          TestPageUtils.myButton(
            title: '与原生通信产生的异常',
            onPressed: () async {
              const channel = MethodChannel('wtf-custom-channel');
              await channel.invokeMethod<dynamic>('wtf');
            },
          ),
          TestPageUtils.myButton(
            title: 'Flutter Framework 异常',
            onPressed: () {
              setState(() {
                _text = null;
              });
            },
          ),
          Text(
            _text,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
