import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import './connectivity.dart';
import './device_info.dart';
import './dio.dart';
import './flutter_html.dart';
import './flutter_local_notifications.dart';
import './flutter_secure_storage.dart';
import './flutter_swiper.dart';
import './logger.dart';
import './lottie.dart';
import './oktoast.dart';
import './open_file.dart';
import './package_info.dart';
import './path_provider.dart';
import './permission_handler.dart';
import './share.dart';
import './shared_preferences.dart';
import './sqflite.dart';
import './url_launcher.dart';
import './webview_flutter.dart';

class UsePackages extends StatelessWidget {
  Widget _buildListTile(BuildContext context, Map item) {
    return ListTile(
      title: Text(item['title'] as String),
      subtitle: Text(item['desc'] as String),
      trailing: IconButton(
        icon: Icon(Icons.open_in_browser),
        onPressed: () {
          launch(
            item['pubUrl'] as String,
            forceSafariVC: false,
          );
        },
      ),
      onTap: () {
        Navigator.of(context).push<dynamic>(
          MaterialPageRoute<dynamic>(
            builder: (context) {
              return item['instance'] as Widget;
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final packagesList = [
      {
        'title': 'shared_preferences',
        'desc': '跨平台的简单数据本地持久化(不要存储敏感数据)',
        'pubUrl': 'https://pub.flutter-io.cn/packages/shared_preferences',
        'instance': SharedPreferencesTest(),
      },
      {
        'title': 'flutter_secure_storage',
        'desc': '跨平台的敏感数据存储插件（Android使用KeyStore，iOS使用Keychain）',
        'pubUrl': 'https://pub.flutter-io.cn/packages/flutter_secure_storage',
        'instance': FlutterSecureStorageTest(),
      },
      {
        'title': 'path_provider',
        'desc': '跨平台文件路径支持',
        'pubUrl': 'https://pub.flutter-io.cn/packages/path_provider',
        'instance': PathProviderTest(),
      },
      {
        'title': 'sqflite',
        'desc': 'SQLite 数据库插件 for flutter',
        'pubUrl': 'https://pub.flutter-io.cn/packages/sqflite',
        'instance': SqfliteTest(),
      },
      {
        'title': 'dio',
        'desc': '一个强大的Http请求库，支持Restful API、FormData、拦截器、请求取消、Cookie管理、文件上传/下载、超时、自定义适配器等',
        'pubUrl': 'https://pub.flutter-io.cn/packages/dio',
        'instance': DioTest(),
      },
      {
        'title': 'permission_handler',
        'desc': '跨平台的请求应用权限或检查应用权限',
        'pubUrl': 'https://pub.flutter-io.cn/packages/permission_handler',
        'instance': PermissionHandlerTest(),
      },
      {
        'title': 'connectivity',
        'desc': '用于检查设备的网络连接情况',
        'pubUrl': 'https://pub.flutter-io.cn/packages/connectivity',
        'instance': ConnectivityTest(),
      },
      {
        'title': 'lottie',
        'desc': '解析并渲染AE动画',
        'pubUrl': 'https://pub.dev/packages/lottie',
        'instance': LottieTest(),
      },
      {
        'title': 'logger',
        'desc': '更优雅地打印日志',
        'pubUrl': 'https://pub.dev/packages/logger',
        'instance': LoggerTest(),
      },
      {
        'title': 'webview_flutter',
        'desc': 'webview 支持',
        'pubUrl': 'https://pub.dev/packages/webview_flutter',
        'instance': WebviewFlutterTest(),
      },
      {
        'title': 'url_launcher',
        'desc': '打开url',
        'pubUrl': 'https://pub.dev/packages/url_launcher',
        'instance': UrlLauncherTest(),
      },
      {
        'title': 'share',
        'desc': '唤起系统分享',
        'pubUrl': 'https://pub.dev/packages/share',
        'instance': ShareTest(),
      },
      {
        'title': 'flutter_html',
        'desc': 'rendering html and css as Flutter widgets',
        'pubUrl': 'https://pub.dev/packages/flutter_html',
        'instance': FlutterHtmlTest(),
      },
      {
        'title': 'flutter_swiper',
        'desc': 'swiper for flutter',
        'pubUrl': 'https://pub.dev/packages/flutter_swiper',
        'instance': FlutterSwiperTest(),
      },
      {
        'title': 'flutter_local_notifications',
        'desc': '本地通知',
        'pubUrl': 'https://pub.dev/packages/flutter_local_notifications',
        'instance': FlutterLocalNotificationsTest(),
      },
      {
        'title': 'device_info',
        'desc': '获取设备信息',
        'pubUrl': 'https://pub.dev/packages/device_info',
        'instance': DeviceInfoTest(),
      },
      {
        'title': 'package_info',
        'desc': '获取应用包信息',
        'pubUrl': 'https://pub.dev/packages/package_info',
        'instance': PackageInfoTest(),
      },
      {
        'title': 'open_file',
        'desc': '唤起原生应用以打开文件',
        'pubUrl': 'https://pub.dev/packages/open_file',
        'instance': OpenFileTest(),
      },
      {
        'title': 'oktoast',
        'desc': 'toast, pure dart',
        'pubUrl': 'https://pub.dev/packages/oktoast',
        'instance': OKToastTest(),
      },
    ];

    final List<Widget> listViewChildren = packagesList
        .map(
          (item) => _buildListTile(
            context,
            item,
          ),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('使用第三方包'),
      ),
      body: ListView(
        children: ListTile.divideTiles(
          context: context,
          tiles: listViewChildren,
        ).toList(),
      ),
    );
  }
}
