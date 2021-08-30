import 'package:flutter/material.dart';

import '../../../_API.dart';

class JoinWidget extends StatefulWidget{
  @override
  _JoinState createState() => _JoinState();
}

class _JoinState extends State<JoinWidget> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var recheckPwController = TextEditingController();
  var nameController = TextEditingController();
  var mobileController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:  SingleChildScrollView(
        child: Container(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(20.0,25.0, 20.0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('이메일 입력'),
                      SizedBox(height: 10.0,),
                      TextFormField(
                        autofocus: true,
                        controller: emailController,
                        keyboardType: TextInputType.text,
                      ),
                      SizedBox(height: 10.0,),
                      Text('이름 입력'),
                      SizedBox(height: 10.0,),
                      TextFormField(
                        controller: nameController,
                        keyboardType: TextInputType.text,
                      ),
                      SizedBox(height: 10.0,),
                      Text('연락처 입력'),
                      SizedBox(height: 10.0,),
                      TextFormField(
                        controller: mobileController,
                        keyboardType: TextInputType.text,
                      ),
                      SizedBox(height: 10.0,),
                      Text('비밀번호 입력'),
                      SizedBox(height: 10.0,),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        keyboardType: TextInputType.text,
                      ),
                      SizedBox(height: 10.0,),
                      Text('비밀번호 확인 입력'),
                      SizedBox(height: 10.0,),
                      TextFormField(
                        controller: recheckPwController,
                        obscureText: true,
                        keyboardType: TextInputType.text,
                      ),
                      SizedBox(height: 20.0,),
                      ElevatedButton(
                        child: Text('회원가입 완료'),
                        onPressed: () {
                          join(emailController, nameController, mobileController, passwordController, recheckPwController, context);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ),
    );
  }
}

// 회원가입
Future<void> join(emailController, nameController, mobileController, passwordController, recheckPwController, BuildContext context) async {
  if (emailController.text.isNotEmpty && nameController.text.isNotEmpty && mobileController.text.isNotEmpty && passwordController.text.isNotEmpty) {

    // 비밀번호 입력란, 확인란 일치하는지 체크
    bool checkPw = ((passwordController.text.toString()) == (recheckPwController.text.toString()));
    if (checkPw == false) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('비밀번호를 다시 확인해주세요.'))
      );
      passwordController.clear();
      recheckPwController.clear();
      return;
    }

    var loginId = (emailController.text.toString()).replaceAll('@', '');
    var login_id = loginId.replaceAll('.', '');

    var params = ({
      'email': emailController.text.toString(),
      'login_id': login_id,
      'display_name': nameController.text.toString(),
      'mobile_text': mobileController.text.toString(),
      'password': passwordController.text.toString()
    });

    var data = await doApiPOST(BaseApi().join, params: params);

    // Todo :: isset(errors)

    if (data['message'] != 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['errors'].toString()))
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'].toString()))
      );
    }

  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("정보를 모두 입력해주세요."))
    );
  }
}




