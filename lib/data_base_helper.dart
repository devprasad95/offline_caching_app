import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = 'random_datas.db';
  static const _databaseVersion = 1;

  static const table = 'random_datas';

  static const columnId = 'id';
  static const columnUserId = 'userId';
  static const columnTitle = 'title';
  static const columnBody = 'body';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnUserId INTEGER,
            $columnTitle TEXT,
            $columnBody TEXT
          )
          ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows()async{
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<void> clearTable()async {
    Database db = await instance.database;
    await db.delete(table);
  }
}
