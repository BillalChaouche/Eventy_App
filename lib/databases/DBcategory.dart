import 'package:eventy/EndPoints/endpoints.dart';
import 'package:sqflite/sqflite.dart';
import 'DBHelper.dart';

class DBCategory {
  static const tableName = 'categories';

  static const sql_code = '''
         CREATE TABLE IF NOT EXISTS categories (
             id INTEGER PRIMARY KEY AUTOINCREMENT,
             remote_id INTEGER,
             name TEXT,
             icon TEXT,
             create_date TEXT
           );''';
  static Future<List<Map<String, dynamic>>> getAllCategories() async {
    final database = await DBHelper.getDatabase();
    return database.rawQuery('''SELECT 
            id ,
            name,
            icon,
            remote_id
          from ${tableName}
          ''');
  }

  static Future<int> getCategoryByName(String name) async {
    final database = await DBHelper.getDatabase();

    List<Map> res = await database.rawQuery('''SELECT 
            id  
          from ${tableName}
          where name='$name'
          ''');
    return res[0]['id'] ?? 0;
  }

  static Future<int> getAllCount() async {
    final database = await DBHelper.getDatabase();

    List<Map> res = await database.rawQuery('''SELECT 
            count(id) as cc
          from ${tableName}
          order by name ASC
          ''');
    return res[0]['cc'] ?? 0;
  }

  static Future<bool> service_sync_categories() async {
    print("Running Cron Service to get Categories");
    List? remote_data = await endpoint_api_get_categories();

    if (remote_data != null) {
      await DBCategory.syncCategories(
          remote_data as List<Map<String, dynamic>>);
      return true;
    }
    return false;
  }

  static Future<bool> syncCategories(
      List<Map<String, dynamic>> remote_data) async {
    List local_data = await getAllCategories();
    Map index_remote = {};
    List local_ids = [];
    for (Map item in local_data) {
      index_remote[item['remote_id']] = item['id'];
      local_ids.add(item['id']);
    }

    for (Map item in remote_data) {
      if (index_remote.containsKey(item['id'])) {
        int local_id = index_remote[item['id']];
        await updateRecord(local_id, {'name': item['name']});
        local_ids.remove(local_id);
      } else {
        await insertRecord({
          'name': item['name'],
          'icon': item['icon'],
          'remote_id': item['id']
        });
      }
    }
    //Remote Local Categories...
    //There is a RISK ? in case items pending with old data?
    for (int local_id in local_ids) await deleteRecord(local_id);
    return true;
  }

  static Future<bool> updateRecord(int id, Map<String, dynamic> data) async {
    final database = await DBHelper.getDatabase();
    database.update(tableName, data, where: "id=?", whereArgs: [id]);
    return true;
  }

  static Future<int> insertRecord(Map<String, dynamic> data) async {
    final database = await DBHelper.getDatabase();
    return await database.insert(tableName, data,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<bool> deleteRecord(int id) async {
    final database = await DBHelper.getDatabase();
    database.rawQuery("""delete from  ${tableName}  where id=?""", [id]);
    return true;
  }
}
