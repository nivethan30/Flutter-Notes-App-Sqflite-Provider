import 'package:flutter/material.dart';
import 'package:notes_app/utils/constants.dart';
import 'package:quickalert/quickalert.dart';
import '../model/notes.dart';
import 'add_edit_note.dart';
import '../provider/note_provider.dart';
import 'package:provider/provider.dart';

class NotesMain extends StatefulWidget {
  const NotesMain({super.key});

  @override
  State<NotesMain> createState() => _NotesMainState();
}

class _NotesMainState extends State<NotesMain> {
  final TextEditingController _searchController = TextEditingController();
  @override

  /// Called when the widget is inserted into the tree.
  ///
  /// This method is used to retrieve all notes from the database as soon as the
  /// widget is inserted into the tree. This is done using
  /// [WidgetsBinding.instance.addPostFrameCallback] to ensure that the widget
  /// has been inserted into the tree and the provider is available.
  ///
  /// The [listen] parameter of [Provider.of] is set to `false` to avoid
  /// rebuilding the widget when the provider changes.
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NoteProvider>(context, listen: false).getAllNotes();
    });
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

  /// Builds the main screen of the app.
  ///
  /// The main screen shows all notes in a list view. The notes are sorted by
  /// their updated time in descending order.
  ///
  /// The screen also contains a search field where the user can search for notes
  /// by their title or content.
  ///
  /// Each note is displayed in a card with the title and content. The title is
  /// displayed in bold font and the content is displayed in a regular font.
  ///
  /// The user can tap on a note to edit it. The note is passed to the
  /// [AddEditNote] screen where the user can edit the note.
  ///
  /// The user can also delete a note by tapping on the delete button in the
  /// trailing of the card. The note is deleted from the database and the list
  /// view is updated.
  ///
  /// The screen also contains a floating action button which can be used to
  /// create a new note. The note is created in the database and the list view
  /// is updated.
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context);
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Notes', style: TextStyle(fontSize: 26)),
                  IconButton(
                      onPressed: () {
                        noteProvider.sortNotes();
                      },
                      icon: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade800.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.sort),
                      )),
                ],
              ),
              const SizedBox(height: 5),
              searchField(noteProvider),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                    itemCount: noteProvider.filteredNote.length,
                    itemBuilder: (context, index) {
                      Note note = noteProvider.filteredNote[index];
                      return Card(
                        elevation: 3,
                        color: getRandomColors(),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddEditNote(
                                        isEdit: true,
                                        note: note,
                                        noteProvider: noteProvider,
                                        notify: () {
                                          showAlert(
                                              type: QuickAlertType.success,
                                              title: "Note Updated");
                                        })));
                          },
                          textColor: Colors.white,
                          title: RichText(
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              text: TextSpan(
                                  text: '${note.title}\n',
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins',
                                      height: 1.5),
                                  children: [
                                    TextSpan(
                                        text: note.content,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal,
                                            fontFamily: 'Poppins',
                                            height: 1.5))
                                  ])),
                          subtitle: Text(
                            "Updated: ${formatDateTime(DateTime.parse(note.updatedOn))}",
                            style: const TextStyle(
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                                fontFamily: 'Poppins',
                                color: Colors.black),
                          ),
                          trailing: IconButton(
                              onPressed: () async {
                                final bool isDeleted =
                                    await noteProvider.deleteNote(note.id!);
                                if (isDeleted) {
                                  showAlert(
                                      type: QuickAlertType.success,
                                      title: "Deleted Successfully");
                                  noteProvider.getAllNotes();
                                } else {
                                  showAlert(
                                      type: QuickAlertType.error,
                                      title: "Failed to Delete");
                                }
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.black,
                              )),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddEditNote(
                        isEdit: false,
                        noteProvider: noteProvider,
                        notify: () {
                          showAlert(
                              type: QuickAlertType.success,
                              title: "Note Created");
                        })));
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  /// A TextField used to search notes. The onChanged callback is connected to
  /// [NoteProvider.searchNote] so that the notes are filtered as the user types.
  ///
  /// The search field is styled to have a grey background and a circular border
  /// with a search icon as a prefix. The field is filled by default and has a
  /// transparent border when it is focused.
  TextField searchField(NoteProvider noteProvider) {
    return TextField(
      textCapitalization: TextCapitalization.sentences,
      controller: _searchController,
      onChanged: (value) => noteProvider.searchNote(value),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        hintText: 'Search Note...',
        prefixIcon: const Icon(Icons.search),
        fillColor: Colors.grey.shade800,
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
      ),
    );
  }

  showAlert({required QuickAlertType type, required String title}) {
    QuickAlert.show(context: context, type: type, title: title);
  }
}
