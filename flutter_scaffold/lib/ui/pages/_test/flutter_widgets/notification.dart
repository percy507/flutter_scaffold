import 'dart:math';

import 'package:flutter/material.dart';
import 'package:myapp/ui/pages/_test/test_page_utils.dart';

// Notification
class MyNotification extends Notification {
  MyNotification({
    @required this.data,
  });

  final String data;
}

class NotificationWidget extends StatefulWidget {
  NotificationWidget({@required this.title});

  final String title;

  @override
  NotificationWidgetState createState() => NotificationWidgetState();
}

class NotificationWidgetState extends State<NotificationWidget> {
  String _data = 'init data';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: NotificationListener<MyNotification>(
        onNotification: (notification) {
          setState(() {
            _data = notification.data;
          });

          // 返回true阻止notification继续冒泡
          return true;
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              child: Text('Parent\n$_data'),
            ),
            Widget111(),
          ],
        ),
      ),
    );
  }
}

Widget _container({
  double padding = 6,
  double height = 50,
  @required Color color,
  @required String widgetName,
  List<Widget> children = const [],
}) {
  return Container(
    padding: EdgeInsets.all(padding),
    width: double.infinity,
    height: height,
    color: color,
    child: ListView(
      children: [Text(widgetName), ...children],
    ),
  );
}

class Widget111 extends StatefulWidget {
  @override
  Widget111State createState() => Widget111State();
}

class Widget111State extends State<Widget111> {
  @override
  Widget build(BuildContext context) {
    return _container(
      padding: 24,
      height: 300,
      color: Colors.black12,
      widgetName: 'Widget111',
      children: [
        Widget222(),
      ],
    );
  }
}

class Widget222 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _container(
      padding: 6,
      height: 240,
      color: Colors.black12,
      widgetName: 'Widget222',
      children: [
        Widget333(),
      ],
    );
  }
}

class Widget333 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _container(
      padding: 6,
      height: 180,
      color: Colors.black12,
      widgetName: 'Widget333',
      children: [
        TestPageUtils.myButton(
          title: 'bubble data',
          onPressed: () {
            MyNotification(
              data: 'Hi notification.${Random().nextDouble().toStringAsFixed(6)}',
            ).dispatch(context);
          },
        )
      ],
    );
  }
}
