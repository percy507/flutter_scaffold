import 'package:flutter/material.dart';
import 'package:myapp/ui/pages/_test/test_page_utils.dart';
import 'package:oktoast/oktoast.dart';

class OKToastTest extends StatefulWidget {
  @override
  OKToastTestState createState() => OKToastTestState();
}

class OKToastTestState extends State<OKToastTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('oktoast'),
      ),
      body: ListView(
        children: [
          TestPageUtils.myButton(
            title: '短消息',
            onPressed: () {
              showToast('Toast message');
            },
          ),
          TestPageUtils.myButton(
            title: '长消息',
            onPressed: () {
              showToast(
                  'This error happens if you call setState() on a State object for a widget that no longer appears in the widget tree (e.g., whose parent widget no longer includes the widget in its build). This error can occur when code calls setState() from a timer or an animation callback.');
            },
          ),
          TestPageUtils.myButton(
            title: '自定义Widget Toast',
            onPressed: () {
              final Widget w = Center(
                child: Container(
                  padding: const EdgeInsets.all(5),
                  color: Colors.black.withOpacity(0.7),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      Text(
                        '添加成功',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                    mainAxisSize: MainAxisSize.min,
                  ),
                ),
              );

              showToastWidget(
                w,
                position: ToastPosition.bottom,
              );
            },
          ),
        ],
      ),
    );
  }
}
