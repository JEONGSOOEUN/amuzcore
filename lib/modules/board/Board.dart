import 'dart:convert';
import 'package:amuzcore/method.dart';
import 'package:amuzcore/modules/board/board_DB.dart';
import '../../_API.dart';

class BoardList {
  final String savedSlug;
  final String savedBoard;
  final String savedDate;
  final int savedPage;

  BoardList({
    required this.savedSlug,
    required this.savedBoard,
    required this.savedDate,
    required this.savedPage
  });

  Map<String, dynamic> toMap() {
    return {
      'slug': savedSlug,
      'board' : savedBoard,
      'date' : savedDate,
      'page' : savedPage
    };
  }
}

Future<dynamic> getBoard(String slug, dynamic page, {bool refresh = false}) async {

  var DB = BoardDB();
  var data;

  // 새로고침하면 로컬스토리지 비우고 다시 서버에서 불러온다.
  if(refresh == true){
    DB.deleteBoard(slug);
  }
  // 로컬스토리지 먼저 확인
  var board = await DB.checkBoard(slug, page);

  // 로컬스토리지에 boardList가 있으면 바로 넘겨준다.
  if (board.isNotEmpty) {
    print("do Load from localDB");
    Map<String, dynamic> map = jsonDecode(board[0].savedBoard);
    data = map;

    // 로컬스토리지에 없으면 서버에서 가져오고, 로컬에 저장
  } else {
    print("do Load from Server");
    dynamic params = {
      'page' : page.toString()
    };
    data = await doApiGET(slug, params: params);
    if (data != null) {
      String board = jsonEncode(data);
      String date = getToday();
      int page = data['paginate']['current_page'];
      BoardList boardList = new BoardList(
          savedSlug: slug,
          savedBoard: board,
          savedDate: date,
          savedPage: page);

      // 로컬스토리지에 저장
      var DB = BoardDB();
      DB.insertBoard(boardList);
    }
  }
  return data;
}
