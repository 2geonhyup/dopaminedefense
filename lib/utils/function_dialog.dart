import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void functionDialog(
    BuildContext context, String title, String content, Function() onTap) {
  if (Platform.isIOS) {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              CupertinoDialogAction(
                onPressed: onTap,
                child: const Text('확인'),
              ),
              CupertinoDialogAction(
                child: const Text('취소'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  } else {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(child: const Text('확인'), onPressed: () => onTap),
              TextButton(
                child: const Text('취소'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }
}
