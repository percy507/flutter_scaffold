import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:myapp/ui/pages/_test/data.dart';

class PathProviderTest extends StatefulWidget {
  @override
  _PathProviderTestState createState() => _PathProviderTestState();
}

class _PathProviderTestState extends State<PathProviderTest> {
  Future<Directory> _tempDirectory;
  Future<Directory> _appSupportDirectory;
  Future<Directory> _appLibraryDirectory;
  Future<Directory> _appDocumentsDirectory;
  Future<Directory> _downloadDirectory;
  Future<Directory> _externalStorageDirectory;
  Future<List<Directory>> _externalStorageDirectories;
  Future<List<Directory>> _externalCacheDirectories;

  @override
  void initState() {
    super.initState();

    setState(() {
      _tempDirectory = getTemporaryDirectory();
      _appSupportDirectory = getApplicationSupportDirectory();
      _appLibraryDirectory = getLibraryDirectory();
      _appDocumentsDirectory = getApplicationDocumentsDirectory();
      _downloadDirectory = getDownloadsDirectory();
      _externalStorageDirectory = getExternalStorageDirectory();
      _externalCacheDirectories = getExternalCacheDirectories();
      _externalStorageDirectories = getExternalStorageDirectories();
    });
  }

  Future<File> get _localFile async {
    final Directory dir = await getApplicationDocumentsDirectory();
    final targetPath = '${dir.path}/path_provider_test_result.txt';

    return File(targetPath);
  }

  Future<void> _saveData() async {
    final file = await _localFile;

    final jsonEncoder = JsonEncoder.withIndent('  '); // 两个空格作为 intent
    final data = jsonEncoder.convert(DI_ZI_GUI_LIST);

    file.writeAsString(data, mode: FileMode.writeOnly).then((File f) {
      showDialog<dynamic>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('存储成功'),
            content: Text('存储路径: ${f.path}'),
          );
        },
      );
    }).catchError((dynamic err) {
      print(err);
    });
  }

  Future<void> _loadData() async {
    final file = await _localFile;

    file.readAsString().then((data) {
      showDialog<dynamic>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            title: Text('读取成功'),
            content: Text(data),
          );
        },
      );
    }).catchError((dynamic err) {
      print(err);
    });
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

  Widget _buildDirectory(
    BuildContext context,
    AsyncSnapshot<Directory> snapshot,
  ) {
    Text text = const Text('');

    if (snapshot.connectionState == ConnectionState.done) {
      if (snapshot.hasError) {
        text = Text('Error: ${snapshot.error}');
      } else if (snapshot.hasData) {
        text = Text('path: ${snapshot.data.path}');
      } else {
        text = const Text('path unavailable');
      }
    }

    return Padding(
      padding: EdgeInsets.only(
        top: 4,
        bottom: 16,
      ),
      child: text,
    );
  }

  Widget _buildDirectories(
    BuildContext context,
    AsyncSnapshot<List<Directory>> snapshot,
  ) {
    Text text = const Text('');

    if (snapshot.connectionState == ConnectionState.done) {
      if (snapshot.hasError) {
        text = Text('Error: ${snapshot.error}');
      } else if (snapshot.hasData) {
        final String combined = snapshot.data.map((Directory d) => d.path).join(', ');
        text = Text('paths: $combined');
      } else {
        text = const Text('path unavailable');
      }
    }

    return Padding(
      padding: EdgeInsets.only(
        top: 4,
        bottom: 16,
      ),
      child: text,
    );
  }

  Widget _buildDirectoryItem(
    String title,
    Future<Directory> future,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        FutureBuilder<Directory>(
          future: future,
          builder: (
            BuildContext context,
            AsyncSnapshot<Directory> snapshot,
          ) {
            return _buildDirectory(
              context,
              snapshot,
            );
          },
        ),
      ],
    );
  }

  Widget _buildDirectoriesItem(
    String title,
    Future<List<Directory>> future,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        FutureBuilder<List<Directory>>(
          future: future,
          builder: (
            BuildContext context,
            AsyncSnapshot<List<Directory>> snapshot,
          ) {
            return _buildDirectories(
              context,
              snapshot,
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> listViewChildren = [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _headButton(
            title: '存储数据',
            onPressed: _saveData,
          ),
          _headButton(
            title: '读取数据',
            onPressed: _loadData,
          ),
        ],
      ),
      SizedBox(
        height: 40,
        child: Divider(),
      ),
      Container(
        padding: EdgeInsets.only(bottom: 20),
        child: Center(
          child: Text('API 测试结果如下'),
        ),
      ),
      _buildDirectoryItem(
        'getTemporaryDirectory',
        _tempDirectory,
      ),
      _buildDirectoryItem(
        'getApplicationSupportDirectory',
        _appSupportDirectory,
      ),
      _buildDirectoryItem(
        'getLibraryDirectory',
        _appLibraryDirectory,
      ),
      _buildDirectoryItem(
        'getApplicationDocumentsDirectory',
        _appDocumentsDirectory,
      ),
      _buildDirectoryItem(
        'getDownloadsDirectory',
        _downloadDirectory,
      ),
      _buildDirectoryItem(
        'getExternalStorageDirectory',
        _externalStorageDirectory,
      ),
      _buildDirectoriesItem(
        'getExternalStorageDirectories',
        _externalStorageDirectories,
      ),
      _buildDirectoriesItem(
        'getExternalCacheDirectories',
        _externalCacheDirectories,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('path_provider'),
      ),
      body: Center(
        child: ListView(
          padding: EdgeInsets.all(16),
          // itemExtent: 100,
          children: listViewChildren,
        ),
      ),
    );
  }
}
