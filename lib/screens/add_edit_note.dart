import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import '../model/notes.dart';
import '../provider/note_provider.dart';

class AddEditNote extends StatefulWidget {
  final bool isEdit;
  final Note? note;
  final NoteProvider noteProvider;
  final VoidCallback notify;
  const AddEditNote(
      {super.key,
      required this.isEdit,
      this.note,
      required this.noteProvider,
      required this.notify});

  @override
  State<AddEditNote> createState() => _AddEditNoteState();
}

class _AddEditNoteState extends State<AddEditNote> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    initialize();
    super.initState();
  }

  void initialize() {
    if (widget.isEdit && widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }
  }

  void popContext() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade800.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.arrow_back_ios_new),
                  )),
              TextField(
                controller: _titleController,
                style: const TextStyle(color: Colors.white, fontSize: 30),
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Title',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 30)),
              ),
              TextField(
                controller: _contentController,
                style: const TextStyle(
                  color: Colors.white,
                ),
                maxLines: null,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Type something here',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    )),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (widget.isEdit) {
              updateNote();
            } else {
              createNote();
            }
          },
          child: const Icon(Icons.save),
        ),
      ),
    );
  }

  Future<void> createNote() async {
    try {
      Note newNote = Note(
          title: _titleController.text,
          content: _contentController.text,
          updatedOn: DateTime.now().toIso8601String());
      final bool isCreated = await widget.noteProvider.createNote(newNote);
      if (isCreated) {
        popContext();
        widget.noteProvider.getAllNotes();
        widget.notify();
      } else {
        showAlert(type: QuickAlertType.error, title: "Failed to Create");
      }
    } catch (e) {
      showAlert(type: QuickAlertType.error, title: "Failed to Create");
    }
  }

  Future<void> updateNote() async {
    try {
      Note updatedNote = widget.note!.copyWith(
          title: _titleController.text, content: _contentController.text);
      final bool isUpdated = await widget.noteProvider.updateNote(updatedNote);
      if (isUpdated) {
        widget.noteProvider.getAllNotes();
        popContext();
        widget.notify();
      } else {
        showAlert(type: QuickAlertType.error, title: "Failed to Update");
      }
    } catch (e) {
      showAlert(type: QuickAlertType.error, title: "Failed to Update");
    }
  }

  showAlert({required QuickAlertType type, required String title}) {
    QuickAlert.show(context: context, type: type, title: title);
  }
}
