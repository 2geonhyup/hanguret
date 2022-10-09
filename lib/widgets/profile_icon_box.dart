import 'package:flutter/material.dart';

class ProfileIconBox extends StatelessWidget {
  ProfileIconBox({Key? key, required this.content}) : super(key: key);
  String content;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: Text(
        content,
        style: TextStyle(fontSize: 27),
      )),
      width: 55,
      height: 53,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(55),
          boxShadow: [
            BoxShadow(
                blurStyle: BlurStyle.outer,
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 0,
                offset: Offset(
                  0,
                  4,
                )),
          ]),
    );
  }
}
