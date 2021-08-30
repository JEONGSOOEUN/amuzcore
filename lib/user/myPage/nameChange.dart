import 'package:amuzcore/user/myPage/myPage.dart';
import 'package:flutter/material.dart';

import '../../_API.dart';
import '../tokenLogin.dart';
import '../user_DB.dart';

class NameChange extends StatefulWidget {
  @override
  _NameChangeState createState() => _NameChangeState();
}

class _NameChangeState extends State<NameChange> {
  late var _user = {};

  var nameController = TextEditingController();

  // 닉네임  변경하기
  Future<void> nameChange(nameController, BuildContext context) async{
    if(nameController.text.isNotEmpty) {

      // 닉네임 변경 API Post
      var params = ({
        'display_name' : nameController.text.toString(),
        'introduction' :  _user['introduction'].toString()
      });

      String action = "/@"+_user['id'];

      var data = await doApiPOST(action, params: params);

      if(data['message'] == 'success') {
        tokenLogin(context, MyPage());
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("변경 사항이 저장되었습니다.")));
      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data['message'].toString())));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('닉네임을 입력해주세요.')));
    }
  }

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
                  Text('새 닉네임'),
                  SizedBox(height: 5.0,),
                  TextFormField(
                    controller: nameController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 15),
                      hintText: _user['display_name']
                    ),
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
                            nameChange(nameController, context);
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

