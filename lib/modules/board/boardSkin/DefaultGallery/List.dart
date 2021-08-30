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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image.network('${document}',
            //   height: 200,),
            SizedBox(
              height: 10.0,
            ),
              Image.network(imageUrl,
                height: 200,),
            Text(document['title'],
              style: TextStyle(fontSize: 15.0),),
          ],
        )
      );
    },
  );
}



