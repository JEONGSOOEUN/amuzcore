import 'package:amuzcore/user/myPage/myPage.dart';
import 'package:flutter/material.dart';
import '../../_API.dart';
import '../tokenLogin.dart';
import '../user_DB.dart';

class MobileChange extends StatefulWidget {
  @override
  _MobileChangeState createState() => _MobileChangeState();
}

class _MobileChangeState extends State<MobileChange> {
  late var _user = {};

  var mobileController = TextEditingController();

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
                  Text('새 연락처'),
                  SizedBox(height: 5.0,),
                  TextFormField(
                    controller: mobileController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 15),
                      hintText: _user['mobile_text']
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
                          child: Text('취소'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            mobileChange(mobileController, context);
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

//  연락처 변경하기
Future<void> mobileChange(mobileController, BuildContext context) async{
  if(mobileController.text.isNotEmpty) {

    // 연락처 변경 API Post
    var params = ({
      'mobile_text' : mobileController.text.toString(),
    });

    var data = await doApiPUT(BaseApi().mobileChange, params: params);

    print("data $data");

    if(data['message'] == 'success') {
      tokenLogin(context, MyPage());
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("변경 사항이 저장되었습니다.")));
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data['message'].toString())));
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('연락처를 입력해주세요.')));
  }
}

