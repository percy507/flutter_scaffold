import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:myapp/ui/pages/_test/test_page_utils.dart';
import 'package:myapp/utils/screen_utils.dart';

class FitScreenPage extends StatefulWidget {
  @override
  FitScreenPageState createState() => FitScreenPageState();
}

class FitScreenPageState extends State<FitScreenPage> {
  String _screenInfo = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('屏幕适配'),
      ),
      body: ListView(
        children: [
          SizedBox(height: 20),
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
          ),
          TestPageUtils.myButton(
            title: '获取屏幕相关信息',
            onPressed: () {
              // 1.媒体查询信息
              final mediaQueryData = MediaQuery.of(context);

              _screenInfo = '屏幕宽度: ${mediaQueryData.size.width}\n'
                  '屏幕高度: ${mediaQueryData.size.height}\n'
                  '分辨率宽度: ${window.physicalSize.width}\n'
                  '分辨率高度: ${window.physicalSize.height}\n'
                  '设备像素比[dpr]: ${window.devicePixelRatio}\n'
                  // 状态栏高度，刘海屏会更高
                  'statusBarHeight: ${mediaQueryData.padding.top}\n'
                  // 底部安全区距离
                  'bottomBarHeight: ${mediaQueryData.padding.bottom}\n'
                  'appBarHeight: $kToolbarHeight\n';
              setState(() {});
            },
          ),
          Container(
            padding: EdgeInsets.all(24),
            child: Text(
              _screenInfo,
              style: TextStyle(
                fontSize: 14.0,
                height: 1.7,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
