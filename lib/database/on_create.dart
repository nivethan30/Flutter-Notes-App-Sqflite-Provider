import 'table_structure.dart';

class TableCreation {
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
