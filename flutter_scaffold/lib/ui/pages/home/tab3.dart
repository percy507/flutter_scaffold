import 'dart:math';
import 'package:flutter/material.dart';
import 'package:myapp/ui/styles/text.dart';
import 'package:myapp/ui/widgets/wrapper/user_info_wrapper.dart';

class Tab3Page extends StatefulWidget {
  @override
  Tab3PageState createState() => Tab3PageState();
}

class Tab3PageState extends State<Tab3Page> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  String _data = 'init data';

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Tab3Page'),
      ),
      body: ListView(
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
          Container(
            padding: EdgeInsets.all(24),
            color: Colors.black12,
            child: Text(
              '获取用户数据\n${UserInfoWrapper.of(context).toString()}',
            ),
          ),
        ],
      ),
    );
  }
}
