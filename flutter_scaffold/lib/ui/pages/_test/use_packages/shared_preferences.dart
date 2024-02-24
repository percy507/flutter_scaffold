import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/ui/widgets/checkbox_group.dart';
import 'package:myapp/ui/widgets/single_picker.dart';
import 'package:myapp/utils/storage_utils.dart';
// import 'package:myapp/ui/pages/_test/test_page_utils.dart';

class SharedPreferencesTest extends StatefulWidget {
  @override
  SharedPreferencesTestState createState() => SharedPreferencesTestState();
}

class SharedPreferencesTestState extends State<SharedPreferencesTest> {
  final _formKey = GlobalKey<FormState>();
  final SharedPreferences _prefs = StorageUtils.sp;

  bool _alreadyWork; // 是否已经工作
  int _age; // 年龄
  double _stature; // 身高
  String _email; // 邮箱
  List<String> _programLangs = []; // 擅长的编程语言

  TextEditingController _ageTextEditingController;
  TextEditingController _emailTextEditingController;

  @override
  void initState() {
    super.initState();

    _loadData();
  }

  // shared_preferences 加载数据
  Future<void> _loadData() async {
    setState(() {
      _alreadyWork = _prefs.getBool('key_alreadyWork');
      _age = _prefs.getInt('key_age');
      _stature = _prefs.getDouble('key_stature');
      _email = _prefs.getString('key_email');
      _programLangs = _prefs.getStringList('key_programLangs');

      _ageTextEditingController = TextEditingController(
        text: (_age == null ? _age : _age.toString()) as String,
      );
      _emailTextEditingController = TextEditingController(
        text: _email,
      );
    });
  }

  // shared_preferences 存储数据
  Future<void> _saveData() async {
    // 或者 if (Form.of(context).validate()) {
    if (_formKey.currentState.validate()) {
      print('_alreadyWork: $_alreadyWork');
      print('_age: $_age');
      print('_stature: $_stature');
      print('_email: $_email');
      print('_programLangs: $_programLangs');

      _prefs.setBool('key_alreadyWork', _alreadyWork);
      _prefs.setInt('key_age', _age);
      _prefs.setDouble('key_stature', _stature);
      _prefs.setString('key_email', _email);
      _prefs.setStringList('key_programLangs', _programLangs);

      showDialog<dynamic>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('保存成功'),
            content: Text(
              '存储路径:\n\nAndroid: /data/data/com.chanlian.myapp/shared_prefs/FlutterSharedPreferences.xml\n\niOS: /Users/mps/Library/Developer/CoreSimulator/Devices/25B6D96C-B427-4B6F-AD3A-AF2E395034C1/data/Containers/Data/Application/1ECE23B8-0A87-4AC6-B440-A54EB939747B/Library/Preferences/com.example.helloFlutter.plist',
            ),
          );
        },
      );
    }
  }

  Future<void> _getAllKeys() async {
    showDialog<dynamic>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('_prefs.getKeys()'),
          content: Text(
            _prefs.getKeys().toString(),
          ),
        );
      },
    );
  }

  Widget _formItem({@required String label, @required Widget child}) {
    const TextStyle labelStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    );

    return Container(
      padding: EdgeInsets.only(bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(
              label,
              style: labelStyle,
            ),
          ),
          child
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('shared_preferences'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(bottom: 24),
                  child: Center(
                    child: Text(
                      '测试表单',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                _formItem(
                  label: '是否已经工作',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(0),
                        width: 80,
                        child: Row(
                          children: [
                            Radio(
                              value: true,
                              groupValue: _alreadyWork,
                              onChanged: (bool value) {
                                setState(() {
                                  _alreadyWork = value;
                                });
                              },
                            ),
                            Text('是'),
                          ],
                        ),
                      ),
                      Container(
                        width: 80,
                        child: Row(
                          children: [
                            Radio(
                              value: false,
                              groupValue: _alreadyWork,
                              onChanged: (bool value) {
                                setState(() {
                                  _alreadyWork = value;
                                });
                              },
                            ),
                            Text('否'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                _formItem(
                  label: '年龄',
                  child: TextFormField(
                    controller: _ageTextEditingController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      // Only numbers can be entered
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    onChanged: (String value) {
                      _age = int.parse(value);
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      hintText: '请输入年龄',
                    ),
                    validator: FormUtils.validateAge,
                  ),
                ),
                _formItem(
                  label: '身高(cm)',
                  child: SinglePicker(
                    value: _stature,
                    placeholder: '请选择身高',
                    onChange: (double value) {
                      setState(() {
                        _stature = value;
                      });
                    },
                    items: List<double>.generate(60, (i) => i + 140.0),
                  ),
                ),
                _formItem(
                  label: '擅长的编程语言',
                  child: CheckBoxGroup(
                    value: _programLangs,
                    options: const [
                      '汇编语言',
                      'C',
                      'C++',
                      'Java',
                      'Objective-C',
                      'Pascal',
                      'Perl',
                      'Python',
                      'Ruby',
                      'PHP',
                      'JavaScript',
                      'Dart',
                      'Lua',
                      'SQL',
                      'C#',
                      'Go',
                    ],
                    onChange: (List<String> value) {
                      setState(() {
                        _programLangs = value;
                      });
                    },
                  ),
                ),
                _formItem(
                  label: '邮箱',
                  child: TextFormField(
                    controller: _emailTextEditingController,
                    onChanged: (String value) {
                      setState(() {
                        _email = value;
                      });
                    },
                    maxLength: 32,
                    decoration: InputDecoration(
                      hintText: '请输入邮箱',
                      counterText: '${_email?.length ?? 0}///32', // 自定义字符统计
                    ),
                    validator: FormUtils.validateEmail,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: _saveData,
                        child: Text('保存'),
                      ),
                      ElevatedButton(
                        onPressed: _getAllKeys,
                        child: Text('getKeys()'),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FormUtils {
  static String validateEmail(String email) {
    if (email.isEmpty) {
      return '邮箱不得为空';
    } else if (!RegExp(r'^\S+@\S+\.\S+$').hasMatch(email)) {
      return '无效的邮箱';
    }
    return null;
  }

  static String validateAge(String value) {
    if (value.isEmpty) {
      return '请输入年龄';
    }

    final int _intValue = int.parse(value);

    if (_intValue < 1 || _intValue > 100) {
      return '请输入有效的年龄';
    }
    return null;
  }
}
