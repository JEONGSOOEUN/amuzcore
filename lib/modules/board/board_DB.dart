import 'package:amuzcore/modules/board/Board.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:amuzcore/_DB.dart' as abstractDatabase;

class BoardDB {

  // 게시글 저장
  Future<void> insertBoard(BoardList boardList) async {
    final db = await abstractDatabase.DB.connectDB();
    await db.insert(
      abstractDatabase.DB.boardTableId,
      boardList.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // boardList 확인(리스트)
  Future<List<BoardList>> checkBoard(String slug, int page) async {
    final db = await abstractDatabase.DB.connectDB();
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT * FROM ${abstractDatabase.DB.boardTableId} '
            'WHERE slug = ? and page = ?', [slug,page]
    );
    return List.generate(maps.length, (i) {
      return BoardList(
          savedSlug: maps[i]['slug'],
          savedBoard: maps[i]['board'],
          savedDate: maps[i]['date'],
          savedPage: maps[i]['page']
      );
    });
  }

  // boardList 삭제
  Future<void> deleteBoard(String slug) async {
    final db = await abstractDatabase.DB.connectDB();
    await db.delete(
        abstractDatabase.DB.boardTableId,
        where: "slug = ?",
        whereArgs: [slug]
    );
  }
}

