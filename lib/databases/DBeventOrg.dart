import 'package:eventy/EndPoints/endpoints.dart';
import 'package:eventy/Static/AppConfig.dart';
import 'package:eventy/databases/DBUserOrganizer.dart';
import 'package:sqflite/sqflite.dart';
import 'DBHelper.dart';

class DBEventOrg {
  static const tableName = 'EventsOrg';

  static const sql_code = '''CREATE TABLE IF NOT EXISTS EventsOrg (
             id INTEGER PRIMARY KEY AUTOINCREMENT,
             remote_id INTEGER,
              title TEXT,
              imagePath TEXT,
              start_date date,
              end_date date,
              accept_directly INTEGER,
              delete_after_deadline INTEGER,
              start_time TEXT,
              end_time TEXT,
              description TEXT,
              attendees INTEGER,
              location TEXT,
              category TEXT,
              code INTEGER,
              flag INTEGER,
              create_date TEXT
             
           )
       ''';

  static Future<List<Map<String, dynamic>>> getAllEvents() async {
    final database = await DBHelper.getDatabase();

    return database.rawQuery('''SELECT 
            id ,
            remote_id,
            title,
            imagePath,
            start_date,
            start_time ,
            description,
            attendees,
            location,
            category,
            flag
          from ${tableName}
          order by title ASC
          ''');
  }

  static Future<List<Map<String, dynamic>>> getAllEventsByKeyword(
      String keyword) async {
    if (keyword.isEmpty || keyword.trim() == '') return getAllEvents();

    final database = await DBHelper.getDatabase();

    return database.rawQuery('''SELECT 
            id ,
            remote_id,
            title,
            imagePath,
            start_date,
            start_time ,
            description,
            attendees,
            location,
            category,
            flag
          from ${tableName}
          Where LOWER(title) like '%${keyword.toLowerCase()}%' 
          order by title ASC
          ''');
  }

  static Future<List<Map<String, dynamic>>> getAllEventsByCategory(
      String category) async {
    if (category.isEmpty || category.trim() == '' || category == 'My feed')
      return getAllEvents();

    final database = await DBHelper.getDatabase();

    return database.rawQuery('''SELECT 
            id ,
            remote_id,
            title,
            imagePath,
            start_date,
            start_time ,
            description,
            attendees,
            location,
            category,
            flag
          from ${tableName}
          Where LOWER(category) like '%${category.toLowerCase()}%' 
          order by title ASC
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
            remote_id,
            title,
            imagePath,
            start_date,
            end_date,
            accept_directly ,
            delete_after_deadline ,
            start_time ,
            end_time,
            description,
            attendees,
            location,
            category
          from ${tableName}
          where flag=1
          ''');
  }

  static Future<bool> uploadModification() async {
    List modifiedData = await getEventsTomodify();
    List<Map<String, dynamic>> user = await DBUserOrganizer.getUser();
    String userEmail = user[0]['email'];
    bool result = await add_event_endpoint(modifiedData, userEmail);
    return result;
  }

  static Future<bool> syncEvents(List<Map<String, dynamic>> remote_data) async {
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
        int booked = item['booked'] ?? 0;
        int saved = item['saved'] ?? 0;
        int accepted = item['accepted'] ?? 0;
        await updateRecord(local_id, {
          'title': item['title'],
          'remote_id': item['id'],
          'imagePath': item['imagePath'],
          'start_date': item['start_date'],
          'start_time': item['start_time'],
          'description': item['description'],
          'location': item['location'],
          'category': item['category'],
          'attendees': item['attendees'],
          'flag': 0
        });

        local_ids.remove(local_id);
      } else {
        int booked = item['booked'] ?? 0;
        int saved = item['saved'] ?? 0;
        int accepted = item['accepted'] ?? 0;
        await insertRecord({
          'title': item['title'],
          'remote_id': item['id'],
          'imagePath': item['imagePath'],
          'start_date': item['start_date'],
          'start_time': item['start_time'],
          'description': item['description'],
          'location': item['location'],
          'category': item['category'],
          'attendees': item['attendees'],
          'flag': 0
        });
      }
    }
    for (int local_id in local_ids) await deleteRecord(local_id);
    return true;
  }

  static Future<bool> service_sync_events() async {
    print("Running Cron Service to get Events");
    await uploadModification();
    print("Modifications are uploaded before sync events");

    List<Map<String, dynamic>> user = await DBUserOrganizer.getUser();
    String orgEmail = user[0]['email'];

    List? remote_data = await endpoint_fetch_org_events(orgEmail);

    if (remote_data != null) {
      await DBEventOrg.syncEvents(remote_data as List<Map<String, dynamic>>);
      return true;
    }
    return false;
  }

  static Future<bool> updateRecord(int id, Map<String, dynamic> data) async {
    print('Recieved data to update >>>>');
    print(data);
    print("                        <<<<");
    final database = await DBHelper.getDatabase();
    database.update(tableName, data, where: "id=?", whereArgs: [id]);
    return true;
  }

  static Future<int> insertRecord(Map<String, dynamic> data) async {
    print("INSERT LOC");
    print(data);
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

  static Future<bool> updateSpecific(int id, String attribute) async {
    final database = await DBHelper.getDatabase();
    if (attribute == 'booked') {
      await database.rawUpdate(
        'UPDATE $tableName SET booked = CASE WHEN booked = 1 THEN 0 ELSE 1 END WHERE id = ?',
        [id],
      );
      await updateFlag(id, 1);
      return true;
    }
    if (attribute == 'saved') {
      await database.rawUpdate(
        'UPDATE $tableName SET saved = CASE WHEN saved = 1 THEN 0 ELSE 1 END WHERE id = ?',
        [id],
      );
      await updateFlag(id, 1);
      return true;
    }
    return false;
  }

  static Future<bool> updateFlag(int id, int value) async {
    final database = await DBHelper.getDatabase();
    await database.rawUpdate(
      'UPDATE $tableName SET flag = ? WHERE id = ?',
      [value, id],
    );
    return true;
  }
}
