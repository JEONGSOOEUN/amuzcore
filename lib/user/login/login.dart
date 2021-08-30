import 'dart:convert';
import 'package:amuzcore/method.dart';
import 'package:amuzcore/models/JsonDatas.dart';
import 'package:flutter/material.dart';
import '../../../_API.dart';
import 'findId.dart';
import 'findPw.dart';
import 'join.dart';

class LoginWidget extends StatefulWidget{
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginWidget> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Column(
        children: <Widget>[
          Container(
              child: Column(
                children: [
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 15),
                      hintText: '아이디',
                    ),
                  ),
                  SizedBox(height: 10.0,),
                  TextFormField(
                    controller: passwordController,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 15),
                      hintText: '비밀번호',
                    ),
                  ),
                  SizedBox(height: 15.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                      // 아이디 찾기
                      GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => FindId(),
                              ),
                            );
                          },
                        child: Text('아이디', style: TextStyle(fontWeight: FontWeight.w200))
                      ),
                      Text(' | ', style: TextStyle(fontWeight: FontWeight.w200)),
                      // 비밀번호 찾기
                      GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => FindPw(),
                              ),
                            );
                          },
                        child: Text('비밀번호 찾기', style: TextStyle(fontWeight: FontWeight.w200))
                      ),
                    ]),
                ],
              ),
            ),
          SizedBox(height: 10.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
              onPressed: () {
                login(emailController, passwordController, context);
              },
              child: Text('로그인'),
            ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => JoinWidget(),
                    ),
                  );
                },
                child: Text('회원가입'),
              ),
          ]),
          SizedBox(height: 100.0,),
        ]
    );
  }
}

// 로그인
Future<void> login(emailController, passwordController, BuildContext context, [dynamic targetState]) async{
  if(emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {   // 입력값이 모두 있으면
    //일단 로그아웃을 시킨다.
    await doApiGET(BaseApi().logout);
    // 로컬스토리지에서 삭제
    var DB = JsonDatasDB();
    DB.deleteJson("remember_token");
    DB.deleteJson("user");

    // 로그인 API Post
    var params = ({
      'email' : emailController.text.toString(),
      'password' : passwordController.text.toString()
    });

    var data = await doApiPOST(BaseApi().login, params: params);

    if(data['message'] == '로그인에 성공하였습니다.') {
      // 로컬스토리지에 저장
      String date = getToday();
      String token = data['variables']['remember_token'].toString();
      JsonData jsonDataToken = new JsonData(
        savedKey: 'remember_token',
        savedVal: token,
        savedDate: date,
      );

      String user = jsonEncode(data['variables']['user']);
      JsonData jsonDataUser = new JsonData(
        savedKey: 'user',
        savedVal: user,
        savedDate: date,
      );

      DB.insertJson(jsonDataToken);
      DB.insertJson(jsonDataUser);

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'].toString())));

      // 전달된 Widget으로 보내줌
      Navigator.push(context, MaterialPageRoute(builder: (context) => targetState));

    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'].toString())));
        passwordController.clear();
        return;
    }

  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("정보를 모두 입력해주세요.")));
  }
}