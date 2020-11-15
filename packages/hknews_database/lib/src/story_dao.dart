import 'package:sqflite/sqflite.dart';

import 'database.dart';
import 'story_entity.dart';

class StoryDao {
  static final StoryDao _dao = StoryDao._internal(AppDatabase());

  AppDatabase _appDatabase;

  //private internal constructor to make it singleton
  StoryDao._internal(this._appDatabase);

  factory StoryDao() => _dao;

  Future<List<StoryEntity>> getStories() async {
    var db = await _appDatabase.getDb();
    var result = await db.rawQuery(
        'SELECT * FROM ${StoryEntity.dbSavedStoriesTableName} ORDER BY ${StoryEntity.dbKeyUpdatedAt} DESC;');

    return result
        .map((story) => StoryEntity.fromDatabase(story))
        .toList(growable: false);
  }

  Future<bool> insertOrReplace(StoryEntity story) async {
    var db = await _appDatabase.getDb();

    return await db.transaction((Transaction trn) async {
      return await _insertOrReplace(trn, story);
    });
  }

  Future<void> insertOrReplaces(List<StoryEntity> stories) async {
    var db = await _appDatabase.getDb();

    await db.transaction((Transaction trn) async {
      stories.forEach((story) {
        _insertOrReplace(trn, story);
      });
    });
  }

  Future<bool> _insertOrReplace(Transaction trn, StoryEntity story) async {
    var changed = await trn.rawInsert(
      'INSERT OR REPLACE INTO '
      '${StoryEntity.dbSavedStoriesTableName}(${StoryEntity.dbKeyId},${StoryEntity.dbKeyTitle},${StoryEntity.dbKeyBy},${StoryEntity.dbKeyDeleted},${StoryEntity.dbKeyTime},${StoryEntity.dbKeyType},${StoryEntity.dbKeyUrl},${StoryEntity.dbKeyText},${StoryEntity.dbKeyScore},${StoryEntity.dbKeyDescendants},${StoryEntity.dbKeyUpdatedAt},${StoryEntity.dbKeyVisited})'
      ' VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
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
        story.updatedAt,
      ],
    );

    return changed == 1;
  }

  Future<bool> deleteStory(int storyId) async {
    var db = await _appDatabase.getDb();

    return db.transaction((Transaction trn) async {
      var changed = await trn.rawDelete(
          'DELETE FROM ${StoryEntity.dbSavedStoriesTableName} WHERE ${StoryEntity.dbKeyId} = $storyId;');

      return changed == 1;
    });
  }

  Future<bool> updateVisitStory(int storyId) async {
    var db = await _appDatabase.getDb();

    return db.transaction((Transaction trn) async {
      var changed = await trn.rawDelete(
          'UPDATE ${StoryEntity.dbSavedStoriesTableName} SET ${StoryEntity.dbKeyVisited}=1 WHERE ${StoryEntity.dbKeyId} = $storyId;');

      return changed == 1;
    });
  }
}
