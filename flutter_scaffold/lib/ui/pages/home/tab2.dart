import 'dart:math';

import 'package:flutter/material.dart';
import 'package:myapp/ui/styles/text.dart';
import 'package:myapp/utils/screen_utils.dart';

class Tab2Page extends StatefulWidget {
  @override
  Tab2PageState createState() => Tab2PageState();
}

class Tab2PageState extends State<Tab2Page> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  String _data = 'init data';

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Tab2Page'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            child: ElevatedButton(
              child: Text('改变数据'),
              onPressed: () {
                setState(() {
                  _data = 'data: ${Random().nextDouble()}';
                });
              },
            ),
          ),
          Center(
            child: Text(
              _data,
              style: tabTextStyle,
            ),
          ),
          Divider(),
          Text('以下图形测试屏幕适配'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 120,
                height: 120,
                color: Colors.red,
                child: Text(
                  '120 * 120\nfontSize: 12\n屏幕宽度: ${MediaQuery.of(context).size.width.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 12.0,
                  ),
                ),
              ),
              Container(
                width: 120.0.px,
                height: 120.0.px,
                color: Colors.red,
                child: Text(
                  '120px * 120px\nfontSize: 12px\n设计稿宽度: 375px',
                  style: TextStyle(
                    fontSize: 12.0.px,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
