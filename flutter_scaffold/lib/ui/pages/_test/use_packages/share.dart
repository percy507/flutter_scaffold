import 'dart:io';

import 'package:flutter/material.dart';
import 'package:myapp/ui/pages/_test/test_page_utils.dart';
import 'package:share/share.dart';
import 'package:path_provider/path_provider.dart';

class ShareTest extends StatefulWidget {
  @override
  ShareTestState createState() => ShareTestState();
}

class ShareTestState extends State<ShareTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('share'),
      ),
      body: ListView(
        children: [
          TestPageUtils.myButton(
            title: '分享文本',
            onPressed: () {
              Share.share('check out my website\nhttps://example.com');
            },
          ),
          TestPageUtils.myButton(
            title: '分享文件',
            onPressed: () async {
              final Directory dir = await getApplicationDocumentsDirectory();
              final String _path = '${dir.path}/path_provider_test_result.txt';

              if (File(_path).existsSync()) {
                Share.shareFiles([_path], text: 'Great picture');
              } else {
                TestPageUtils.myDialog(
                  title: '文件不存在',
                  content: 'path: $_path',
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
