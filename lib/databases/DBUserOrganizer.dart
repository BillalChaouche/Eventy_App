import 'dart:convert';
import 'dart:typed_data';

import 'package:sqflite/sqflite.dart';
import 'DBHelper.dart';

class DBUserOrganizer {
  static const tableName = 'users';

  static const sql_code = '''CREATE TABLE IF NOT EXISTS users (
             id INTEGER PRIMARY KEY AUTOINCREMENT,
             name TEXT,
              role TEXT,
              birth_date TEXT,
              location TEXT,
              phone_number TEXT,
              email TEXT,
              verified
              flag INTEGER,
             create_date TEXT
           )
       ''';

  static Future<List<Map<String, dynamic>>> getUser() async {
    final database = await DBHelper.getDatabase();

    return database.rawQuery('''SELECT 
            id,
            name,
            email,
            verified
          FROM ${tableName}
          order by id DESC
          ''');
  }

  static Future<List<Map<String, dynamic>>> getAllUsers() async {
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
          FROM ${tableName}
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
            role ,
            birth_date ,
            location ,
            phone_number ,
            email ,
            flag 
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

  static Future<bool> syncUsers(List<Map<String, dynamic>> remote_data) async {
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
        await updateUser(local_id, {'name': item['name']});
        local_ids.remove(local_id);
      } else {
        await insertUser({'name': item['name'], 'remote_id': item['id']});
      }
    }

    for (int local_id in local_ids) await deleteUser(local_id);
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
    database.rawQuery("""delete from  ${tableName}  where id=?""", [id]);
    return true;
  }
}
