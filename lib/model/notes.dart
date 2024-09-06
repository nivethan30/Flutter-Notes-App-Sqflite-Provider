// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:notes_app/database/table_structure.dart';

class Note {
  int? id;
  String title;
  String content;
  String updatedOn;
  Note({
    this.id,
    required this.title,
    required this.content,
    required this.updatedOn,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      NotesColumn.title: title,
      NotesColumn.content: content,
      NotesColumn.updatedOn: updatedOn,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map[NotesColumn.id] as int,
      title: map[NotesColumn.title] as String,
      content: map[NotesColumn.content] as String,
      updatedOn: map[NotesColumn.updatedOn] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Note.fromJson(String source) =>
      Note.fromMap(json.decode(source) as Map<String, dynamic>);

  Note copyWith({
    int? id,
    String? title,
    String? content,
    String? updatedOn,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      updatedOn: updatedOn ?? this.updatedOn,
    );
  }
}
