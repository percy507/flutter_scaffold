import 'dart:math';

import 'package:flutter/material.dart';
import 'package:myapp/ui/pages/_test/test_page_utils.dart';

// InheritedWidget 本身并不包含具体的 widget，它只负责向下传递数据
class MyInheritedWidget extends InheritedWidget {
  MyInheritedWidget({
    Key key,
    @required this.data,
    @required Widget child,
  }) : super(key: key, child: child);

  final InheritedWidgetWidgetState data;

  // 决定什么时候通知子树中依赖 data 的 Widget 更新数据
  @override
  bool updateShouldNotify(MyInheritedWidget oldWidget) {
    return oldWidget.data._data != data._data;
  }
}

class InheritedWidgetWidget extends StatefulWidget {
  InheritedWidgetWidget({@required this.title});

  final String title;

  @override
  InheritedWidgetWidgetState createState() => InheritedWidgetWidgetState();

  static InheritedWidgetWidgetState of(BuildContext context) {
    // dependOnInheritedWidgetOfExactType 会注册父控件与子控件的依赖关系，子控件会调用 didChangeDependencies 方法，所以会实时共享数据
    return context.dependOnInheritedWidgetOfExactType<MyInheritedWidget>().data;
  }

  static InheritedWidgetWidgetState of222(BuildContext context) {
    // getElementForInheritedWidgetOfExactType 没有注册依赖关系，所以父控件数据更新时，子控件不会调用 didChangeDependencies 方法
    return (context.getElementForInheritedWidgetOfExactType<MyInheritedWidget>().widget
            as MyInheritedWidget)
        .data;
  }

  static InheritedWidgetWidgetState of333(BuildContext context) {
    // ancestor 祖先、始祖
    // findAncestorWidgetOfExactType, 在 Widget 树中向上查找最近的父级 `MyInheritedWidget` widget
    return context.findAncestorWidgetOfExactType<MyInheritedWidget>().data;
  }
}

class InheritedWidgetWidgetState extends State<InheritedWidgetWidget> {
  String _data = 'init data';

  void changeData() {
    setState(() {
      _data = 'changeParentData: ${Random().nextDouble()}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(children: [
        TestPageUtils.myButton(
          title: 'change data',
          onPressed: () {
            setState(() {
              _data = 'parent_data: ${Random().nextDouble()}';
            });
          },
        ),
        MyInheritedWidget(
            data: this,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  child: Text('Parent\n$_data'),
                ),
                Widget111(),
                SizedBox(height: 20),
                Widget222(),
                SizedBox(height: 20),
                Widget333(),
                SizedBox(height: 20),
                Widget555(),
              ],
            ))
      ]),
    );
  }
}

Widget _container({
  double padding = 6,
  double height = 50,
  @required Color color,
  @required String widgetName,
  @required String data,
  List<Widget> children = const [],
}) {
  return Container(
    padding: EdgeInsets.all(padding),
    width: double.infinity,
    height: height,
    color: color,
    child: ListView(
      children: [Text(widgetName), Text(data), ...children],
    ),
  );
}

class Widget111 extends StatefulWidget {
  @override
  Widget111State createState() => Widget111State();
}

class Widget111State extends State<Widget111> {
  String _parentData;

  @override
  void initState() {
    super.initState();

    print('widget111 initState');
  }

  @override
  void dispose() {
    super.dispose();

    print('widget111 dispose');
  }

  @override
  void didUpdateWidget(Widget111 oldWidget) {
    super.didUpdateWidget(oldWidget);

    print('widget111 didUpdateWidget');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    print('widget111 didChangeDependencies');

    setState(() {
      _parentData = InheritedWidgetWidget.of(context)._data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _container(
      padding: 6,
      height: 60,
      color: Colors.black12,
      widgetName: 'Widget111',
      data: _parentData,
    );
  }
}

class Widget222 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String _parentData = InheritedWidgetWidget.of(context)._data;

    return _container(
      padding: 6,
      height: 60,
      color: Colors.black12,
      widgetName: 'Widget222',
      data: _parentData,
    );
  }
}

class Widget333 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String _parentData = InheritedWidgetWidget.of(context)._data;

    return _container(
      padding: 6,
      height: 180,
      color: Colors.black12,
      widgetName: 'Widget333',
      data: _parentData,
      children: [
        TestPageUtils.myButton(
          title: 'change parent data',
          onPressed: () {
            InheritedWidgetWidget.of(context).changeData();
          },
        ),
        Widget444(),
      ],
    );
  }
}

class Widget444 extends StatefulWidget {
  @override
  Widget444State createState() => Widget444State();
}

class Widget444State extends State<Widget444> {
  String _parentData222;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    setState(() {
      _parentData222 = InheritedWidgetWidget.of222(context)._data;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('print: Widget444 build');
    debugPrint('debugPrint: Widget444 build');
    return _container(
      padding: 6,
      height: 60,
      color: Colors.black12,
      widgetName: 'Widget444',
      data: _parentData222,
    );
  }
}

class Widget555 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _container(
      padding: 6,
      height: 60,
      color: Colors.black12,
      widgetName: 'Widget555',
      data: '不继承数据: self data${Random().nextDouble()}',
    );
  }
}
