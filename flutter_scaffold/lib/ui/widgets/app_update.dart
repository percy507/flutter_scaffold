import 'dart:io';

import 'package:flutter/material.dart';
import 'package:myapp/models/app_update_info.dart';
import 'package:myapp/utils/crypto_utils.dart';
import 'package:myapp/utils/dio/http.dart';
import 'package:myapp/utils/path_utils.dart';
import 'package:myapp/utils/platform_utils.dart';
import 'package:oktoast/oktoast.dart';
import 'package:open_file/open_file.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUpdateWidget extends StatefulWidget {
  AppUpdateWidget({
    @required this.updateInfo,
    @required this.packageInfo,
  });

  final AppUpdateInfo updateInfo;
  final PackageInfo packageInfo;

  @override
  AppUpdateWidgetState createState() => AppUpdateWidgetState();
}

class AppUpdateWidgetState extends State<AppUpdateWidget> {
  PackageInfo _packageInfo;
  AppUpdateInfo _updateInfo;

  bool _downloading = false;
  double _downloadProgress;

  @override
  void initState() {
    super.initState();

    _packageInfo = widget.packageInfo;
    _updateInfo = widget.updateInfo;
  }

  /// 下载apk
  Future<void> _downloadApk(String url) async {
    final String savePath = await PathUtils.getDefaultSavePath();
    final String filePath = '$savePath/${_packageInfo.appName}_v${_updateInfo.version}.apk';

    setState(() {
      _downloading = true;
      _downloadProgress = 0;
    });

    http.download(
      url,
      filePath,
      onReceiveProgress: (receivedBytes, totalBytes) {
        setState(() {
          _downloadProgress = receivedBytes / totalBytes;
        });
      },
    ).then((dynamic value) async {
      final String remoteMd5 = _updateInfo.apkMd5;
      final String localMd5 = await CryptoUtils.md5File(filePath);

      print('remoteMd5:' + remoteMd5);
      print('localMd5: ' + localMd5);

      // 一定要校验 apk 的md5值是否一致
      if (remoteMd5 == localMd5) {
        OpenFile.open(filePath);
      } else {
        showToast(
          '安装文件的md5值与远程不一致。',
          position: ToastPosition.top,
        );
      }
    }).whenComplete(() {
      setState(() {
        _downloading = false;
        _downloadProgress = null;
      });
    });
  }

  /// 确认更新
  Future<void> _confirmUpdate() async {
    final String androidReleaseUrl = _updateInfo.androidReleaseUrl;
    final String iosReleaseUrl = _updateInfo.iosReleaseUrl;

    if (Platform.isIOS) {
      if (await canLaunch(iosReleaseUrl)) {
        launch(iosReleaseUrl);
      } else {
        showToast('打开AppStore失败');
      }
      return;
    } else if (Platform.isAndroid) {
      _downloadApk(androidReleaseUrl);
    } else {
      throw Exception('Wrong Platform for update');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(0)),
        ),
        titlePadding: EdgeInsets.all(12),
        contentPadding: EdgeInsets.all(0),
        title: Text(
          '发现新版本  v${_updateInfo.version}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(20, 8, 20, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _updateInfo.changelog.map<Widget>((el) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: Center(
                          child: Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.lightGreen,
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          el,
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
            _downloading
                ? Stack(
                    children: <Widget>[
                      SizedBox(
                        height: 30,
                        child: LinearProgressIndicator(
                          value: _downloadProgress,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor,
                          ),
                          backgroundColor: Theme.of(context).primaryColorLight,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                        child: Align(
                          child: Text(
                            '${(_downloadProgress * 100).toStringAsFixed(0)}%',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black45,
                            ),
                          ),
                          alignment: Alignment.center,
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        child: Text(
                          '暂不更新',
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text(
                          '更新',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onPressed: () {
                          _confirmUpdate();
                        },
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
