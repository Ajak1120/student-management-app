import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'students.db');

    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE students(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        regNo TEXT NOT NULL,
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        phone TEXT NOT NULL,
        course TEXT NOT NULL,
        year TEXT NOT NULL
      )
    ''');

    // Create indexes for frequently queried fields
    await db.execute('CREATE INDEX idx_students_regNo ON students(regNo)');
    await db.execute('CREATE INDEX idx_students_name ON students(name)');
    await db.execute('CREATE INDEX idx_students_course ON students(course)');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Create indexes if upgrading from v1
      await db.execute('CREATE INDEX IF NOT EXISTS idx_students_regNo ON students(regNo)');
      await db.execute('CREATE INDEX IF NOT EXISTS idx_students_name ON students(name)');
      await db.execute('CREATE INDEX IF NOT EXISTS idx_students_course ON students(course)');
    }
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
