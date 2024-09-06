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

  Future<bool> createNote(Note newNote) async {
    try {
      final bool isCreated = await _query.createNote(newNote);
      return isCreated;
    } catch (e) {
      logger.e("Error in Create", error: e);
      return false;
    }
  }

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

  Future<bool> deleteNote(int id) async {
    try {
      final bool isDeleted = await _query.deleteNote(id);
      return isDeleted;
    } catch (e) {
      logger.e("Error in delete", error: e);
      return false;
    }
  }

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
