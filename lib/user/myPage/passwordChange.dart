import 'package:amuzcore/user/myPage/myPage.dart';
import 'package:flutter/material.dart';

import '../../_API.dart';

class PasswordChange extends StatefulWidget {
  @override
  _PasswordChangeState createState() => _PasswordChangeState();
}

class _PasswordChangeState extends State<PasswordChange> {
  var currentPasswordController = TextEditingController();
  var newPasswordController = TextEditingController();
  var confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 50.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('현재 비밀번호'),
                    SizedBox(height: 5.0,),
                    TextFormField(
                      controller: currentPasswordController,
                      keyboardType: TextInputType.text,
                      obscureText: true,
                    ),
                    SizedBox(height: 20.0,),
                    Text('비밀번호는 [최소 6자, 숫자, 영문자, 특수문자]를 포함해야 합니다.'),
                    SizedBox(height: 5.0,),
                    TextFormField(
                      controller: newPasswordController,
                      keyboardType: TextInputType.text,
                      obscureText: true,
                    ),
                    SizedBox(height: 20.0,),
                    Text('비밀번호 확인'),
                    SizedBox(height: 5.0,),
                    TextFormField(
                      controller: confirmPasswordController,
                      keyboardType: TextInputType.text,
                      obscureText: true,
                    ),
                    SizedBox(height: 30.0,),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('취소',style: TextStyle(color: Colors.black54),),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              passwordChange(currentPasswordController, newPasswordController, confirmPasswordController,  context);
                            },
                            child: Text('저장'),
                          ),
                        ])
                  ],
                ),
            ),
          ],
        ),
      ),
    );
  }
}

// 비밀번호 변경하기
Future<void> passwordChange(currentPasswordController, newPasswordController, confirmPasswordController, BuildContext context) async{
    if(currentPasswordController.text.isNotEmpty && newPasswordController.text.isNotEmpty && confirmPasswordController.text.isNotEmpty) {

      // 비밀번호 변경  API Post
      var params = ({
        'current_password' : currentPasswordController.text.toString(),
        'password' : newPasswordController.text.toString(),
        'password_confirmation' : confirmPasswordController.text.toString(),
      });

      var data = await doApiPOST(BaseApi().passwordChange, params: params);
      bool result = data['result'];

      if(data['message'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("변경 사항이 저장되었습니다.")));
        // 마이페이지로 이동
        Navigator.push(context, MaterialPageRoute(builder: (context) => MyPage()));
      }else{
        if (result == false) {   // 비밀번호 변경 실패
          var errorsMessage = data['message'].toString();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorsMessage)));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data['errors']['password'].toString())));
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("정보를 모두 입력해주세요.")));
  }
}

