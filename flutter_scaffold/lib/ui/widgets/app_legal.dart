import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:myapp/config/resource.dart';
import 'package:myapp/utils/navigator_utils.dart';
import 'package:myapp/utils/platform_utils.dart';
import 'package:permission_handler/permission_handler.dart';

class AppLegal {
  static Future<void> requestPermissions() async {
    // 请求存储权限
    if (await Permission.storage.isGranted != true) {
      await Permission.storage.request();
    }

    // 请求相机权限
    if (await Permission.camera.isGranted != true) {
      await Permission.camera.request();
    }

    // 请求通知栏权限
    if (await Permission.notification.isGranted != true) {
      await Permission.notification.request();
    }
  }

  static void showLegalDialog() {
    showDialog<dynamic>(
      context: NavigatorUtils.context,
      barrierDismissible: false, // 点击遮罩层不关闭dialog
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () => Future.value(false),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(24.0)),
            ),
            titlePadding: EdgeInsets.all(12),
            contentPadding: EdgeInsets.all(0),
            title: Text(
              '用户协议与隐私政策',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(20, 8, 20, 14),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.black12,
                      ),
                    ),
                  ),
                  child: UserAgreementText(
                    beforeText:
                        '您将要开始使用的是由xxx有限公司开发、拥有、运营的移动端应用。本应用的使用需要互联网，请您在网络环境下使用该应用。\n\n在您使用本应用时，我们会向您申请或获取相机、定位、相册、麦克风、通知等权限，需要获取您的设备信息、应用的日志信息等。我们承诺会采取业界先进的安全措施保护您的信息安全。你可以阅读',
                    afterText: '了解详细信息。\n\n点击“同意”，然后开始使用我们的应用。',
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      child: Text(
                        '退出',
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onPressed: () {
                        PlatformUtils.quitApp();
                      },
                    ),
                    TextButton(
                      child: Text(
                        '同意',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        requestPermissions();
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

/// 自定义的用户协议组件。
class UserAgreementText extends StatelessWidget {
  UserAgreementText({
    this.beforeText = '',
    this.afterText = '',
  });

  final String beforeText;
  final String afterText;

  final TextStyle _normalStyle = TextStyle(
    fontSize: 14.0,
    color: Color(0xFF4A4A4A),
  );

  final TextStyle _highlightStyle = TextStyle(
    fontSize: 14.0,
    color: Colors.blue[600],
  );

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: beforeText,
        style: _normalStyle,
        children: [
          TextSpan(
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                NavigatorUtils.gotoAgreementPage(
                  title: '用户协议',
                  agreementPath: R.user_agreement,
                );
              },
            text: '《用户协议》',
            style: _highlightStyle,
          ),
          TextSpan(
            text: '和',
            style: _normalStyle,
          ),
          TextSpan(
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                NavigatorUtils.gotoAgreementPage(
                  title: '隐私政策',
                  agreementPath: R.privacy_policy,
                );
              },
            text: '《隐私政策》',
            style: _highlightStyle,
          ),
          TextSpan(
            text: afterText,
            style: _normalStyle,
          ),
        ],
      ),
    );
  }
}
