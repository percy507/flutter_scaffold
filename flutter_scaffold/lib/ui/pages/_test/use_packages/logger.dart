import 'package:flutter/material.dart';
import 'package:myapp/ui/pages/_test/test_page_utils.dart';
import 'package:logger/logger.dart';
import 'package:logger_flutter/logger_flutter.dart';

class LoggerTest extends StatefulWidget {
  @override
  LoggerTestState createState() => LoggerTestState();
}

class LoggerTestState extends State<LoggerTest> {
  Logger logger = Logger(
    printer: PrettyPrinter(
      methodCount: 5,
    ),
  );

  @override
  Widget build(BuildContext context) {
    logger.v('Verbose log');
    logger.d('Debug log');
    logger.i('Info log');
    logger.w('Warning log');
    logger.e('Error log');
    logger.wtf('What a terrible failure log');

    return LogConsoleOnShake(
      child: Scaffold(
        appBar: AppBar(
          title: Text('logger'),
        ),
        body: ListView(
          children: [
            TestPageUtils.myButton(
              title: 'click to log',
              onPressed: () {
                try {
                  logger.i('clickkkkkkkkk');
                } catch (e) {
                  TestPageUtils.myDialog(
                    title: 'Error',
                    content: e.toString(),
                  );
                }
              },
            ),
            TestPageUtils.myButton(
              title: '点击或摇一摇展示 LogConsole',
              onPressed: () {
                LogConsole.open(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
