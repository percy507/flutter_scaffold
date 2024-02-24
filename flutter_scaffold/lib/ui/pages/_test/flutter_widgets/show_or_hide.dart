import 'package:flutter/material.dart';
import 'package:myapp/ui/pages/_test/test_page_utils.dart';

class ShowOrHideWidget extends StatefulWidget {
  ShowOrHideWidget({@required this.title});

  final String title;

  @override
  ShowOrHideWidgetState createState() => ShowOrHideWidgetState();
}

class ShowOrHideWidgetState extends State<ShowOrHideWidget> {
  bool _normalVisable = true;
  bool _offstageVisable = true;
  bool _opacityVisable = true;
  bool _animatedOpacityVisable = true;
  bool _visibilityVisable = true;

  Widget myBox([Color color = Colors.teal]) {
    return Center(
      child: SizedBox(
        width: 50,
        height: 50,
        child: Container(
          color: color,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: <Widget>[
          TestPageUtils.myButton(
            title: 'Toggle: 隐藏设置widget为null',
            onPressed: () {
              setState(() {
                _normalVisable = !_normalVisable;
              });
            },
          ),
          _normalVisable ? myBox() : null,
          TestPageUtils.myButton(
            title: 'Toggle: Offstage',
            onPressed: () {
              setState(() {
                _offstageVisable = !_offstageVisable;
              });
            },
          ),
          Offstage(
            // offstage 为 true 时，隐藏 child
            offstage: !_offstageVisable,
            child: myBox(),
          ),
          TestPageUtils.myButton(
            title: 'Toggle: Opacity',
            onPressed: () {
              setState(() {
                _opacityVisable = !_opacityVisable;
              });
            },
          ),
          Opacity(
            // 当opacity的值为0时完全透明，不会进行绘制，控件不显示
            opacity: _opacityVisable ? 1.0 : 0.0,
            child: myBox(),
          ),
          TestPageUtils.myButton(
            title: 'Toggle: AnimatedOpacity',
            onPressed: () {
              setState(() {
                _animatedOpacityVisable = !_animatedOpacityVisable;
              });
            },
          ),
          AnimatedOpacity(
            duration: Duration(milliseconds: 300),
            opacity: _animatedOpacityVisable ? 1.0 : 0.0,
            child: myBox(),
          ),
          TestPageUtils.myButton(
            title: 'Toggle: Visibility 推荐使用',
            onPressed: () {
              setState(() {
                _visibilityVisable = !_visibilityVisable;
              });
            },
          ),
          Visibility(
            visible: _visibilityVisable,
            // 以下三个属性: child 不见时，是否保留状态、动画，空间，默认都为 false
            // maintainState: true,
            // maintainAnimation: true,
            // maintainSize: true,
            replacement: Text('修改了默认的 replacement'),
            child: myBox(),
          ),
          Divider(
            color: Colors.red,
          ),
        ].where((child) => child != null).toList(),
      ),
    );
  }
}
