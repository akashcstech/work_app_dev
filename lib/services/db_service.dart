import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import '../models/incident.dart';

class DbService {
  DbService._();
  static final DbService instance = DbService._();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    final dbPath = await getDatabasesPath();
    _db = await openDatabase(
      p.join(dbPath, 'raksha_kavach.db'),
      version: 1,
      onCreate: (db, v) async {
        await db.execute('''
          CREATE TABLE incidents(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            task TEXT NOT NULL,
            description TEXT NOT NULL,
            date TEXT NOT NULL
          )
        ''');
      },
    );
    return _db!;
  }

  Future<int> insertIncident(Incident i) async {
    final db = await database;
    return db.insert('incidents', i.toMap()..remove('id'));
  }

  Future<List<Incident>> getIncidents() async {
    final db = await database;
    final rows = await db.query('incidents', orderBy: 'date DESC');
    return rows.map(Incident.fromMap).toList();
  }

  Future<int> deleteIncident(int id) async {
    final db = await database;
    return db.delete('incidents', where: 'id = ?', whereArgs: [id]);
  }
}
