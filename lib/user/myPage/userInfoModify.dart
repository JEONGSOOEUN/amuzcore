import 'dart:io';
import 'package:amuzcore/user/myPage/passwordChange.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../_API.dart';
import '../tokenLogin.dart';
import '../user_DB.dart';
import 'mobileChange.dart';
import 'nameChange.dart';

class UserInfoModify extends StatefulWidget {
  @override
  _UserInfoModifyState createState() => _UserInfoModifyState();
}

class _UserInfoModifyState extends State<UserInfoModify> {
  bool showNicknameText = true;
  bool showNicknameForm = false;

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

  PickedFile? _image;
  final picker = ImagePicker();

  // 프로필 이미지 변경
  Future<void> getImageFromGallery() async {
    var image = await picker.getImage(source: ImageSource.gallery,
      imageQuality: 100,
      maxWidth: 500,
    );
    setState(() {
      _image = image;
    });

    var file = File(image.path);

    String action = "/@"+_user['id'];

    var params = ({
      'display_name' : _user['display_name'].toString(),
      'introduction' : _user['introduction'].toString(),
    });

    var data = await multipartFormData(action, params, file);

    String message = data['message'].toString();

    if (message.isNotEmpty) {
      // 이미지 변경 성공 후 다시 로그인 시켜준다.
      tokenLogin(context, UserInfoModify());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("변경 사항이 저장되었습니다.")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['error'].toString())));
    }
  }

  // 자기소개 변경하기
  Future<void> introductionChange(introductionController, BuildContext context) async{
    if(introductionController.text.isNotEmpty) {

      // 자기소개 변경 API Post
      var params = ({
        'display_name' : _user['display_name'].toString(),
        'introduction' : introductionController.text.toString(),
      });

      String action = "/@"+_user['id'];

      var data = await doApiPOST(action, params: params);

      if(data['message'] == 'success') {
        tokenLogin(context, UserInfoModify());
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("변경 사항이 저장되었습니다.")));
      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data['message'].toString())));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("자기소개를 입력해주세요.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    // 프로필 이미지 널체크
    String imageUrl = BaseApi().defaultProfileImage;
    if(_user['profileImage'] != null) imageUrl = _user['profileImage'];

    // 자기소개 널체크
    String introduction = '자기소개를 입력해주세요.';
    var introductionController;
    if(_user['introduction'] != null) {
      introduction = _user['introduction'];
      introductionController = TextEditingController(text: introduction );
    } else {
      introductionController = TextEditingController(text: null);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
            margin: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 20.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            child: CircleAvatar(
                              radius: 70,
                              backgroundImage: NetworkImage(imageUrl),
                              backgroundColor: Colors.transparent,
                            ),
                            onTap: getImageFromGallery,
                          ),
                        ]
                      ),
                      SizedBox(height: 25.0,),
                        Visibility(
                          child: GestureDetector(
                            onTap: (){
                              setState((){
                                showNicknameText = !showNicknameText;
                                showNicknameForm = !showNicknameForm;
                              });
                            },
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(introduction,style:TextStyle(fontSize:25)),
                                  Icon(Icons.edit, size: 18, color: Color.fromRGBO(0, 0, 0, .2)),
                                ]
                            ),
                          ),
                          visible: showNicknameText
                        ),
                      Visibility(
                      child: Column(
                        children: [
                          TextFormField(
                          controller: introductionController,
                          keyboardType: TextInputType.text,
                        ),
                          SizedBox(height: 10.0,),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    // Navigator.pop(context);
                                    setState((){
                                      showNicknameText = !showNicknameText;
                                      showNicknameForm = !showNicknameForm;
                                    });
                                  },
                                  child: Text('취소',style: TextStyle(color: Colors.black54),),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    introductionChange(introductionController, context);
                                  },
                                  child: Text('저장'),
                                ),
                              ]
                          ),
                       ]
                      ),
                        visible: showNicknameForm
                      )
                    ],
                  ),
                ),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListView(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        children: [
                          getListTile('닉네임',context,NameChange(),trailText: _user['display_name'].toString()),
                          getListTile('연락처',context,MobileChange(),trailText: _user['mobile_text'].toString()),
                          getListTile('비밀번호',context,PasswordChange()),
                        ],
                      ),
                    ]
                  ),
                ],
              ),
            ),
          ]
        ),
      ),
    );
  }
}

ListTile getListTile(String title, BuildContext context, Widget widget, { String trailText = ""} ) {
  return ListTile(
    shape: Border(bottom: BorderSide(color: Colors.black12, width: 0.5)),
    contentPadding: EdgeInsets.only(left: 0.0, right: 0.0),
    title:  Text(title),
    trailing:  Wrap(
      spacing: 12, // space between two icons
      children: <Widget>[
        Text(trailText,style: TextStyle(fontSize: 12, color: Color.fromRGBO(0, 0, 0, .6))),
        Icon(Icons.arrow_forward_ios_rounded, size: 18,),
      ],
    ),
    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
    },
  );
}



