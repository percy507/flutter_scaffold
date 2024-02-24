import 'package:flutter/material.dart';

import './communicate_with_native.dart';

class HybridDevelop extends StatelessWidget {
  final _list = [
    {
      'title': '与原生通信',
      'desc': '有三种方式',
      'instance': CommunicateWithNative(),
    },
  ];

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
        title: Text('混合开发'),
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
