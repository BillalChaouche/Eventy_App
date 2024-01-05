import 'dart:async';
import 'package:eventy/databases/DBeventOrg.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:eventy/databases/DBUserOrganizer.dart';
import 'package:eventy/databases/DBcategory.dart';
import 'package:eventy/databases/DBevent.dart';

import 'package:sqflite/sqflite.dart';

class DBHelper {
  static const _database_name = "Eventy.db";
  static const _database_version = 17;
  static var database;

  static Future getDatabase() async {
    if (database != null) {
      return database;
    }
    List sql_create_code = [
      DBUserOrganizer.sql_code,
      DBEvent.sql_code,
      DBCategory.sql_code,
      DBEventOrg.sql_code,
    ];
    database = openDatabase(
      join(await getDatabasesPath(), _database_name),
      onCreate: (database, version) {
        for (var sql_code in sql_create_code) database.execute(sql_code);
      },
      version: _database_version,
      onUpgrade: (database, oldVersion, newVersion) {
        print(">>>>>>>>>>>>>$oldVersion vs $newVersion");
        if (oldVersion != newVersion) {
          database.execute('DROP TABLE IF EXISTS users');

          database.execute('DROP TABLE IF EXISTS Events');
          database.execute('DROP TABLE IF EXISTS categories');
          database.execute('DROP TABLE IF EXISTS EventsOrg');

          for (var sql_code in sql_create_code) database.execute(sql_code);
        }
      },
    );
    return database;
  }

  static Future<void> deleteDatabase() async {
    final db = await database;

    // Add code here to delete all tables
    await db.execute('DROP TABLE IF EXISTS users');
    print("drop table users");

    await db.execute('DROP TABLE IF EXISTS Events');
    print("drop table events");
    await db.execute('DROP TABLE IF EXISTS categories');
    print("drop table categories");
    await db.execute('DROP TABLE IF EXISTS EventsOrg');
    print("drop table EventsOrg");

    // Recreate the tables
    List<String> sql_create_code = [
      DBUserOrganizer.sql_code,
      DBEvent.sql_code,
      DBCategory.sql_code,
    ];
    for (var sql_code in sql_create_code) await db.execute(sql_code);
  }
}
