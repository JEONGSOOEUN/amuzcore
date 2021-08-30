import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:device_info/device_info.dart';

import 'models/JsonDatas.dart';

class BaseApi{
  String scheme = 'http';
  String host = 'homestead.test';
  int port = 80;

  String defaultProfileImage = 'https://dummy.amuz.co.kr/thumbnails/2.jpg';

  String login = 'plugin/ApplicationHelper/auth/login';
  String tokenLogin = 'plugin/ApplicationHelper/auth/token';
  String logout = 'auth/logout';
  String join = 'auth/register';
  String passwordChange = 'user/settings/password';
  String mobileChange = 'user/settings/additions/mobile';

  String notice = 'notice';
  String getToken = 'plugin/ApplicationHelper/csrf/_token';
  String checkEmail = 'auth/register/check/email';

  String config = 'plugin/ApplicationHelper/config/list';
  String lang = 'plugin/ApplicationHelper/lang/';

}

Map<String, String> headers = {};
Map<String, String> cookies = {};

Future<dynamic> doApiGET(String slug, {dynamic params}) async{

  setHeaderInDeviceDetails();
  headers['Content-Type'] = 'application/json';
  headers['Accept'] = 'application/json';

  Uri getURL = new Uri(scheme: BaseApi().scheme,
      host: BaseApi().host,
      port: BaseApi().port,
      path: slug,
      queryParameters:params);

  print(getURL);

  var response = await http.get(getURL, headers: headers);
  var statusCode = response.statusCode;
  // TODO : 리턴 오브젝트 내의 에러와 메세지를 다시 검사해야함.
  if(statusCode == 200) {
    ApiHeaders()._updateCookie(response);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      print("api data : $data");
      return data;
    }
  }
}

Future<dynamic> multipartFormData(String action, dynamic params, File file) async {
  var token = await doApiGET(BaseApi().getToken);
  params['_token'] = token['_token'];

  setHeaderInDeviceDetails();
  
  headers['X-CSRF-TOKEN'] = token['_token'];
  headers['Accept'] = 'application/json,text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9';
  headers['Content-Type'] = 'multipart/form-data';

  Uri getURL = new Uri(scheme: BaseApi().scheme,
      host: BaseApi().host,
      port: BaseApi().port,
      path: action);

  var request = new http.MultipartRequest("POST", getURL);
  request.headers.addAll(headers);

  request.fields['_token'] = token['_token'];
  request.fields['display_name'] = params['display_name'];
  request.fields['introduction'] = params['introduction'];

  request.files.add(await http.MultipartFile.fromPath('profile_img_file', file.path));

  var response = await request.send();
  var statusCode = response.statusCode;

  if(statusCode == 302) {
    print("Post 성공 - 프로필 이미지 변경");
    var data = { "message": "success"};
    return data;
  }
  else {
    print('Post 실패 - 프로필 이미지 변경');
    var data = { "error": "fail"};
    return data;
  }
}


Future<dynamic> doApiPUT(String action, {dynamic params}) async{
  params = {'_method' : 'PUT'}..addAll(params);
  return doApiPOST(action, params: params);
}

Future<dynamic> doApiPOST(String action, {dynamic params}) async{
  setHeaderInDeviceDetails();
  var token = await doApiGET(BaseApi().getToken);
  if(params == null) {
    params =  {};
  }
  params['_token'] = token['_token'];

  headers['X-CSRF-TOKEN'] = token['_token'];
  headers['Accept'] = 'application/json,text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9';
  headers['Content-Type'] = 'application/x-www-form-urlencoded';
  // headers['X-XE-Async-Expose'] = "false";

  Uri getURL = new Uri(scheme: BaseApi().scheme,
      host: BaseApi().host,
      port: BaseApi().port,
      path: action);

  print("post url : $getURL");
  print("params : $params");

  var response = await http.post(getURL, body: params, headers: headers);
  var statusCode = response.statusCode;
  late var data;
  if(statusCode == 200) {
    ApiHeaders()._updateCookie(response);
    data = json.decode(response.body);
    print("Post 성공 - return Object");
    return data;
  } else if (statusCode == 302) { //redirect 코드
      ApiHeaders()._updateCookie(response);
      print("Post 성공 - return redirect");
      data = { "message": "success"};
      return data;
    }
  else {
      print('Post 실패');
      print(statusCode);
      data = json.decode(response.body);
      print(data);
      return data;
   }
}

class ApiHeaders {

  void _updateCookie(http.Response response) {
    String? allSetCookie = response.headers['set-cookie'];

    if (allSetCookie != null) {
      var setCookies = allSetCookie.split(',');

      for (var setCookie in setCookies) {
        var cookies = setCookie.split(';');

        for (var cookie in cookies) {
          _setCookie(cookie);
        }
      }

      headers['cookie'] = _generateCookieHeader();
    }
  }

  void _setCookie(String rawCookie) {
    if (rawCookie.length > 0) {
      var keyValue = rawCookie.split('=');
      if (keyValue.length == 2) {
        var key = keyValue[0].trim();
        var value = keyValue[1];

        // ignore keys that aren't cookies
        if (key == 'path' || key == 'expires')
          return;

        cookies[key] = value;
      }
    }
  }

  String _generateCookieHeader() {
    String cookie = "";

    for (var key in cookies.keys) {
      if (cookie.length > 0)
        cookie += ";";
        if(cookies[key] != null){
          cookie += key;
          cookie += "=" + cookies[key]!;
        }
    }
    return cookie;
  }
}

Future<void> setHeaderInDeviceDetails() async {
  String deviceName ='';
  String deviceVersion ='';
  String identifier= '';

  final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
  try {
    if (Platform.isAndroid) {
      var build = await deviceInfoPlugin.androidInfo;
      deviceName = build.model;
      deviceVersion = build.version.toString();
      identifier = build.androidId;  //UUID for Android
    } else if (Platform.isIOS) {
      var data = await deviceInfoPlugin.iosInfo;
      deviceName = data.name;
      deviceVersion = data.systemVersion;
      identifier = data.identifierForVendor;  //UUID for iOS
    }
  } on PlatformException {
    print('Failed to get platform version');
  }

  headers['X-AMUZ-DEVICE-NAME'] = deviceName;
  headers['X-AMUZ-DEVICE-VERSION'] = deviceVersion;
  headers['X-AMUZ-DEVICE-UUID'] = identifier;

  //DB에서 remember_token이 있는 경우, 가져와서 같이 보냄.
  var DB = JsonDatasDB();
  var rememberToken =  await DB.JsonDataList("remember_token");

  if(rememberToken.isNotEmpty) {
    headers['X-AMUZ-REMEMBER-TOKEN'] = rememberToken[0].savedVal;
  }

}