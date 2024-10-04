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

  /// Called when the widget is inserted into the tree.
  ///
  /// This method is used to initialize the text editing controllers with the
  /// values from the note if the widget is in edit mode.
  ///
  /// The [initialize] method is called to perform the initialization.
  ///
  /// The [super.initState] method is called to complete the initialization of
  /// the widget.
  void initState() {
    initialize();
    super.initState();
  }

  /// Initializes the text editing controllers with the values from the note if
  /// the widget is in edit mode.
  ///
  /// This method is called in [initState] to perform the initialization.
  ///
  /// The [TextEditingController.text] property of the controllers is set to the
  /// title and content of the note if the widget is in edit mode and the note
  /// is not null. Otherwise, the controllers are not initialized.
  void initialize() {
    if (widget.isEdit && widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }
  }

  /// Pops the current context off the navigator that most tightly encloses the
  /// given `context`.
  ///
  /// This is used to go back to the previous screen when the "Back" button is
  /// pressed in the app bar.
  ///
  /// See also:
  ///
  /// * [Navigator.pop]
  void popContext() {
    Navigator.pop(context);
  }

  @override

  /// Builds the main widget of the Add/Edit Note screen.
  ///
  /// This widget is a [SafeArea] widget that contains a [Scaffold] widget with
  /// a [SingleChildScrollView] as its body. The [SingleChildScrollView] widget
  /// contains a [Padding] widget with a [Column] widget as its child. The
  /// [Column] widget contains an [IconButton] widget to go back to the previous
  /// screen, a [TextField] widget for the title of the note, a [TextField] widget
  /// for the content of the note, and a [FloatingActionButton] widget to save
  /// the note.
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
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

  /// Creates a new note with the provided [title] and [content] and saves it to the
  /// database. If the note is created successfully, it pops the current context off
  /// the navigator, retrieves all notes from the database and notifies the parent
  /// widget. If the note is not created successfully, it shows an error alert with
  /// the title "Failed to Create".
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

  /// Updates the current note with the provided [title] and [content] and saves it to
  /// the database. If the note is updated successfully, it pops the current context off
  /// the navigator, retrieves all notes from the database and notifies the parent
  /// widget. If the note is not updated successfully, it shows an error alert with
  /// the title "Failed to Update".
  Future<void> updateNote() async {
    try {
      Note updatedNote = widget.note!.copyWith(
          title: _titleController.text,
          content: _contentController.text,
          updatedOn: DateTime.now().toIso8601String());
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
