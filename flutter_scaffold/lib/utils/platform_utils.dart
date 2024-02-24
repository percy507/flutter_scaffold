import 'dart:async';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/models/app_update_info.dart';
import 'package:myapp/services/common.dart';
import 'package:myapp/ui/widgets/app_update.dart';
import 'package:myapp/utils/navigator_utils.dart';
import 'package:oktoast/oktoast.dart';
import 'package:package_info/package_info.dart';

export 'dart:io';

class PlatformUtils {
  /// 获取 PackageInfo
  static Future<PackageInfo> getAppPackageInfo() {
    return PackageInfo.fromPlatform();
  }

  /// 获取版本号
  static Future<String> getAppVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  /// 获取 build number
  static Future<String> getBuildNum() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.buildNumber;
  }

  /// 获取 DeviceInfo
  static Future getDeviceInfo() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      return await deviceInfo.androidInfo;
    } else if (Platform.isIOS) {
      return await deviceInfo.iosInfo;
    } else {
      return null;
    }
  }

  /// 退出 app
  static Future<void> quitApp() async {
    await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }

  /// 检查更新
  /// 流程
  ///   == 获取本地app版本信息
  ///   == 获取服务器app版本信息
  ///   == 新版本 ? 弹窗 : null
  ///   == 确认更新 &&  ?
  ///     == 安卓 && 下载apk，保存至本地 && 安装(使用 open_file 打开apk文件)
  ///     == iOS && 跳转apple store
  static Future<void> checkUpdate() async {
    final PackageInfo _packageInfo = await PackageInfo.fromPlatform();
    final AppUpdateInfo _appUpdateInfo =
        AppUpdateInfo.fromJson(await CommonService.checkUpdate() as Map<String, dynamic>);
    final String currentVersion = _packageInfo.version;
    final String fetchedVersion = _appUpdateInfo.version;

    if (currentVersion == fetchedVersion) {
      showToast('已经是最新版本');
      return;
    }

    showDialog(
      context: NavigatorUtils.context,
      builder: (BuildContext context) {
        return AppUpdateWidget(
          packageInfo: _packageInfo,
          updateInfo: _appUpdateInfo,
        );
      },
    );
  }
}
