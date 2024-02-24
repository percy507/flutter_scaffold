import 'package:flutter/material.dart';
import './future_builder.dart';
import './inherited_model.dart';
import './inherited_widget.dart';
import './notification.dart';
import './show_or_hide.dart';
import './stream_builder.dart';
import './transform.dart';

class FlutterWidgets extends StatelessWidget {
  Widget _buildListTile(BuildContext context, Map item) {
    return ListTile(
      title: Text(item['title'] as String),
      subtitle: Text(item['desc'] as String),
      onTap: () {
        Navigator.of(context).push<dynamic>(
          MaterialPageRoute<dynamic>(
            builder: (context) {
              return item['instance'] as Widget;
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final _list = [
      {
        'title': 'FutureBuilder',
        'desc': '异步UI更新',
        'instance': FutureBuilderWidget(
          title: 'FutureBuilder',
        ),
      },
      {
        'title': 'StreamBuilder',
        'desc': '异步UI更新',
        'instance': StreamBuilderWidget(
          title: 'StreamBuilder',
        ),
      },
      {
        'title': 'Transform',
        'desc': '矩阵变换',
        'instance': TransformWidget(
          title: 'Transform',
        ),
      },
      {
        'title': 'Widget的隐藏与显示',
        'desc': 'Offstage、Opacity、AnimatedOpacity、Visibility',
        'instance': ShowOrHideWidget(
          title: 'Widget的隐藏与显示',
        ),
      },
      {
        'title': 'InheritedWidget',
        'desc': '跨级通信，数据由上向下传递，共享父控件的数据',
        'instance': InheritedWidgetWidget(
          title: 'InheritedWidget',
        ),
      },
      {
        'title': 'InheritedModel',
        'desc': 'InheritedWidget子类，可以更精度地控制状态',
        'instance': InheritedModelWidget(
          title: 'InheritedModel',
        ),
      },
      {
        'title': 'Notification',
        'desc': '跨级通信，数据由下向上传递',
        'instance': NotificationWidget(
          title: 'Notification',
        ),
      },
    ];

    final List<Widget> listViewChildren = _list
        .map(
          (item) => _buildListTile(
            context,
            item,
          ),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Widgets'),
      ),
      body: ListView(
        children: ListTile.divideTiles(
          context: context,
          tiles: listViewChildren,
        ).toList(),
      ),
    );
  }
}
