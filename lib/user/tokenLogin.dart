import 'dart:convert';
import 'package:amuzcore/models/JsonDatas.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../_API.dart';
import '../method.dart';

Future<void> tokenLogin(BuildContext context, [dynamic targetState]) async{

  //일단 로그아웃을 시킨다.
  await doApiGET(BaseApi().logout);

  // 로컬스토리지에서 삭제
  var DB = JsonDatasDB();
  DB.deleteJson("remember_token");
  DB.deleteJson("user");

  // 토큰 로그인 post
  var data = await doApiPOST(BaseApi().tokenLogin);

  // 로컬스토리지에 다시 저장
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

  DB.insertJson(jsonDataToken); // token
  DB.insertJson(jsonDataUser);  // user

  // targetState : tokenLogin 이후 갈 페이지 지정
  Navigator.push(context, MaterialPageRoute(builder: (context) => targetState));
}