import 'package:flutter/material.dart';
import 'findId.dart';

class FindPw extends StatefulWidget {
  @override
  FindPwState createState() => FindPwState();
}

class FindPwState extends State<FindPw> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          margin: EdgeInsets.fromLTRB(0,0, 0, 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(20.0,150, 20.0, 0),
                child: Column(
                  children: [
                    Text('가입한 이름과 전화번호를 입력해주세요.'),
                    SizedBox(height: 20.0,),
                    Text('이름'),
                    SizedBox(height: 10.0,),
                    TextField(
                      keyboardType: TextInputType.text,
                    ),
                    SizedBox(height: 10.0,),
                    Text('연락처'),
                    SizedBox(height: 10.0,),
                    TextField(
                      keyboardType: TextInputType.text,
                      obscureText: true,
                    ),
                    SizedBox(height: 10.0,),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text('비밀번호 찾기'),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => FindId(),
                          ),
                        );
                      },
                      child: Text('아이디 찾기',
                          style: TextStyle(
                              fontWeight: FontWeight.w200,
                              decoration: TextDecoration.underline,)
                      )
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}