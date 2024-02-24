import 'dart:math';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:myapp/models/user_model.dart';
import 'package:myapp/utils/database_utils.dart';
import 'package:sqflite/sqflite.dart';
// import 'package:myapp/ui/pages/_test/test_page_utils.dart';

class SqfliteTest extends StatefulWidget {
  @override
  SqfliteTestState createState() => SqfliteTestState();
}

class SqfliteTestState extends State<SqfliteTest> {
  Faker faker = Faker();
  Random random = Random();

  Database _db;
  String _dbPath;

  List<UserModel> _userList = [];

  @override
  void initState() {
    super.initState();

    _initDatabase();
  }

  Future<void> _initDatabase() async {
    _db = DatabaseUtils.db;
    _dbPath = DatabaseUtils.dbPath;
    print(_dbPath);
    _queryAllData(context);
    setState(() {});
  }

  Future _insert(UserModel user) async {
    return await _db.insert(
      'User',
      user.toJson(),
    );

    // 使用SQL语句插入
    // return await _db.rawInsert(
    //   'INSERT Into User (name,age,sex) VALUES (?,?,?)',
    //   [user.name, user.age, user.sex],
    // );
  }

  Future<int> _update(UserModel user) async {
    return await _db.update(
      'User',
      user.toJson(),
      where: 'id = ?',
      whereArgs: <dynamic>[user.id],
    );
  }

  Future<int> _delete(int id) async {
    return await _db.delete(
      'User',
      where: 'id = ?',
      whereArgs: <dynamic>[id],
    );
  }

  Future<int> _deleteAll() async {
    return await _db.delete('User');
  }

  Future<List<UserModel>> _queryAll() async {
    final List<Map<String, dynamic>> result = await _db.query('User');

    return result.isNotEmpty
        ? result.map((e) {
            return UserModel.fromJson(e);
          }).toList()
        : [];
  }

  Widget _headButton({@required String title, @required void Function() onPressed}) {
    return ElevatedButton(
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.blue),
      ),
      onPressed: onPressed,
    );
  }

  Future<void> _queryAllData(BuildContext context) async {
    _userList = await _queryAll();
    setState(() {});
  }

  Future<void> _addData(BuildContext context) async {
    final UserModel user = UserModel(
      name: faker.person.name(),
      age: random.nextInt(90) + 10, // random int [10, 99)
      sex: random.nextInt(2), // random int [0, 2)
    );

    final int result = await _insert(user) as int;

    if (result > 0) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('插入数据成功，result:$result'),
        ),
      );
    } else {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('插入数据失败，result:$result'),
        ),
      );
    }

    _queryAllData(context);
  }

  Future<void> _updateData(int id) async {
    final UserModel user = UserModel(
      id: id,
      name: faker.person.name(),
      age: random.nextInt(90) + 10, // random int [10, 99)
      sex: random.nextInt(2), // random int [0, 2)
    );

    await _update(user);
    _queryAllData(context);
  }

  Future<void> _deleteData(int id) async {
    await _delete(id);
    _queryAllData(context);
  }

  Future<void> _clearAllData(BuildContext context) async {
    await _deleteAll();
    _queryAllData(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('sqflite'),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.all(16),
                  title: Text('DB路径'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(_dbPath)],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _headButton(
                      title: '查询数据',
                      onPressed: () => _queryAllData(context),
                    ),
                    _headButton(
                      title: '新增数据',
                      onPressed: () => _addData(context),
                    ),
                    _headButton(
                      title: '清空数据',
                      onPressed: () => _clearAllData(context),
                    ),
                  ],
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.only(
                    top: 16,
                    bottom: 24,
                  ),
                  child: Center(
                    child: DataTable(
                      columnSpacing: 12,
                      headingRowHeight: 36,
                      headingRowColor: MaterialStateProperty.all(Colors.black12),
                      dataRowHeight: 40,
                      columns: const <DataColumn>[
                        DataColumn(label: Text('操作')),
                        DataColumn(label: Text('id')),
                        DataColumn(label: Text('姓名'), tooltip: '长按提示'),
                        DataColumn(label: Text('年龄')),
                        DataColumn(label: Text('性别')),
                      ],
                      rows: [
                        ..._userList.map((user) {
                          return DataRow(
                            // onSelectChanged: (selected) {},
                            cells: [
                              DataCell(Row(
                                children: [
                                  IconButton(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.all(0),
                                    iconSize: 18,
                                    icon: Icon(Icons.refresh),
                                    onPressed: () => _updateData(user.id),
                                  ),
                                  IconButton(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.all(0),
                                    iconSize: 18,
                                    icon: Icon(Icons.delete),
                                    onPressed: () => _deleteData(user.id),
                                  ),
                                ],
                              )),
                              DataCell(Text('${user.id}')),
                              DataCell(Text(user.name)),
                              DataCell(Text('${user.age}')),
                              DataCell(Text(user.sex == 0 ? '男' : '女')),
                            ],
                          );
                        }).toList()
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
