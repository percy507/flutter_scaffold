import 'dart:async';

import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:myapp/ui/pages/_test/test_page_utils.dart';

class ConnectivityTest extends StatefulWidget {
  @override
  ConnectivityTestState createState() => ConnectivityTestState();
}

class ConnectivityTestState extends State<ConnectivityTest> {
  StreamSubscription subscription;

  @override
  void initState() {
    super.initState();

    subscription = Connectivity().onConnectivityChanged.listen(
      (ConnectivityResult result) {
        // Got a new connectivity status!
        TestPageUtils.myDialog(
          title: '网络发生了变动',
          content: result.toString(),
        );
      },
    );
  }

  // Be sure to cancel subscription after you are done
  @override
  void dispose() {
    super.dispose();

    subscription.cancel();
  }

  Future<void> _checkConnectivity() async {
    final ConnectivityResult connectivityResult = await Connectivity().checkConnectivity();

    TestPageUtils.myDialog(
      title: '网络情况',
      content: connectivityResult.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('connectivity'),
      ),
      body: ListView(children: [
        TestPageUtils.myButton(
          title: '检测网络情况',
          onPressed: () {
            _checkConnectivity();
          },
        ),
      ]),
    );
  }
}
