import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../database/query.dart';
import '../model/notes.dart';

class NoteProvider extends ChangeNotifier {
  final DatabaseQuery _query = DatabaseQuery();
  var logger = Logger();
  bool isLoading = false;
  bool isAscending = true;

  List<Note> _allNotes = [];

  List<Note> get allNotes => _allNotes;

  List<Note> _filterdNote = [];

  List<Note> get filteredNote => _filterdNote;

  /// Retrieves all notes from the database.
  ///
  /// When the function is called, the [isLoading] flag is set to `true` and a
  /// notification is sent to any widgets that are listening to this provider.
  ///
  /// The notes are retrieved from the database using [DatabaseQuery.getNotes].
  ///
  /// If an error occurs during the retrieval process, the error is logged using
  /// the [Logger] class.
  ///
  /// After the retrieval process is complete, the [isLoading] flag is set to
  /// `false` and a notification is sent to any widgets that are listening to this
  /// provider.
  Future<void> getAllNotes() async {
    try {
      isLoading = true;
      notifyListeners();
      final notes = await _query.getNotes();
      _allNotes = notes.map((e) => Note.fromMap(e)).toList();
      _filterdNote = List.from(_allNotes);
      isLoading = false;
      notifyListeners();
    } catch (e) {
      logger.e("Error in Get", error: e);
    }
  }

  /// Creates a new note in the database.
  ///
  /// The note is created using [DatabaseQuery.createNote].
  ///
  /// If an error occurs during the creation process, the error is logged using
  /// the [Logger] class and `false` is returned.
  ///
  /// If the note is created successfully, `true` is returned.
  Future<bool> createNote(Note newNote) async {
    try {
      final bool isCreated = await _query.createNote(newNote);
      return isCreated;
    } catch (e) {
      logger.e("Error in Create", error: e);
      return false;
    }
  }

  /// Updates a note in the database.
  ///
  /// The note is updated using [DatabaseQuery.updateNote].
  ///
  /// If an error occurs during the update process, the error is logged using
  /// the [Logger] class and `false` is returned.
  ///
  /// If the note is updated successfully, `true` is returned.
  Future<bool> updateNote(Note updatedNote) async {
    try {
      final bool isUpdated =
          await _query.updateNote(updatedNote.id!, updatedNote.toMap());
      return isUpdated;
    } catch (e) {
      logger.e("Error in Update", error: e);
      return false;
    }
  }

  /// Deletes a note from the database.
  ///
  /// The note is deleted using [DatabaseQuery.deleteNote].
  ///
  /// If an error occurs during the deletion process, the error is logged using
  /// the [Logger] class and `false` is returned.
  ///
  /// If the note is deleted successfully, `true` is returned.
  Future<bool> deleteNote(int id) async {
    try {
      final bool isDeleted = await _query.deleteNote(id);
      return isDeleted;
    } catch (e) {
      logger.e("Error in delete", error: e);
      return false;
    }
  }

  /// Searches the notes for a given search string.
  ///
  /// The search is case insensitive and is done on both the title and content of
  /// the notes.
  ///
  /// If the [searchString] is empty, the filtered notes are reset to the original
  /// list of notes.
  ///
  /// After the search is done, a notification is sent to any widgets that are
  /// listening to this provider.
  void searchNote(String searchString) {
    if (searchString.isNotEmpty) {
      _filterdNote = _allNotes
          .where((e) =>
              e.title.toLowerCase().contains(searchString.toLowerCase()) ||
              e.content.toLowerCase().contains(searchString.toLowerCase()))
          .toList();
    } else {
      _filterdNote = List.from(_allNotes);
    }
    notifyListeners();
  }

  /// Sorts the notes in ascending or descending order based on the last updated date
  /// and notifies any widgets that are listening to this provider.
  ///
  /// The sort order is toggled between ascending and descending each time the
  /// method is called. The sort order is determined by the [_isAscending] variable.
  ///
  /// The notes are sorted in place.
  void sortNotes() {
    if (!isAscending) {
      _filterdNote.sort((a, b) =>
          DateTime.parse(a.updatedOn).compareTo(DateTime.parse(b.updatedOn)));
    } else {
      _filterdNote.sort((a, b) =>
          DateTime.parse(b.updatedOn).compareTo(DateTime.parse(a.updatedOn)));
    }
    isAscending = !isAscending;
    notifyListeners();
  }
}
