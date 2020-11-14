import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'story_entity.dart';

/// This is the singleton database class which handlers all database transactions
/// All the task raw queries is handle here and return a Future<T> with result
class AppDatabase {
  static const _dbName = 'hknews.db';
  static const _dbVersion = 1;

  static final AppDatabase _appDatabase = AppDatabase._internal();

  //private internal constructor to make it singleton
  AppDatabase._internal();

  Database _database;

  factory AppDatabase() => _appDatabase;

  /// Use this method to access the database, because initialization of the database (it has to go through the method channel)
  Future<Database> _getDb() async {
    if (!didInit) await _init();
    return _database;
  }

  bool didInit = false;

  /// Use this method to access the database which will provide you future of [Database],
  /// because initialization of the database (it has to go through the method channel)
  Future<Database> getDb() async {
    if (!didInit) await _init();
    return _database;
  }

  Future<void> _init() async {
    // Get a location using path_provider
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _dbName);
    _database = await openDatabase(path, version: _dbVersion,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await _createStoriesTable(db);
    }, onUpgrade: (Database db, int oldVersion, int newVersion) async {
      await db.execute("DROP TABLE ${StoryEntity.dbSavedStoriesTableName}");
      await _createStoriesTable(db);
    });
    didInit = true;
  }

  Future<void> _createStoriesTable(Database db) {
    return db.transaction((Transaction txn) async {
      txn.execute("CREATE TABLE ${StoryEntity.dbSavedStoriesTableName} ("
          "${StoryEntity.dbKeyId} INTEGER PRIMARY KEY,"
          "${StoryEntity.dbKeyTitle} TEXT,"
          "${StoryEntity.dbKeyBy} TEXT,"
          "${StoryEntity.dbKeyDeleted} INTEGER,"
          "${StoryEntity.dbKeyTime} INTEGER,"
          "${StoryEntity.dbKeyType} TEXT,"
          "${StoryEntity.dbKeyUrl} TEXT,"
          "${StoryEntity.dbKeyText} TEXT,"
          "${StoryEntity.dbKeyScore} INTEGER,"
          "${StoryEntity.dbKeyDescendants} INTEGER,"
          "${StoryEntity.dbKeyUpdatedAt} INTEGER,"
          "${StoryEntity.dbKeyVisited} INTEGER);");
    });
  }

  Future<void> close() async {
    var db = await _getDb();
    return db.close();
  }
}
