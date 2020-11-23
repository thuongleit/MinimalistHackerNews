import 'package:sqflite/sqflite.dart';

import 'database.dart';
import 'item_entity.dart';

class StoryDao {
  static final StoryDao _dao = StoryDao._internal(AppDatabase());

  AppDatabase _appDatabase;

  //private internal constructor to make it singleton
  StoryDao._internal(this._appDatabase);

  factory StoryDao() => _dao;

  Future<List<ItemEntity>> getItems() async {
    var db = await _appDatabase.getDb();
    var result = await db.rawQuery(
        'SELECT * FROM ${ItemEntity.dbSavedStoriesTableName} ORDER BY ${ItemEntity.dbKeyUpdatedAt} DESC;');

    return result
        .map((item) => ItemEntity.fromDatabase(item))
        .toList(growable: false);
  }

  Future<bool> insertOrReplace(ItemEntity item) async {
    var db = await _appDatabase.getDb();

    return await db.transaction((Transaction trn) async {
      return await _insertOrReplace(trn, item);
    });
  }

  Future<void> insertOrReplaces(List<ItemEntity> items) async {
    var db = await _appDatabase.getDb();

    await db.transaction((Transaction trn) async {
      items.forEach((item) {
        _insertOrReplace(trn, item);
      });
    });
  }

  Future<bool> _insertOrReplace(Transaction trn, ItemEntity item) async {
    var changed = await trn.rawInsert(
      'INSERT OR REPLACE INTO '
      '${ItemEntity.dbSavedStoriesTableName}(${ItemEntity.dbKeyId},${ItemEntity.dbKeyTitle},${ItemEntity.dbKeyBy},${ItemEntity.dbKeyDeleted},${ItemEntity.dbKeyTime},${ItemEntity.dbKeyType},${ItemEntity.dbKeyUrl},${ItemEntity.dbKeyText},${ItemEntity.dbKeyScore},${ItemEntity.dbKeyDescendants},${ItemEntity.dbKeyUpdatedAt},${ItemEntity.dbKeyVisited})'
      ' VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
      [
        item.id,
        item.title,
        item.by,
        item.deleted ? 1 : 0,
        item.time,
        item.type,
        item.url,
        item.text,
        item.score,
        item.descendants,
        item.updatedAt,
      ],
    );

    return changed == 1;
  }

  Future<bool> deleteStory(int itemId) async {
    var db = await _appDatabase.getDb();

    return db.transaction((Transaction trn) async {
      var changed = await trn.rawDelete(
          'DELETE FROM ${ItemEntity.dbSavedStoriesTableName} WHERE ${ItemEntity.dbKeyId} = $itemId;');

      return changed == 1;
    });
  }

  Future<bool> updateVisitStory(int itemId) async {
    var db = await _appDatabase.getDb();

    return db.transaction((Transaction trn) async {
      var changed = await trn.rawDelete(
          'UPDATE ${ItemEntity.dbSavedStoriesTableName} SET ${ItemEntity.dbKeyVisited}=1 WHERE ${ItemEntity.dbKeyId} = $itemId;');

      return changed == 1;
    });
  }
}
