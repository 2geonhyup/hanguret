import 'package:flutter/material.dart';

import '../constants.dart';
import '../restaurants.dart';

class ResTitle extends StatelessWidget {
  ResTitle(
      {Key? key,
      required this.category,
      required this.icon,
      required this.name,
      this.score,
      this.detail})
      : super(key: key);
  int category;
  int icon;
  String name;
  String? score;
  String? detail;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          resFilterIcons[category][icon],
          style: TextStyle(fontSize: 35, fontFamily: 'Suit', height: 1),
        ),
        SizedBox(
          height: 15,
        ),
        Text(
          name,
          style: TextStyle(
              height: 1,
              fontFamily: 'Cafe24',
              fontWeight: FontWeight.bold,
              color: kSecondaryTextColor,
              fontSize: 25),
        ),
        SizedBox(
          height: 14,
        ),
        detail == null
            ? SizedBox.shrink()
            : Text(
                detail ?? "",
                style: TextStyle(
                    fontSize: 12,
                    height: 1,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Suit',
                    color: kSecondaryTextColor),
              ),
        SizedBox(
          height: score != null ? 13 : 0,
        ),
        score != null
            ? Container(
                width: 70,
                height: 29,
                decoration: BoxDecoration(
                    color: Color(0xfff3f3f2),
                    borderRadius: BorderRadius.circular(11)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "평점 ",
                      style: TextStyle(
                          fontFamily: 'Suit',
                          fontWeight: FontWeight.w500,
                          color: kSecondaryTextColor,
                          fontSize: 12),
                    ),
                    Text(
                      score!,
                      style: TextStyle(
                          fontFamily: 'Suit',
                          fontWeight: FontWeight.w900,
                          color: kBasicColor,
                          fontSize: 12),
                    )
                  ],
                ),
              )
            : SizedBox.shrink(),
      ],
    );
  }
}
