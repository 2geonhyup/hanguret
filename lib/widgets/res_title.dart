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
          icon == -1 ? "" : resFilterIcons[category][icon],
          style: const TextStyle(fontSize: 35, fontFamily: 'Suit', height: 1),
        ),
        const SizedBox(
          height: 15,
        ),
        Text(
          name,
          style: const TextStyle(
              height: 1,
              fontFamily: 'Cafe24',
              fontWeight: FontWeight.bold,
              color: kSecondaryTextColor,
              fontSize: 25),
        ),
        const SizedBox(
          height: 14,
        ),
        detail == null
            ? const SizedBox.shrink()
            : Text(
                detail ?? "",
                style: const TextStyle(
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
                    color: const Color(0xfff3f3f2),
                    borderRadius: BorderRadius.circular(11)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "평점 ",
                      style: TextStyle(
                          fontFamily: 'Suit',
                          fontWeight: FontWeight.w500,
                          color: kSecondaryTextColor,
                          fontSize: 12),
                    ),
                    Text(
                      score!,
                      style: const TextStyle(
                          fontFamily: 'Suit',
                          fontWeight: FontWeight.w900,
                          color: kBasicColor,
                          fontSize: 12),
                    )
                  ],
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
