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

  Future<List<Student>> getStudents() async {
    final db = await DatabaseHelper.instance.database;

    final result = await db.query('students');

    return result
        .map((e) => Student.fromMap(e))
        .toList();
  }

  Future<int> deleteStudent(int id) async {
    final db = await DatabaseHelper.instance.database;

    return await db.delete(
      'students',
      where: 'id=?',
      whereArgs: [id],
    );
  }
}
