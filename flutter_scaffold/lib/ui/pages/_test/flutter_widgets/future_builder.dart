import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:myapp/ui/pages/_test/test_page_utils.dart';

class FutureBuilderWidget extends StatefulWidget {
  FutureBuilderWidget({@required this.title});

  final String title;

  @override
  FutureBuilderWidgetState createState() => FutureBuilderWidgetState();
}

class FutureBuilderWidgetState extends State<FutureBuilderWidget> {
  Future<String> _future;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void fetchData({bool withError = false}) {
    _future = Future<dynamic>.delayed(const Duration(seconds: 1)).then((dynamic value) {
      if (withError) {
        return Future.error('error from fetchData');
      }
      return '[stream string]${Random().nextDouble()}';
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(children: [
        TestPageUtils.myButton(
          title: 'fetchData',
          onPressed: () {
            fetchData();
          },
        ),
        TestPageUtils.myButton(
          title: 'fetchData with error',
          onPressed: () {
            fetchData(withError: true);
          },
        ),
        Container(
          height: 200,
          padding: const EdgeInsets.all(24),
          color: Colors.black12,
          // FutureBuilder依靠Future来做异步数据获取
          child: FutureBuilder<String>(
            initialData: 'init string data',
            future: _future,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              print(snapshot);
              return Column(
                children: [
                  // connectionState：枚举对象，它的值可以是none waiting active done
                  Text('connectionState ==> ${snapshot.connectionState}'),
                  Text(snapshot.hasError
                      ? 'error ==> ${snapshot.error.toString()}'
                      : 'data ==> ${snapshot.data}'),
                ],
              );
            },
          ),
        ),
      ]),
    );
  }
}
