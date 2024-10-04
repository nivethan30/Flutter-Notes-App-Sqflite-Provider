import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'on_create.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  static Database? _database;
  String dbName = 'notes.db';
  int version = 1;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Initializes the database by creating a database file at [dbPath] if it
  /// doesn't exist, and setting up the database schema if it is the first time
  /// the database is created. If the database already exists, it will open the
  /// existing database. The database version is [version]. If the database is
  /// being upgraded from an older version, the [onUpgrade] function will be
  /// called with the old version and the new version. Returns a [Database]
  /// object.
  Future<Database> _initDatabase() async {
    String dbPath = path.join(await getDatabasesPath(), dbName);
    return await openDatabase(
      dbPath,
      version: version,
      onCreate: TableCreation.onCreate,
      onUpgrade: (db, oldVersion, newVersion) {},
    );
  }
}
