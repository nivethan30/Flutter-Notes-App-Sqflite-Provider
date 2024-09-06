import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';
import '../model/notes.dart';
import '../utils/colors.dart';
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NoteProvider>(context, listen: false).getAllNotes();
    });
  }

  Color getRandomColors() {
    math.Random random = math.Random();
    return backgroundColors[random.nextInt(backgroundColors.length)];
  }

  void popContext() {
    Navigator.pop(context);
  }

  @override
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
                            "Edited: ${DateFormat("dd-MM-yyyy, hh:mm:ss").format(DateTime.parse(note.updatedOn))}",
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

  TextField searchField(NoteProvider noteProvider) {
    return TextField(
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
