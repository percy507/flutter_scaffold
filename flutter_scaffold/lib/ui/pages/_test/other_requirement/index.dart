import 'package:flutter/material.dart';

import './app_update.dart';
import './catch_exception.dart';
import './fit_screen.dart';
import './legal.dart';

class OtherRequirement extends StatelessWidget {
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
        'title': '合规相关',
        'desc': '用户协议、隐私政策，合规通过后即可向用户申请应用权限授权',
        'instance': LegalPage(),
      },
      {
        'title': '异常收集/上报',
        'desc': '全局捕获/上报异常的逻辑在 main.dart 文件',
        'instance': CatchExceptionPage(),
      },
      {
        'title': 'App 升级更新',
        'desc': '安卓: 直接下载apk更新或前往第三方应用市场更新\niOS: 前往应用商店更新',
        'instance': AppUpdatePage(),
      },
      {
        'title': '屏幕适配',
        'desc': '屏幕适配',
        'instance': FitScreenPage(),
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
        title: Text('其他需求'),
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
