import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'models/language.dart';
import 'models/group.dart';
import 'models/entry.dart';

class DatabaseService {
  // Singleton pattern
  static final DatabaseService _databaseService = DatabaseService._internal();
  factory DatabaseService() {
    print("Constructor");
    return _databaseService;
  }
  DatabaseService._internal();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    // Initialize the DB first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  Future<void> _onCreate(Database db, int version) async {
    print("---Creating database---");
    await db.execute(
        'CREATE TABLE entry(id INTEGER PRIMARY KEY, value TEXT, translation TEXT, sourceLangId INTEGER, translationLangId INTEGER, groupId INTEGER, count INTEGER)');

    await db
        .execute('CREATE TABLE group__c(id INTEGER PRIMARY KEY, name TEXT)');
    await db.execute(
        'CREATE TABLE language(id INTEGER PRIMARY KEY, name TEXT, path TEXT, symbol TEXT)');

    await db.execute(
        "INSERT INTO language (name, path, symbol) VALUES ('ingles', 'icons/flags/png/us.png','en')");
    await db.execute(
        "INSERT INTO language (name, path, symbol) VALUES ('aleman', 'icons/flags/png/de.png','en')");
    await db.execute(
        "INSERT INTO language (name, path, symbol) VALUES ('ingles', 'icons/flags/png/mx.png','es')");
    await db.execute("INSERT INTO group__c (name) VALUES ('todo')");
  }
  /*
      await insertLanguage(
        Language(name: "ingles", path: "icons/flags/png/us.png", symbol: "en"));
    await insertLanguage(
        Language(name: "aleman", path: "icons/flags/png/de.png", symbol: "de"));
    await insertLanguage(
        Language(name: "ingles", path: "icons/flags/png/mx.png", symbol: "es"));
    await insertGroup(Group(name: 'all'));
  */

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'flutter_sqflite_database.db');
    return await openDatabase(path,
        onCreate: _onCreate,
        version: 1,
        onConfigure: (db) async =>
            await db.execute('PRAGMA foreign_keys = ON'));
  }

  Future<void> insertLanguage(Language language) async {
    final db = await _databaseService.database;
    await db.insert(
      'language',
      language.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Language>> languages() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query('language');

    return List.generate(maps.length, (i) {
      return Language(
          id: maps[i]['id'],
          name: maps[i]['name'],
          path: maps[i]['path'],
          symbol: maps[i]['symbol']);
    });
  }

  Future<void> updateLanguage(Language language) async {
    final db = await _databaseService.database;
    await db.update(
      'language',
      language.toMap(),
      where: 'id = ?',
      whereArgs: [language.id],
    );
  }

  Future<void> deleteLanguage(int id) async {
    final db = await _databaseService.database;
    await db.delete(
      'language',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> insertGroup(Group group) async {
    final db = await _databaseService.database;
    await db.insert(
      'group__c',
      group.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Group>> groups() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query('group__c');

    return List.generate(maps.length, (i) {
      return Group(id: maps[i]['id'], name: maps[i]['name']);
    });
  }

  Future<void> updateGroup(Group group) async {
    final db = await _databaseService.database;
    await db.update(
      'group__c',
      group.toMap(),
      where: 'id = ?',
      whereArgs: [group.id],
    );
  }

  Future<void> deleteGroup(int id) async {
    final db = await _databaseService.database;
    await db.delete(
      'group__c',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> insertEntry(Entry entry) async {
    final db = await _databaseService.database;
    await db.insert(
      'entry',
      entry.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Entry>> entries(int id) async {
    print(id);
    final db = await _databaseService.database;
    if (id == 1) {
      final List<Map<String, dynamic>> maps =
          await db.query('entry', orderBy: "count DESC");
      return List.generate(maps.length, (i) {
        return Entry(
            id: maps[i]['id'],
            value: maps[i]['value'],
            translation: maps[i]['translation'],
            sourceLangId: maps[i]['sourceLangId'],
            translationLangId: maps[i]['translationLangId'],
            groupId: maps[i]['groupId'],
            count: maps[i]['count']);
      });
    }
    final List<Map<String, dynamic>> maps = await db.query(
      'entry',
      where: 'groupId = ?',
      whereArgs: [id],
    );
    return List.generate(maps.length, (i) {
      return Entry(
          id: maps[i]['id'],
          value: maps[i]['value'],
          translation: maps[i]['translation'],
          sourceLangId: maps[i]['sourceLangId'],
          translationLangId: maps[i]['translationLangId'],
          groupId: maps[i]['groupId'],
          count: maps[i]['count']);
    });
  }

  Future<void> updateEntry(Entry entry) async {
    final db = await _databaseService.database;
    await db.update(
      'entry',
      entry.toMap(),
      where: 'id = ?',
      whereArgs: [entry.id],
    );
  }

  Future<void> updateEntryById(Entry entry, int id) async {
    final db = await _databaseService.database;
    await db.update(
      'entry',
      entry.toMap(),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteEntry(int id) async {
    final db = await _databaseService.database;
    await db.delete(
      'entry',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
