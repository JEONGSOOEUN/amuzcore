import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:amuzcore/_DB.dart' as abstractDatabase;

class LangDB {

  // syncConfig
  Future<void> syncLang(Lang lang) async {
    final db = await abstractDatabase.DB.connectDB();
    await db.insert(
      abstractDatabase.DB.lang,
      lang.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // getLang
  Future<List<Lang>> getLang(String item) async {
    final db = await abstractDatabase.DB.connectDB();
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT * FROM ${abstractDatabase.DB.lang} '
            'WHERE item = ?', [item]
    );
    return List.generate(maps.length, (i) {
      return Lang(
        savedNamespace: maps[i]['namespace'],
        savedItem: maps[i]['item'],
        savedLocale: maps[i]['locale'],
        savedValue: maps[i]['value ']
      );
    });
  }
}

// Lang 모델
class Lang {
  final String savedNamespace;
  final String savedItem;
  final String savedLocale;
  final String savedValue;

  Lang ({
    required this.savedNamespace,
    required this.savedItem,
    required this.savedLocale,
    required this.savedValue, 
  });

  Map<String, dynamic> toMap() {
    return {
      'namespace': savedNamespace,
      'item': savedItem,
      'locale': savedLocale,
      'value': savedValue
    };
  }

}


