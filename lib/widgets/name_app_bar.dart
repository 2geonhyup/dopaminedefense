import 'package:flutter/material.dart';

import '../constants.dart';

PreferredSizeWidget nameAppBar() {
  return AppBar(
    automaticallyImplyLeading: false,
    title: Align(
      alignment: Alignment.centerLeft,
      child: Text(
        'Dopamine Defense',
        style: TextStyle(
            color: orangePoint, fontWeight: FontWeight.w700, fontSize: 20),
      ),
    ),
    backgroundColor: Colors.transparent,
    elevation: 0,
    bottom: PreferredSize(
      preferredSize: Size.fromHeight(0), // 테두리의 높이 설정
      child: Container(
        color: Colors.black26, // 테두리의 색상
        height: 0.5, // 테두리의 두께
      ),
    ),
  );
}
