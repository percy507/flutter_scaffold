import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseUtils {
  static Database db;
  static String dbName;
  static String dbPath;

  /// 初始化 [sqlite]
  static Future<void> init() async {
    final String _folder = await getDatabasesPath();

    dbName = 'test_sqflite.db';
    dbPath = join(_folder, dbName);
    db = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (Database db, int version) async {
        return await db.execute(
          '''
          CREATE TABLE User (
            id integer primary key AUTOINCREMENT,
            name TEXT,
            age TEXT,
            sex integer
          )
          ''',
        );
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {},
    );
  }
}
