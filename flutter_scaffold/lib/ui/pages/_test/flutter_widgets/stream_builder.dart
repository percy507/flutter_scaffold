import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:myapp/ui/pages/_test/test_page_utils.dart';

class StreamBuilderWidget extends StatefulWidget {
  StreamBuilderWidget({@required this.title});

  final String title;

  @override
  StreamBuilderWidgetState createState() => StreamBuilderWidgetState();
}

class StreamBuilderWidgetState extends State<StreamBuilderWidget> {
  // 用作管理监听，关闭暂停等
  // StreamSubscription<String> _subscription;
  StreamController<String> _streamController;
  // 发射事件
  StreamSink<String> get _streamSink => _streamController.sink;
  // 监听事件
  Stream<String> get _stream => _streamController.stream;

  @override
  void initState() {
    super.initState();

    _streamController = StreamController<String>();

    // _subscription = _stream.listen((event) {
    //   print(event);
    // });
  }

  @override
  void dispose() {
    super.dispose();

    _streamController.close();
    _streamSink.close();
    // _subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(children: [
        TestPageUtils.myButton(
          title: 'emit event',
          onPressed: () {
            if (_streamController.isClosed) {
              TestPageUtils.myDialog(
                title: 'Title',
                content: 'stream is closed',
              );
              return;
            }
            _streamSink.add('[stream string]${Random().nextDouble()}');
          },
        ),
        TestPageUtils.myButton(
          title: 'close stream',
          onPressed: () {
            _streamController.close();
          },
        ),
        Container(
          height: 200,
          padding: EdgeInsets.all(24),
          color: Colors.black12,
          // StreamBuilder则是依赖Stream来做异步数据获取
          // StreamBuilder 内部已经帮我们完成了stream的订阅与取消订阅
          child: StreamBuilder<String>(
            initialData: 'init data',
            stream: _stream,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              return Column(
                children: [
                  Text('connectionState ==> ${snapshot.connectionState}'),
                  Text('data ==> ${snapshot.data}'),
                ],
              );
            },
          ),
        ),
      ]),
    );
  }
}
