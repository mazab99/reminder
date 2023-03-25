import 'dart:async';
import 'dart:io';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sqflite/sqflite.dart';

import '../Models/task_model.dart';

class Database_prov with ChangeNotifier {
  static Database? db;
  static const String _tableName = 'tasks';
  static const int _version = 1;

  Future<void> init_db() async {
    if (db != null) {
      debugPrint('not null db');
      return;
    } else {
      try {
        // open the database
        String _path = await getDatabasesPath() + ' tasks.db';
        db = await openDatabase(
          _path,
          version: _version,
          onCreate: (Database db, int version) async {
            print('Creating a new one');
            return await db.execute(
              'CREATE TABLE $_tableName('
              'id INTEGER PRIMARY KEY AUTOINCREMENT,'
              'title STRING,'
              'isCompleted INTEGER,'
              'isFavorites INTEGER,'
              'date STRING,'
              'startTime STRING,'
              'endTime STRING,'
              'color INTEGER,'
              'remind INTEGER,'
              'repeat STRING )',
            );
          },
        );
        debugPrint('open the database With static db');
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  Future<void> Opren_db() async {
    if (db != null) {
      debugPrint('db is not null');
      return Future.value(unit);
    } else {
      String _path = await getDatabasesPath() + 'tasks.db';
      db = await openDatabase(
        _path,
        version: _version,
        onCreate: (Database db, int version) async {
          print('Creating a new one');
          return await db.execute(
            'CREATE TABLE $_tableName('
            'id INTEGER PRIMARY KEY AUTOINCREMENT,'
            'title STRING,'
            'isCompleted INTEGER,'
            'isFavorites INTEGER,'
            'date STRING,'
            'startTime STRING,'
            'endTime STRING,'
            'color INTEGER,'
            'remind INTEGER,'
            'repeat STRING )',
          );
        },
      );
      if (db!.isOpen) {
        debugPrint('db is opened');
        return Future.value(unit);
      } else {
        debugPrint('db is not opened');
      }
    }
  }

  Future<Unit> createTask(TaskModel task) async {
    debugPrint('createTask called');
    return await db!.insert(_tableName, task.toJson()).then((_) {
      debugPrint('createTask success');
      return Future.value(unit);
    }).catchError((error) {
      debugPrint('createTask error');
    });
  }

  Future<List<TaskModel>> getTasks() async {
    debugPrint('getTasks called');
    return await db!.query(_tableName).then((rows) {
      debugPrint('getTasks called success');
      return rows.map((row) {
        notifyListeners();
        return TaskModel.fromJson(row);
      }).toList();
    }).catchError((error) {
      notifyListeners();
      debugPrint('getTasks called error');
    });
  }

  Future<Unit> deleteTask(int taskId) async {
    debugPrint('deleteTask called');
    return await db!
        .delete(_tableName, where: 'id = ?', whereArgs: [taskId]).then((_) {
      debugPrint('deleteTask success');
      return Future.value(unit);
    }).catchError((error) {
      debugPrint('deleteTask error');
    });
  }

  Future<Unit> updateTask(TaskModel task) async {
    debugPrint('updateTask called');
    return await db!.rawUpdate('''
      UPDATE $_tableName SET
      title = ?,
      isCompleted = ?,
      isFavorites = ?,
      date = ?,
      startTime = ?,
      endTime = ?,
      color = ?,
      remind = ?,
      repeat = ?
      WHERE id = ?
      
''', [
      task.title,
      task.isCompleted,
      task.isFavorites,
      task.date,
      task.startTime,
      task.endTime,
      task.color,
      task.remind,
      task.repeat,
      task.id
    ]).then((_) {
      debugPrint('updateTask success');
      return Future.value(unit);
    }).catchError((error) {
      debugPrint('updateTask error');
    });
  }
}
