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
      width: 53,
      height: 53,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(53),
          boxShadow: [
            BoxShadow(
                color: Color(0xff000000).withOpacity(0.08),
                blurRadius: 6,
                spreadRadius: 0,
                offset: Offset(
                  0,
                  4,
                )),
          ]),
    );
  }
}
