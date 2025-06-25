import 'dart:io';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/questions_data.dart';

class DBService {
  static late Database _db;

  static Future<Database> get database async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'gkquiz.db');

    if (!await databaseExists(path)) {
      ByteData data = await rootBundle.load('assets/gkquiz.db');
      await File(path).writeAsBytes(
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
        flush: true,
      );
    }

    _db = await openDatabase(path);
    return _db;
  }

  static Future<List<QuestionsModel>> getAllQuestions() async {
    final db = await database;
    final maps = await db.query('question_table');
    return maps.map((e) => QuestionsModel.fromMap(e)).toList();
  }
  
  static Future<List<QuestionsModel>> getQuestionsByTopic(String topic) async {
    final db = await database;
    final maps = await db.query(
      'question_table',
      where: 'topic = ?',
      whereArgs: [topic],
    );
    return maps.map((e) => QuestionsModel.fromMap(e)).toList();
  }
}
