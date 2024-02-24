import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myapp/ui/pages/_test/test_page_utils.dart';
import 'package:myapp/utils/storage_utils.dart';

class FlutterSecureStorageTest extends StatefulWidget {
  @override
  FlutterSecureStorageTestState createState() => FlutterSecureStorageTestState();
}

class FlutterSecureStorageTestState extends State<FlutterSecureStorageTest> {
  FlutterSecureStorage storage = StorageUtils.secureStorage;

  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _hidePassword = true;

  @override
  void initState() {
    super.initState();

    _loadValues();
  }

  Future<void> _loadValues() async {
    _accountController.text = await storage.read(key: '_account');
    _passwordController.text = await storage.read(key: '_password');
  }

  void _showSnakBar({
    BuildContext context,
    @required String title,
    Color color = Colors.green,
  }) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        content: Text(title),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('flutter_secure_storage'),
      ),
      body: Card(
        child: Center(
          child: SizedBox(
            width: 300,
            height: 450,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 24),
                  child: Center(
                    child: Text('登录', style: TextStyle(fontSize: 24)),
                  ),
                ),
                TextField(
                  controller: _accountController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(top: 10.0),
                    icon: Icon(Icons.perm_identity),
                    labelText: '请输入账号',
                  ),
                ),
                TextField(
                  controller: _passwordController,
                  obscureText: _hidePassword,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(top: 10.0),
                    icon: Icon(Icons.lock),
                    labelText: '请输入密码',
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.remove_red_eye,
                        color: _hidePassword ? Colors.grey : Colors.blue,
                      ),
                      onPressed: () {
                        setState(() {
                          _hidePassword = !_hidePassword;
                        });
                      },
                    ),
                  ),
                ),
                Builder(
                  builder: (BuildContext context) {
                    return ElevatedButton(
                      child: Text('保存'),
                      onPressed: () async {
                        await storage.write(
                          key: '_account',
                          value: _accountController.text ?? '',
                        );

                        await storage.write(
                          key: '_password',
                          value: _passwordController.text ?? '',
                        );

                        await storage.write(
                          key: '_token',
                          value: base64.encode(
                            utf8.encode(
                              '${_accountController.text ?? ''}@${_passwordController.text ?? ''}',
                            ),
                          ),
                        );

                        _showSnakBar(
                          context: context,
                          title: '保存成功',
                        );
                      },
                    );
                  },
                ),
                Builder(
                  builder: (BuildContext context) {
                    return ElevatedButton(
                      child: Text('storage.readAll()'),
                      onPressed: () async {
                        final Map<String, String> allValues = await storage.readAll();

                        TestPageUtils.myDialog(
                          title: 'allValues',
                          content: allValues.toString(),
                        );
                      },
                    );
                  },
                ),
                Builder(
                  builder: (BuildContext context) {
                    return ElevatedButton(
                      child: Text('storage.deleteAll()'),
                      onPressed: () async {
                        await storage.deleteAll();

                        _showSnakBar(
                          context: context,
                          title: '删除成功',
                          color: Colors.red,
                        );

                        // Scaffold.of(context).showSnackBar(
                        //   SnackBar(
                        //     backgroundColor: Colors.red,
                        //     content: Text("登录失败，用户名密码有误"),
                        //     action: SnackBarAction(
                        //       label: "撤回",
                        //       onPressed: () {
                        //         Scaffold.of(context).showSnackBar(
                        //           SnackBar(
                        //             content: Text('撤回。。。'),
                        //           ),
                        //         );
                        //       },
                        //     ),
                        //   ),
                        // );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
