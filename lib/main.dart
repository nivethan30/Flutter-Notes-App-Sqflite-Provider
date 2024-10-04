import 'package:flutter/material.dart';
import 'screens/notes_main.dart';
import 'provider/note_provider.dart';
import 'package:provider/provider.dart';

/// The application entry point.
///
/// Ensures that the widgets binding is initialized and runs the application.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  /// Builds the root widget of the application.
  ///
  /// This widget is the top most widget and is the ancestor of all other widgets
  /// in the application. It is a [MaterialApp] which is the root of the
  /// material library and is used to configure the top-level routing of the app,
  /// and is the parent of the [NotesMain] widget which is the main widget of the
  /// app.
  ///
  /// The [ChangeNotifierProvider] widget is used to provide the [NoteProvider]
  /// to the app, which is used to store and manage the notes.
  ///
  /// The app is configured to use the dark theme and the Poppins font family.
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NoteProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Notes App',
        theme: ThemeData.dark().copyWith(
            textTheme: ThemeData.dark().textTheme.apply(fontFamily: 'Poppins')),
        home: const NotesMain(),
      ),
    );
  }
}
