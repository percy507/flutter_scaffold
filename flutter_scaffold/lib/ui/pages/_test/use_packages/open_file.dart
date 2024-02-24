import 'dart:io';

import 'package:flutter/material.dart';
import 'package:myapp/ui/pages/_test/test_page_utils.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class OpenFileTest extends StatefulWidget {
  @override
  OpenFileTestState createState() => OpenFileTestState();
}

class OpenFileTestState extends State<OpenFileTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('open_file'),
      ),
      body: ListView(
        children: [
          TestPageUtils.myButton(
            title: '打开txt文件',
            onPressed: () async {
              final Directory dir = await getApplicationDocumentsDirectory();
              final filePath = '${dir.path}/path_provider_test_result.txt';

              OpenFile.open(filePath);
            },
          ),
        ],
      ),
    );
  }
}
