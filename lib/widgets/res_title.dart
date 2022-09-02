import 'package:flutter/material.dart';

import '../constants.dart';
import '../restaurants.dart';

class ResTitle extends StatelessWidget {
  ResTitle(
      {Key? key,
      required this.category,
      required this.icon,
      required this.name,
      this.detail})
      : super(key: key);
  int category;
  int icon;
  String name;
  String? detail;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 19,
        ),
        Text(
          resFilterIcons[category][icon],
          style: TextStyle(fontSize: 35, fontFamily: 'Suit'),
        ),
        SizedBox(
          height: 7,
        ),
        Text(
          name,
          style: TextStyle(
              fontFamily: 'Cafe24',
              fontWeight: FontWeight.bold,
              color: kSecondaryTextColor,
              fontSize: 25),
        ),
        SizedBox(
          height: 6,
        ),
        Text(
          detail ?? "",
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              fontFamily: 'Suit',
              color: kSecondaryTextColor),
        )
      ],
    );
  }
}
