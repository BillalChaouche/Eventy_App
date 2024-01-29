import 'dart:convert';
import 'dart:typed_data';

import 'package:eventy/EndPoints/endpoints.dart';
import 'package:eventy/models/SharedData.dart';
import 'package:sqflite/sqflite.dart';
import 'DBHelper.dart';

class DBUserOrganizer {
  static const tableName = 'users';

  static const sql_code = '''CREATE TABLE IF NOT EXISTS users (
             id INTEGER PRIMARY KEY AUTOINCREMENT,
             name TEXT,
              role TEXT,
              imgPath TEXT,
              birth_date TEXT,
              location TEXT,
              phone_number TEXT,
              email TEXT,
              verified INTEGER,
              flag INTEGER,
             create_date TEXT
           )
       ''';

  static Future<List<Map<String, dynamic>>> getUser() async {
    final database = await DBHelper.getDatabase();

    return database.rawQuery('''SELECT 
            id ,
            name,
            role ,
            imgPath,
            birth_date ,
            location ,
            phone_number ,
            email ,
            verified,
            flag
          FROM $tableName
          order by id DESC
          ''');
  }

  static Future<List<Map<String, dynamic>>> getAllUsers() async {
    final database = await DBHelper.getDatabase();

    return database.rawQuery('''SELECT 
            id ,
            name,
            role ,
            imgPath,
            birth_date ,
            location ,
            phone_number ,
            email ,
            verified,
            flag 
          FROM $tableName
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
            role ,
            birth_date ,
            location ,
            phone_number ,
            email ,
            verified,
            flag 
          from $tableName
          Where LOWER(name) like '%${keyword.toLowerCase()}%' 
          order by name ASC
          ''');
  }

  static Future<List<Map<String, dynamic>>> getUsersToUpload() async {
    final database = await DBHelper.getDatabase();

    return database.rawQuery('''SELECT 
            id ,
            name,
            role ,
            birth_date ,
            location ,
            phone_number ,
            email ,
            flag 
          from $tableName
          where flag=1
          ''');
  }

  static Future<bool> uploadModification(String img) async {
    List<Map<String, dynamic>> profile = await getUsersToUpload();
    bool res = false;
    if (await SharedData.instance.getSharedVariable() == "User") {
      res = await profileSetup(profile[0], img, 'index.php');
    } else {
      res =
          await profileSetup(profile[0], img, 'organizer/login_signup_org.php');
    }
    return res;
  }

  static Future<int> getAllCount() async {
    final database = await DBHelper.getDatabase();

    List<Map> res = await database.rawQuery('''SELECT 
            count(id) as cc
          from $tableName
          ''');
    return res[0]['cc'] ?? 0;
  }

  static Future<bool> syncUsers(Map<String, dynamic> remoteData) async {
    // Delete all existing local users
    List localData = await getAllUsers();
    List localIds = [];
    for (Map item in localData) {
      localIds.add(item['id']);
    }

    for (int local_id in localIds) {
      await deleteUser(local_id);
    }

    await insertUser({
      'name': remoteData['name'],
      'role': remoteData['role'],
      'imgPath': remoteData['photo_path'],
      'birth_date': remoteData['birthdate'],
      'location': remoteData['location'],
      'phone_number': remoteData['phone_number'],
      'email': remoteData['email'],
      'verified': remoteData['verified']
    });

    return true;
  }

  static Future<bool> updateUser(int id, Map<String, dynamic> data) async {
    final database = await DBHelper.getDatabase();

    // Iterate through the keys in the original data
    data.forEach((key, value) async {
      // Create a new Map for the specific column to be updated
      Map<String, dynamic> columnData = {};

      if (value is num || value is String || value is Uint8List) {
        // If the value is of a supported type, add it to the column data
        columnData[key] = value;
      } else {
        // If the value is not supported, handle it appropriately
        // For example, convert complex objects like Maps to JSON strings
        columnData[key] = jsonEncode(value);
      }

      // Perform the update for the specific column
      int rowsAffected =
          await database.update(tableName, columnData, where: "id=?");

      if (rowsAffected > 0) {
        print("Column '$key' updated successfully");
      } else {
        print("Column '$key' was not updated");
      }
    });

    return true;
  }

  static Future<bool> service_sync_user() async {
    print("Running Cron Service to get User");
    List<Map<String, dynamic>> user = await DBUserOrganizer.getUser();
    String email = user[0]['email'];
    Map<String, dynamic>? remoteData;
    if (await SharedData.instance.getSharedVariable() == "User") {
      remoteData = await endpoint_fetch_user_info(email, 'index.php');
      print('hi');
      print(remoteData);
    } else {
      remoteData = await endpoint_fetch_user_info(
          email, 'organizer/login_signup_org.php');
    }

    if (remoteData != null) {
      await DBUserOrganizer.syncUsers(remoteData);
      return true;
    }
    return false;
  }

  static Future<int> insertUser(Map<String, dynamic> data) async {
    final database = await DBHelper.getDatabase();

    // Check if the "users" table exists
    var tableExists = await database.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='users'");
    if (tableExists.isEmpty) {
      // Execute the script to create the "users" table
      await database.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
             name TEXT,
              role TEXT,
              birth_date TEXT,
              location TEXT,
              phone_number TEXT,
              email TEXT,
              verified,
              flag INTEGER,
             create_date TEXT
      )
    ''');
    }

    // Insert data into the "users" table
    int id = await database.insert('users', data,
        conflictAlgorithm: ConflictAlgorithm.replace);

    return id;
  }

  static Future<bool> deleteUser(int id) async {
    final database = await DBHelper.getDatabase();
    database.rawQuery("""delete from  $tableName  where id=?""", [id]);
    return true;
  }
}
