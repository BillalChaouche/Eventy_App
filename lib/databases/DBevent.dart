import 'package:eventy/EndPoints/endpoints.dart';
import 'package:eventy/Static/AppConfig.dart';
import 'package:eventy/databases/DBUserOrganizer.dart';
import 'package:sqflite/sqflite.dart';
import 'DBHelper.dart';

class DBEvent {
  static const tableName = 'Events';

  static const sql_code = '''CREATE TABLE IF NOT EXISTS Events (

             id INTEGER PRIMARY KEY AUTOINCREMENT,
             remote_id INTEGER,
              title TEXT,
              imagePath TEXT,
              date date,
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
            remote_id,
            title,
            imagePath,
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
            flag
          from ${tableName}
          Where LOWER(category) like '%${category.toLowerCase()}%' 
          order by title ASC
          ''');
  }

  static Future<List<Map<String, dynamic>>> getAllEventsByFilter(
      String date, String location) async {
    final database = await DBHelper.getDatabase();

    if ((date.isEmpty || date.trim() == '' || date == 'Any Time') &&
        (location.isEmpty ||
            location.trim() == '' ||
            location == 'Choose Wilaya')) {
      return getAllEvents(); // You might need to implement this method
    }

    DateTime now = DateTime.now();
    late String formattedDate;

    switch (date) {
      case 'Today':
        formattedDate =
            '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
        return await database.rawQuery(
            "SELECT * FROM events WHERE date = '$formattedDate' AND location = '$location'");
      case 'Tomorrow':
        DateTime tomorrow = now.add(Duration(days: 1));
        formattedDate =
            '${tomorrow.year}-${tomorrow.month.toString().padLeft(2, '0')}-${tomorrow.day.toString().padLeft(2, '0')}';
        return await database.rawQuery(
            "SELECT * FROM events WHERE date = '$formattedDate' AND location = '$location'");
      case 'This Week':
        DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        DateTime endOfWeek = startOfWeek.add(Duration(days: 6));
        String startDate =
            '${startOfWeek.year}-${startOfWeek.month.toString().padLeft(2, '0')}-${startOfWeek.day.toString().padLeft(2, '0')}';
        String endDate =
            '${endOfWeek.year}-${endOfWeek.month.toString().padLeft(2, '0')}-${endOfWeek.day.toString().padLeft(2, '0')}';
        return await database.rawQuery(
            "SELECT * FROM events WHERE date BETWEEN '$startDate' AND '$endDate' AND location = '$location'");
      case 'This Month':
        String startDate =
            '${now.year}-${now.month.toString().padLeft(2, '0')}-01';
        String endDate =
            '${now.year}-${now.month.toString().padLeft(2, '0')}-${DateTime(now.year, now.month + 1, 0).day.toString().padLeft(2, '0')}';
        return await database.rawQuery(
            "SELECT * FROM events WHERE date BETWEEN '$startDate' AND '$endDate' AND location = '$location'");
      default:
        return []; // Handle other cases as needed
    }
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
            saved,
            booked
          from ${tableName}
          where flag=1
          ''');
  }

  static Future<bool> uploadModification() async {
    List modifiedData = await getEventsTomodify();
    int event_id = 0;
    int saved = 0;
    int booked = 0;
    List<Map<String, dynamic>> user = await DBUserOrganizer.getUser();
    String userEmail = user[0]['email'];
    for (Map item in modifiedData) {
      event_id = item['remote_id'];
      saved = item['saved'];
      booked = item['booked'];

      await endpoint_api_get(AppConfig.backendBaseUrl +
          'operations_user_event.php?action=events.update&user_email=${userEmail}&event_id=${event_id}&saved=${saved}&booked=${booked}');
      await updateFlag(item['id'], 0);
    }
    return true;
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
          'date': item['start_date'],
          'time': item['start_time'],
          'description': item['description'],
          'location': item['location'],
          'organizer': item['organizer_id'],
          'category': item['category'],
          'attendees': item['attendees'],
          'booked': booked,
          'accepted': accepted,
          'saved': saved,
          'scanned': item['scanned'],
          'code': item['code'],
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
          'date': item['start_date'],
          'time': item['start_time'],
          'description': item['description'],
          'location': item['location'],
          'organizer': item['organizer_id'],
          'category': item['category'],
          'attendees': item['attendees'],
          'booked': booked,
          'accepted': accepted,
          'saved': saved,
          'scanned': item['scanned'],
          'code': item['code'],
          'flag': 0
        });
      }
    }
    for (int local_id in local_ids) await deleteRecord(local_id);
    return true;
  }

  static Future<bool> service_sync_events() async {
    print("Running Cron Service to get Events");
    List<Map<String, dynamic>> user = await DBUserOrganizer.getUser();
    if(user.length != 0){
      String userEmail = user[0]['email'];
    List? remote_data = await endpoint_api_get(AppConfig.backendBaseUrl +
        "operations_user_event.php?action=events.get&email=${userEmail}");

    if (remote_data != null) {
      print(remote_data);
      await DBEvent.syncEvents(remote_data as List<Map<String, dynamic>>);
      return true;
    }

    }
    
    return false;
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
