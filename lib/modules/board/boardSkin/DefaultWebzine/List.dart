import 'package:flutter/material.dart';

ListView ListWidget(BuildContext context, List<dynamic> list, dynamic targetState) {
  return ListView.builder(
    scrollDirection: Axis.vertical,
    shrinkWrap: true,
    padding: EdgeInsets.all(10),
    itemCount: list.length,
    itemBuilder: (context, index) {
      final document = list[index];
      String imageUrl = '';
      if(document['thumb'] != null) {
        imageUrl = document['thumb']['board_thumbnail_path'];
      } else {
        imageUrl = 'https://dummy.amuz.co.kr/thumbnails/2.jpg';
      }
      return GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => targetState(list[index]),
                )
            );
          },
          child: Container(
            decoration: BoxDecoration (
              border: Border(
                bottom: BorderSide(
                  color: Colors.black12, width: 1.0,
                )
              )
            ),
            child: Column(
              children: [
                SizedBox(height: 10.0,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Image.network(imageUrl,
                    width: 150,),
                  SizedBox(width: 10.0,),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(document['title'],
                        style: TextStyle(fontSize: 15.0),
                      ),
                      Text('작성자 : '+document['writer'],
                        style: TextStyle(fontSize: 12.0),
                      ),
                    ]
                  ),
                ],
              ),
                SizedBox(height: 10.0,)
            ]
        ),
          )
      );
    },
  );
}



