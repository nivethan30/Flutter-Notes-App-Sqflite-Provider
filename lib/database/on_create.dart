import 'table_structure.dart';

class TableCreation {
  /// Called when the database is created for the first time.
  ///
  /// This function is used to create the notes table in the database.
  ///
  /// The table has four columns:
  ///
  /// - id: an auto-incrementing integer primary key
  /// - title: a text field for the title of the note
  /// - content: a text field for the content of the note
  /// - updatedOn: a timestamp field for when the note was last updated
  ///
  /// The function takes two arguments:
  ///
  /// - db: the database connection
  /// - version: the version of the database
  static Future<void> onCreate(db, version) async {
    await db.execute('''
      CREATE TABLE ${TableNames.notes}(
        ${NotesColumn.id} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${NotesColumn.title} TEXT NOT NULL,
        ${NotesColumn.content} NOT NULL,
        ${NotesColumn.updatedOn} TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      ''');
  }
}
