import '../database/database_helper.dart';
import '../models/student.dart';

class StudentService {
  Future<int> insertStudent(Student student) async {
    final db = await DatabaseHelper.instance.database;

    return await db.insert(
      'students',
      student.toMap(),
    );
  }

  /// Get all students - use with caution for large datasets
  /// Prefer getStudentsPaginated for better performance
  Future<List<Student>> getStudents() async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query('students', orderBy: 'name ASC');
    return result.map((e) => Student.fromMap(e)).toList();
  }

  /// Get students with pagination for better performance
  /// [offset] - number of records to skip
  /// [limit] - number of records to fetch (default 50)
  Future<List<Student>> getStudentsPaginated({
    int offset = 0,
    int limit = 50,
  }) async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query(
      'students',
      orderBy: 'name ASC',
      limit: limit,
      offset: offset,
    );
    return result.map((e) => Student.fromMap(e)).toList();
  }

  /// Get total count of students - optimized database query
  /// Much faster than loading all records just to get count
  Future<int> getStudentCount() async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM students');
    return result.isNotEmpty ? (result[0]['count'] as int?) ?? 0 : 0;
  }

  /// Search students by name - uses database index
  /// Returns only matching records
  Future<List<Student>> searchStudentsByName(String query) async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query(
      'students',
      where: 'name LIKE ?',
      whereArgs: ['%$query%'],
      orderBy: 'name ASC',
    );
    return result.map((e) => Student.fromMap(e)).toList();
  }

  /// Get students by course
  Future<List<Student>> getStudentsByCourse(String course) async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query(
      'students',
      where: 'course = ?',
      whereArgs: [course],
      orderBy: 'name ASC',
    );
    return result.map((e) => Student.fromMap(e)).toList();
  }

  /// Get single student by ID
  Future<Student?> getStudentById(int id) async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query(
      'students',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isEmpty) return null;
    return Student.fromMap(result.first);
  }

  Future<int> deleteStudent(int id) async {
    final db = await DatabaseHelper.instance.database;

    return await db.delete(
      'students',
      where: 'id=?',
      whereArgs: [id],
    );
  }

  /// Update student record
  Future<int> updateStudent(Student student) async {
    final db = await DatabaseHelper.instance.database;
    return await db.update(
      'students',
      student.toMap(),
      where: 'id = ?',
      whereArgs: [student.id],
    );
  }
}
