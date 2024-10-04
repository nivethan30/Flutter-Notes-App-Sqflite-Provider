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
  /// Creates a new note in the database.
  ///
  /// The note is created using [Database.insert]. The [TableNames.notes] table
  /// is used to store the note. The [Note.toMap] method is used to convert the
  /// note to a map that can be used to insert it into the database.
  ///
  /// If an error occurs during the creation process, the error is re-thrown
  /// using [rethrow].
  ///
  /// The method returns `true` if the note is created successfully, and
  /// `false` otherwise.
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
  /// Retrieves all notes from the database.
  ///
  /// The notes are retrieved using [Database.query] on the [TableNames.notes]
  /// table.
  ///
  /// If an error occurs during the retrieval process, the error is re-thrown
  /// using [rethrow].
  ///
  /// The method returns a list of maps that contain the note's data. The map
  /// contains the following keys:
  ///
  /// - id: an auto-incrementing integer primary key
  /// - title: a text field for the title of the note
  /// - content: a text field for the content of the note
  /// - updatedOn: a timestamp field for when the note was last updated
  Future<List<Map<String, dynamic>>> getNotes() async {
    try {
      final db = await _databaseHelper.database;
      return await db.query(TableNames.notes);
    } catch (e) {
      rethrow;
    }
  }

  @override
  /// Updates a note in the database with the given [id] with the values from [newNote].
  ///
  /// The note is updated using [Database.update] on the [TableNames.notes] table.
  ///
  /// If an error occurs during the update process, the error is re-thrown using
  /// [rethrow].
  ///
  /// The method returns `true` if the note is updated successfully, and `false`
  /// otherwise.
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
  /// Deletes a note from the database with the given [id].
  ///
  /// The note is deleted using [Database.delete] on the [TableNames.notes] table.
  ///
  /// If an error occurs during the deletion process, the error is re-thrown using
  /// [rethrow].
  ///
  /// The method returns `true` if the note is deleted successfully, and `false`
  /// otherwise.
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
