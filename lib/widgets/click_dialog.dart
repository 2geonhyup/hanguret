import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screens/on_boarding_screen/on_boarding2_page.dart';

void clickDialog(
    {required BuildContext context,
    required String title,
    required String content,
    required Function clicked}) {
  if (Platform.isIOS) {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: title == "" ? null : Text(title),
            content: Text(content),
            actions: [
              CupertinoDialogAction(
                child: Text('확인'),
                onPressed: () async {
                  await clicked();
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
            title: title == "" ? null : Text(title),
            content: Text(content),
            actions: [
              TextButton(
                  onPressed: () async {
                    await clicked();
                    Navigator.pop(context);
                  },
                  child: Text('확인'))
            ],
          );
        });
  }
}

void clickCancelDialog(
    {required BuildContext context,
    required String title,
    required String content,
    required Function clicked}) {
  if (Platform.isIOS) {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: title == "" ? null : Text(title),
            content: Text(content),
            actions: [
              CupertinoDialogAction(
                child: Text('취소'),
                onPressed: () async {
                  Navigator.pop(context);
                },
              ),
              CupertinoDialogAction(
                child: Text('확인'),
                onPressed: () async {
                  bool success = await clicked();
                  Navigator.pop(context);
                  if (success)
                    Navigator.pushNamed(context, OnBoarding2Page.routeName);
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
            title: title == "" ? null : Text(title),
            content: Text(content),
            actions: [
              TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  child: Text('취소')),
              TextButton(
                  onPressed: () async {
                    bool success = await clicked();
                    Navigator.pop(context);
                    if (success)
                      Navigator.pushNamed(context, OnBoarding2Page.routeName);
                  },
                  child: Text('확인'))
            ],
          );
        });
  }
}
