import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:myapp/ui/pages/_test/test_page_utils.dart';

class PermissionHandlerTest extends StatefulWidget {
  @override
  PermissionHandlerTestState createState() => PermissionHandlerTestState();
}

class PermissionHandlerTestState extends State<PermissionHandlerTest> {
  Future<void> _showAllPermissionGroup() async {
    TestPageUtils.myDialog(
      title: 'All PermissionGroup',
      content: Permission.values.toString(),
    );
  }

  Future<void> _showAllPermissionStatus() async {
    TestPageUtils.myDialog(
      title: 'All PermissionGroup',
      content: PermissionStatus.values.toString(),
    );
  }

  Future<void> _openAppSettingPage() async {
    openAppSettings();
  }

  Future<void> _checkStoragePermission() async {
    final PermissionStatus status = await Permission.storage.status;

    print(status.toString());

    if (!status.isGranted) {
      await Permission.storage.request();
    }

    TestPageUtils.myDialog(
      title: 'Permission.storage.status',
      content: status.toString(),
    );
  }

  Future<void> _checkSMSPermission() async {
    TestPageUtils.myDialog(
      title: 'Permission.sms.status',
      content: (await Permission.sms.status).toString(),
    );

    if (await Permission.sms.isPermanentlyDenied) {
      // The user opted to never again see the permission request dialog for this
      // app. The only way to change the permission's status now is to let the
      // user manually enable it in the system settings.
      openAppSettings();
    } else if (!(await Permission.sms.isGranted)) {
      await Permission.sms.request();
    }

    TestPageUtils.myDialog(
      title: 'Permission.sms.status',
      content: (await Permission.sms.status).toString(),
    );
  }

  Future<void> _checkCameraPermission() async {
    if (await Permission.camera.isPermanentlyDenied) {
      // The user opted to never again see the permission request dialog for this
      // app. The only way to change the permission's status now is to let the
      // user manually enable it in the system settings.
      openAppSettings();
    } else if (!(await Permission.camera.isGranted)) {
      await Permission.camera.request();
    }

    TestPageUtils.myDialog(
      title: 'Permission.camera.status',
      content: (await Permission.camera.status).toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('permission_handler'),
      ),
      body: ListView(children: [
        TestPageUtils.myButton(
          title: '显示所有的权限组',
          onPressed: () {
            _showAllPermissionGroup();
          },
        ),
        TestPageUtils.myButton(
          title: '显示所有的权限状态',
          onPressed: () {
            _showAllPermissionStatus();
          },
        ),
        TestPageUtils.myButton(
          title: '打开应用设置界面',
          onPressed: () {
            _openAppSettingPage();
          },
        ),
        TestPageUtils.myButton(
          title: '检查存储权限',
          onPressed: () {
            _checkStoragePermission();
          },
        ),
        TestPageUtils.myButton(
          title: '检查sms权限',
          onPressed: () {
            _checkSMSPermission();
          },
        ),
        TestPageUtils.myButton(
          title: '检查camera权限',
          onPressed: () {
            _checkCameraPermission();
          },
        ),
      ]),
    );
  }
}
