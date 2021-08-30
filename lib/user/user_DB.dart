import 'dart:convert';
import 'package:amuzcore/models/JsonDatas.dart';

Future<dynamic> getJson(String key) async {
  var DB = JsonDatasDB();

  // 로컬스토리지 먼저 확인
  var data = await DB.JsonDataList(key);

  // 로컬스토리지에 boardList가 있으면 바로 넘겨준다.
  if (data.isNotEmpty) {
    Map<String, dynamic> map = jsonDecode(data[0].savedVal);
    return map;
  } else {
    print("로컬스토리지에 데이터가 없습니다.");
  }
}

