import 'package:sqflite/sqflite.dart';

import '../models/index.dart';
import 'database.dart';

class StoryDao {
  static final StoryDao _dao = StoryDao._internal(AppDatabase.get());

  AppDatabase _appDatabase;

  //private internal constructor to make it singleton
  StoryDao._internal(this._appDatabase);

  static StoryDao get() {
    return _dao;
  }

  Future<List<Story>> getStories(StoryType type) async {
    print('get $type');
    var db = await _appDatabase.getDb();

    var result = await db.rawQuery('SELECT * FROM ${Story.dbSavedStoriesTableName};');

    return result.map((item) => Story.fromDb(item)).toList(growable: false);
  }

  Future insertOrReplace(Story story) async {
    var db = await _appDatabase.getDb();

    await db.transaction((Transaction trn) async {
      await _insertOrReplace(trn, story);
    });
  }

  Future insertOrReplaces(List<Story> stories) async {
    var db = await _appDatabase.getDb();

    await db.transaction((Transaction trn) async {
      stories.forEach((story) {
        _insertOrReplace(trn, story);
      });
    });
  }

  Future _insertOrReplace(Transaction trn, Story story) async {
    await trn.rawInsert(
      'INSERT OR REPLACE INTO '
      '${Story.dbSavedStoriesTableName}(${Story.dbKeyId},${Story.dbKeyTitle},${Story.dbKeyBy},${Story.dbKeyDeleted},${Story.dbKeyTime},${Story.dbKeyType},${Story.dbKeyUrl},${Story.dbKeyText},${Story.dbKeyScore},${Story.dbKeyDescendants})'
      ' VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
      [
        story.id,
        story.title,
        story.by,
        story.deleted ? 1 : 0,
        story.time,
        story.type,
        story.url,
        story.text,
        story.score,
        story.descendants,
      ],
    );
  }

  Future deleteStory(int storyId) async {
    var db = await _appDatabase.getDb();

    await db.transaction((Transaction trn) async {
      await trn.rawDelete(
          'DELETE FROM ${Story.dbSavedStoriesTableName} WHERE ${Story.dbKeyId} = $storyId;');
    });
  }
}
