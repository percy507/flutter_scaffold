import 'dart:math';

import 'package:flutter/material.dart';
import 'package:myapp/ui/pages/_test/test_page_utils.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FlutterLocalNotificationsTest extends StatefulWidget {
  @override
  FlutterLocalNotificationsTestState createState() => FlutterLocalNotificationsTestState();
}

class FlutterLocalNotificationsTestState extends State<FlutterLocalNotificationsTest> {
  FlutterLocalNotificationsPlugin localNotification = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();

    initLocalNotification().then((bool isInitSuccess) async {
      print('init: $isInitSuccess');
    });
  }

  Future<bool> initLocalNotification() async {
    final InitializationSettings initializationSettings = InitializationSettings(
      // default icon path: android/app/src/main/res/mipmap-*/app_icon.png
      android: AndroidInitializationSettings('@mipmap/app_icon'),
      iOS: IOSInitializationSettings(),
    );

    // android don't notification permission
    // iOS need notification permission
    return await localNotification.initialize(
      initializationSettings,
      onSelectNotification: onSelectNotification,
    );
  }

  void showLocalNotification() {
    final int unreadNumber = Random().nextInt(100);

    final notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'your channel id',
        'your channel name',
        'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        // sound path: android/app/src/main/res/raw/slow_spring_board.mp3
        sound: RawResourceAndroidNotificationSound('slow_spring_board'),
      ),
      // iOS 必须通过xcode来添加自定义声音文件，否则不生效，很奇葩
      // https://github.com/MaikuB/flutter_local_notifications/issues/255
      // https://stackoverflow.com/questions/46231153/how-to-add-sound-files-to-your-bundle-in-xcode
      iOS: IOSNotificationDetails(sound: 'slow_spring_board.aiff'),
    );

    localNotification.show(
      0,
      'Remind',
      'You have $unreadNumber messages，click to read',
      notificationDetails,
      payload: '',
    );
  }

  Future onSelectNotification(String payload) async {
    print('notification payload: ' + payload);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('flutter_local_notifications'),
      ),
      body: ListView(
        children: [
          TestPageUtils.myButton(
            title: 'Local Notification',
            onPressed: () {
              showLocalNotification();
            },
          ),
        ],
      ),
    );
  }
}
