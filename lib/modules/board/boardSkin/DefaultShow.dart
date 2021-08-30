import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class DetailPage extends StatelessWidget {
  final dynamic board;
  DetailPage(this.board);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(   // widget의 body 부분
        child: Html(
          data: board['content'],
        ),
    );
  }
}