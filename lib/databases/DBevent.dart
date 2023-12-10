import 'package:sqflite/sqflite.dart';
import 'DBHelper.dart';

class DBEvent {
  static const tableName = 'Event';

  static const sql_code = '''CREATE TABLE IF NOT EXISTS companies (
             id INTEGER PRIMARY KEY AUTOINCREMENT,
             remote_id INTEGER,
              title TEXT,
              image_path TEXT,
              date TEXT,
              time TEXT,
              description TEXT,
              attendees INTEGER,
              location TEXT,
              organizer TEXT,
              category TEXT,
              booked INTEGER,
              accepted INTEGER,
              saved INTEGER,
              scanned INTEGER,
              code INTEGER,
              flag INTEGER,
             create_date TEXT
           )
       ''';

  static Future<List<Map<String, dynamic>>> getAllEvents() async {
    final database = await DBHelper.getDatabase();

    return database.rawQuery('''SELECT 
            id ,
            title,
            remote_id,
            image_path,
            date,
            time ,
            description,
            attendees,
            location,
            organizer,
            category,
            booked,
            accepted,
            saved,
            scanned,
            code,
            flag,
          from ${tableName}
          order by name ASC
          ''');
  }

  static Future<List<Map<String, dynamic>>> getAllEventsByKeyword(
      String keyword) async {
    if (keyword.isEmpty || keyword.trim() == '') return getAllEvents();

    final database = await DBHelper.getDatabase();

    return database.rawQuery('''SELECT 
            id ,
            title,
            remote_id,
            image_path,
            date,
            time ,
            description,
            attendees,
            location,
            organizer,
            category,
            booked,
            accepted,
            saved,
            scanned,
            code,
            flag,
          from ${tableName}
          Where LOWER(title) like '%${keyword.toLowerCase()}%' 
          order by name ASC
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

  static Future<List<Map<String, dynamic>>> getEventsTomodify() async {
    final database = await DBHelper.getDatabase();

    return database.rawQuery('''SELECT 
            id ,
            title,
            remote_id,
            image_path,
            date,
            time ,
            description,
            attendees,
            location,
            organizer,
            category,
            booked,
            accepted,
            saved,
            scanned,
            code,
          from ${tableName}
          where flag=1
          ''');
  }

  static Future<bool> syncEvents(
      List<Map<String, dynamic>> remote_data) async {
    List local_data = await getAllEvents();
    Map index_remote = {};
    List local_ids = [];
    for (Map item in local_data) {
      index_remote[item['remote_id']] = item['id'];
      local_ids.add(item['id']);
    }

    for (Map item in remote_data) {
      if (index_remote.containsKey(item['id'])) {
        int local_id = index_remote[item['id']];
        await updateRecord(local_id, {'title': item['title']});
        local_ids.remove(local_id);
      } else {
        await insertRecord({'title': item['title'], 'remote_id': item['id']});
      }
    }
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
