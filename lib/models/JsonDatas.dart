import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:amuzcore/_DB.dart' as abstractDatabase;

class JsonDatasDB {

  // 데이터 저장
  Future<void> insertJson(JsonData jsonData) async {
    final db = await abstractDatabase.DB.connectDB();
    await db.insert(
      abstractDatabase.DB.jsonDatas,
      jsonData.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // 데이터 확인
  Future<List<JsonData>> JsonDataList(String key) async {
    final db = await abstractDatabase.DB.connectDB();
   // print(db);
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT * FROM ${abstractDatabase.DB.jsonDatas} '
            'WHERE key = ?', [key]
    );
    return List.generate(maps.length, (i) {
      return JsonData(
          savedKey: maps[i]['key'],
          savedVal: maps[i]['val'],
          savedDate: maps[i]['date'],
      );
    });
  }

  // 데이터 삭제
  Future<void> deleteJson(String key) async {
    final db = await abstractDatabase.DB.connectDB();
    await db.delete(
        abstractDatabase.DB.jsonDatas,
        where: "key = ?",
        whereArgs: [key]
    );
  }
}

// boardList 모델
class JsonData {
  final String savedKey;
  final String savedVal;
  final String savedDate;

  JsonData({
    required this.savedKey,
    required this.savedVal,
    required this.savedDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'key': savedKey,
      'val' : savedVal,
      'date' : savedDate,
    };
  }

}


