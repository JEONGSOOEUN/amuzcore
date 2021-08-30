import 'package:amuzcore/models/JsonDatas.dart';
import 'package:amuzcore/user/myPage/userInfoModify.dart';
import 'package:flutter/material.dart';

import '../../_API.dart';
import '../user_DB.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {

  late var _user = {};

  void _onFirst() async {
    var data = await getJson("user");
    setState(() {
      _user = data;
    });
  }

  @override
  void initState() {
    super.initState();
    _onFirst();
  }

  @override
  Widget build(BuildContext context) {

    // 프로필 이미지 널체크
    String imageUrl = '';
    if(_user['profileImage'] != null) {
      imageUrl = _user['profileImage'];
    } else {
      imageUrl = 'https://dummy.amuz.co.kr/thumbnails/2.jpg';
    }

    // 자기소개 널체크
    String introduction = '';
    if(_user['introduction'] != null) {
      introduction = _user['introduction'];
    } else {
      introduction = '자기소개를 입력해주세요.';
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          child: Stack(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 10.0),
              child: Column(
                children: [
                  GestureDetector(
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(imageUrl),
                          backgroundColor: Colors.transparent,
                        ),
                        SizedBox(width: 10,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_user['display_name'].toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
                            SizedBox(height: 5,),
                            Row(
                                children: [
                                  Text('"$introduction"',style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),),
                                  Icon(Icons.edit, size: 18, color: Color.fromRGBO(0, 0, 0, .2)),
                              ]
                            ),
                          ]
                        )
                      ],
                    ),
                    onTap: () {
                      Navigator.push(context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => UserInfoModify(),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 100.0,),
                  OutlinedButton.icon(
                      onPressed: (){
                        // 로그아웃 버튼 클릭
                        logout(context);
                      },
                      icon: Icon(Icons.exit_to_app, size: 30,),
                      label: Text("Logout")
                  ),
                  SizedBox(height: 5.0,),
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> logout(BuildContext context, [dynamic targetState]) async {
  // 로그아웃 post
  await doApiGET(BaseApi().logout);

  // 로컬스토리지에서 삭제
  var DB = JsonDatasDB();
  DB.deleteJson("remember_token");
  DB.deleteJson("user");

  // 로그인 페이지로 보내기
  Navigator.push(context, MaterialPageRoute(builder: (context) => targetState));
}
