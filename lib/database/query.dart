import 'table_structure.dart';
import '../model/notes.dart';
import 'database_helper.dart';

abstract class DatabaseQueryFunctions {
  Future<bool> createNote(Note note);

  Future<List<Map<String, dynamic>>> getNotes();

  Future<bool> updateNote(int id, Map<String, dynamic> newNote);

  Future<bool> deleteNote(int id);
}

class DatabaseQuery implements DatabaseQueryFunctions {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  Future<bool> createNote(Note note) async {
    try {
      final db = await _databaseHelper.database;
      final int id = await db.insert(TableNames.notes, note.toMap());
      return id > 0;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getNotes() async {
    try {
      final db = await _databaseHelper.database;
      return await db.query(TableNames.notes);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> updateNote(int id, Map<String, dynamic> newNote) async {
    try {
      final db = await _databaseHelper.database;
      final int count = await db.update(TableNames.notes, newNote,
          where: '${NotesColumn.id}=?', whereArgs: [id]);
      return count > 0;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> deleteNote(int id) async {
    try {
      final db = await _databaseHelper.database;
      final count = await db.delete(TableNames.notes,
          where: '${NotesColumn.id}=?', whereArgs: [id]);
      return count > 0;
    } catch (e) {
      rethrow;
    }
  }
}
