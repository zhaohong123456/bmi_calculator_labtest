import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQLiteDB {

  // name of local database
  static const String _dbName = "bitp3453_bmi";

  // object of SQFlite database
  Database? _db;

  SQLiteDB._(); //private constructor
  static final SQLiteDB _instance = SQLiteDB();

  factory SQLiteDB(){
    return _instance;
  }

  Future<Database> get database async {
    if (_db != null) {
      return _db!;
    }
    String path = join(await getDatabasesPath(), _dbName);
    _db =
    await openDatabase(path, version: 1, onCreate: (createdDb, version) async {
      for (String tableSql in SQLiteDB.tableSQLStrings) {
        await createdDb.execute(tableSql);
      }
    },);
    return _db!;
  }

  static List<String> tableSQLStrings =
  [
    '''
    CREATE TABLE IF NOT EXISTS bmi (
      username TEXT,
      weight TEXT,
      height TEXT,
      gender TEXT,
      bmi_status TEXT)
    ''',
  ];

  Future<int> insert(String tableName, Map<String, dynamic> row) async {
    Database db = await _instance.database;
    return await db.insert(tableName, row);
  }

  // retrieve all
  Future<List<Map<String, dynamic>>> queryAll(String tableName) async {
    Database db = await _instance.database;
    return await db.query(tableName);
  }
}