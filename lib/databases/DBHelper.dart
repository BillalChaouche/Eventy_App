import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:eventy/databases/DBUserOrganizer.dart';
import 'package:eventy/databases/DBcategory.dart';
import 'package:eventy/databases/DBevent.dart';

import 'package:sqflite/sqflite.dart';

class DBHelper {
  static const _database_name = "Eventy.db";
  static const _database_version = 16;
  static var database;

  static Future getDatabase() async {
    if (database != null) {
      return database;
    }
    List sql_create_code = [
      DBUserOrganizer.sql_code,
      DBEvent.sql_code,
      DBCategory.sql_code,
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
          database.execute('DROP TABLE IF EXISTS events');
          database.execute('DROP TABLE IF EXISTS categories');
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
    await db.execute('DROP TABLE IF EXISTS events');
    print("drop table events");
    await db.execute('DROP TABLE IF EXISTS categories');
    print("drop table categories");

    // Recreate the tables
    List<String> sql_create_code = [
      DBUserOrganizer.sql_code,
      DBEvent.sql_code,
      DBCategory.sql_code,
    ];
    for (var sql_code in sql_create_code) await db.execute(sql_code);
  }
}
