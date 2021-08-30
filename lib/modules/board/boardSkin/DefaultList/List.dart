import 'package:flutter/material.dart';

ListView ListWidget(BuildContext context, List<dynamic> list, dynamic targetState) {
  return ListView.builder(
    scrollDirection: Axis.vertical,
    shrinkWrap: true,
    padding: EdgeInsets.all(10),
    itemCount: list.length,
    itemBuilder: (context, index) {
      final document = list[index];
      return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => targetState(list[index]),
              )
          );
        },
        // child: getListTile(document['title'], context),
      );
    },
  );
}



