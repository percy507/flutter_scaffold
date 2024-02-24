import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:myapp/ui/pages/_test/test_page_utils.dart';

class TransformWidget extends StatefulWidget {
  TransformWidget({@required this.title});

  final String title;

  @override
  TransformWidgetState createState() => TransformWidgetState();
}

class TransformWidgetState extends State<TransformWidget> {
  String _type;

  Widget whichTransform({@required String type}) {
    Widget myBox([Color color = Colors.teal]) {
      return Center(
        child: SizedBox(
          width: 100,
          height: 100,
          child: Container(
            color: color,
          ),
        ),
      );
    }

    Widget myStack({@required Widget child}) {
      return Stack(
        children: [
          myBox(Colors.black12),
          child,
        ],
      );
    }

    switch (type) {
      case 'translate':
        return myStack(
          child: Transform.translate(
            offset: const Offset(20.0, 40.0), // offset 偏移量，水平向右为正向，竖直向下为正向
            child: myBox(),
          ),
        );
      case 'rotate':
        return myStack(
          child: Transform.rotate(
            angle: math.pi / 4, // 旋转45°
            origin: const Offset(50, 50), // 偏移量
            // alignment: Alignment.topCenter, // 对齐方式
            child: myBox(),
          ),
        );
      case 'scale':
        return myStack(
          child: Transform.scale(
            scale: 0.5, // 缩小0.5倍
            // origin: const Offset(50, 50), // 偏移量
            // alignment: Alignment.topCenter, // 对齐方式
            child: myBox(),
          ),
        );
      default:
        return myBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(children: [
        TestPageUtils.myButton(
          title: '平移 translate',
          onPressed: () {
            setState(() {
              _type = 'translate';
            });
          },
        ),
        TestPageUtils.myButton(
          title: '旋转 rotate',
          onPressed: () {
            setState(() {
              _type = 'rotate';
            });
          },
        ),
        TestPageUtils.myButton(
          title: '缩放 scale',
          onPressed: () {
            setState(() {
              _type = 'scale';
            });
          },
        ),
        whichTransform(type: _type),
      ]),
    );
  }
}
