import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB{
  static String DB_FILE = 'amuz_core.db';

  static String boardTableId = "board_table";
  static String jsonDatas = "JsonDatas";
  static String lang = "lang";
  static String config = "config";

  // 테이블 생성
  static Future<Database> connectDB() async {
    final dbPath = await getDatabasesPath(); // getDatabasesPath()는 경로값을 리턴합니다
    return openDatabase(join(dbPath, DB_FILE),
        version: 1,
        // join() 메서드는 경로와 생성할 DB 파일의 이름을 매개변수로 받아 데이터베이스를 생성합니다
        onCreate: (db, version) async {
          await db.execute(''' CREATE TABLE $boardTableId ( slug TEXT, board TEXT, date TEXT, page INTEGER ) ''');
          await db.execute(''' CREATE TABLE $jsonDatas ( key TEXT, val TEXT, date TEXT ) ''');
          await db.execute(''' CREATE TABLE $lang ( namespace TEXT, item TEXT, locale TEXT, value TEXT) ''');
          await db.execute(''' CREATE TABLE $config ( name TEXT, vars TEXT) ''');
        },
        onUpgrade: (db, int oldVersion, int newVersion) async {
          if(oldVersion == 2){
          }
        }
      );
  }
}
