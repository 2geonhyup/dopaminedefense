import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../models/custom_error.dart';

void errorDialog(BuildContext context, CustomError e) {
  if (Platform.isIOS) {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(e.code),
            content: Text(e.message),
            actions: [
              CupertinoDialogAction(
                child: Text('확인'),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        });
  } else {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(e.code),
            content: Text(e.message),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context), child: Text('확인'))
            ],
          );
        });
  }
}
