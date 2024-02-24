import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:myapp/ui/pages/_test/flutter_widgets/index.dart';
import 'package:myapp/ui/pages/_test/custom_widgets/index.dart';
import 'package:myapp/ui/pages/_test/use_packages/index.dart';
import 'package:myapp/ui/pages/_test/hybrid_develop/index.dart';
import 'package:myapp/ui/pages/_test/other_requirement/index.dart';

class Tab4Page extends StatelessWidget {
  Widget _buildListTile(BuildContext context, Map item) {
    return ListTile(
      title: Text(item['title'] as String),
      onTap: () {
        final _instance = item['instance'] as Widget;

        if (_instance == null) {
          showToast('待开发');
        } else {
          Navigator.of(context).push<dynamic>(
            MaterialPageRoute<dynamic>(
              builder: (BuildContext context) {
                return _instance;
              },
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final _list = [
      {
        'title': 'Flutter控件',
        'instance': FlutterWidgets(),
      },
      {
        'title': '生命周期',
        'instance': null,
      },
      {
        'title': '页面布局',
        'instance': null,
      },
      {
        'title': '自定义控件',
        'instance': CustomWidgets(),
      },
      {
        'title': '使用第三方包',
        'instance': UsePackages(),
      },
      {
        'title': '混合开发',
        'instance': HybridDevelop(),
      },
      {
        'title': '其他需求',
        'instance': OtherRequirement(),
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
        title: Text('学习demo，可删'),
        automaticallyImplyLeading: false, // 关闭默认的 leading
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
