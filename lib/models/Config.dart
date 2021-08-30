import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:amuzcore/_DB.dart' as abstractDatabase;

import '../_API.dart';

class ConfigDB {

  // syncConfig
  Future<void> syncConfig(Config config) async {
    // db에서 기존 데이터 삭제
    await truncateConfig();

    // 서버에서 데이터 불러오기
    var configs = await doApiGET(BaseApi().config);
    List<Config> configList = List.generate(configs.length, (i) {
      return Config(
          savedName: configs[i]['config_list']['name'],
          savedVars:  configs[i]['config_list']['vars']
      );
    });

    // db에 저장
    final db = await abstractDatabase.DB.connectDB();
    for(int i = 0; i < configList.length; i++) {
      await db.insert(
        abstractDatabase.DB.config,
        configList[i].toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  // getConfig
  Future<List<Config>> getConfig(String name) async {
    final db = await abstractDatabase.DB.connectDB();
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT * FROM ${abstractDatabase.DB.config} '
            'WHERE name = ?', [name]
    );
    return List.generate(maps.length, (i) {
      return Config(
        savedName: maps[i]['name'],
        savedVars: maps[i]['vars']
      );
    });
  }

  // truncateConfig
  Future<void> truncateConfig() async {
    final db = await abstractDatabase.DB.connectDB();
    await db.delete(
        abstractDatabase.DB.config
    );
  }
}

// Config 모델
class Config {
  final String savedName;
  final String savedVars;

  Config({
    required this.savedName,
    required this.savedVars,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': savedName,
      'vars' : savedVars,
    };
  }
}


