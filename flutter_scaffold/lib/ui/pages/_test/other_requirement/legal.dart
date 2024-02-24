import 'package:flutter/material.dart';
import 'package:myapp/ui/pages/_test/test_page_utils.dart';
import 'package:myapp/ui/widgets/app_legal.dart';

class LegalPage extends StatefulWidget {
  @override
  LegalPageState createState() => LegalPageState();
}

class LegalPageState extends State<LegalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('合规相关'),
      ),
      body: ListView(children: [
        Container(
          padding: EdgeInsets.all(30),
          child: Center(
            child: UserAgreementText(
              beforeText: '点击注册/登录即同意',
            ),
          ),
        ),
        TestPageUtils.myButton(
          title: '唤起用户协议Dialog',
          onPressed: () {
            AppLegal.showLegalDialog();
          },
        ),
      ]),
    );
  }
}
