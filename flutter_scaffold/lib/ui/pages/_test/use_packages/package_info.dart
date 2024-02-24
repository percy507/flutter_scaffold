import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

class PackageInfoTest extends StatefulWidget {
  @override
  PackageInfoTestState createState() => PackageInfoTestState();
}

class PackageInfoTestState extends State<PackageInfoTest> {
  Map<String, String> _packageInfo;

  @override
  void initState() {
    super.initState();

    getPackageInfo();
  }

  Future<void> getPackageInfo() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();

    _packageInfo = {
      'appName': packageInfo.appName,
      'packageName': packageInfo.packageName,
      'version': packageInfo.version,
      'buildNumber': packageInfo.buildNumber,
    };
    setState(() {});
  }

  String formatToPrettyJson(Object obj) {
    const jsonEncoder = JsonEncoder.withIndent('    ');
    return jsonEncoder.convert(obj);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('package_info'),
      ),
      body: SingleChildScrollView(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              formatToPrettyJson(_packageInfo),
            ),
          ),
        ),
      ),
    );
  }
}
