import 'package:sqflite/sqflite.dart';
import 'DBHelper.dart';

class DBUserOrganizer {
  static const tableName = 'users';

  static const sql_code = '''CREATE TABLE IF NOT EXISTS companies (
             id INTEGER PRIMARY KEY AUTOINCREMENT,
             remote_id INTEGER,
             name TEXT,
             photo_path TEXT,
              role TEXT,
              birth_date TEXT,
              location TEXT,
              phone_number TEXT,
              email TEXT,
              flag INTEGER,
             create_date TEXT
           )
       ''';

  static Future<List<Map<String, dynamic>>> getAllUsers() async {
    final database = await DBHelper.getDatabase();

    return database.rawQuery('''SELECT 
            id ,
            name,
            remote_id
            photo_path ,
            role ,
            birth_date ,
            location ,
            phone_number ,
            email ,
            flag ,
          from ${tableName}
          order by name ASC
          ''');
  }

  static Future<List<Map<String, dynamic>>> getAllUsersByKeyword(
      String keyword) async {
    if (keyword.isEmpty || keyword.trim() == '') return getAllUsers();

    final database = await DBHelper.getDatabase();

    return database.rawQuery('''SELECT 
            id ,
            name,
            remote_id
            photo_path ,
            role ,
            birth_date ,
            location ,
            phone_number ,
            email ,
            flag ,
          from ${tableName}
          Where LOWER(name) like '%${keyword.toLowerCase()}%' 
          order by name ASC
          ''');
  }

  static Future<List<Map<String, dynamic>>> getUsersToUpload() async {
    final database = await DBHelper.getDatabase();

    return database.rawQuery('''SELECT 
            id ,
            name,
            remote_id
            photo_path ,
            role ,
            birth_date ,
            location ,
            phone_number ,
            email ,
            flag ,
          from ${tableName}
          where flag=1
          ''');
  }

  static Future<int> getAllCount() async {
    final database = await DBHelper.getDatabase();

    List<Map> res = await database.rawQuery('''SELECT 
            count(id) as cc
          from ${tableName}
          ''');
    return res[0]['cc'] ?? 0;
  }

  static Future<bool> syncUsers(
      List<Map<String, dynamic>> remote_data) async {
    List local_data = await getAllUsers();
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
        await insertRecord({'name': item['name'], 'remote_id': item['id']});
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
    int id = await database.insert(tableName, data,
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  static Future<bool> deleteRecord(int id) async {
    final database = await DBHelper.getDatabase();
    database.rawQuery("""delete from  ${tableName}  where id=?""", [id]);
    return true;
  }
}
