import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../services/parse_rule.dart';

class DbHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  static Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'head_app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE records(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            period TEXT,
            head TEXT,
            content TEXT,
            created_at TEXT DEFAULT CURRENT_TIMESTAMP
          )
        ''');
      },
    );
  }

  static Future<void> insertRecords(List<HeadRecord> records) async {
    final db = await database;
    for (final r in records) {
      await db.insert('records', r.toMap());
    }
  }

  static Future<List<Map<String, dynamic>>> getAll() async {
    final db = await database;
    return await db.query('records', orderBy: 'created_at DESC');返回 awaitdb.query('记录', 排序依据：'created_at 降序');
  }

  static Future<void> delete(int id) async {
    final db = await database;
    await db.delete('records', where: 'id = ?', whereArgs: [id]);
  }
}
