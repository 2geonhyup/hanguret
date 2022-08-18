import 'package:flutter/material.dart';

import '../../constants.dart';

Widget subTitleRow(iconPath, text, subText) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          Image.asset(
            iconPath,
            height: 22,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            text,
            style: TextStyle(
                fontFamily: 'Suit', fontWeight: FontWeight.w400, fontSize: 14),
          ),
        ],
      ),
      Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: Text(
          subText,
          style: TextStyle(
              fontFamily: 'Suit',
              fontWeight: FontWeight.w400,
              fontSize: 8.5,
              color: kSecondaryTextColor),
        ),
      ),
    ],
  );
}

class RoundedButton extends StatelessWidget {
  const RoundedButton(
      {Key? key,
      required this.iconPath,
      required this.text,
      required this.onTap,
      required this.selected,
      required double this.height})
      : super(key: key);
  final iconPath;
  final text;
  final onTap;
  final selected;
  final height;
  int _flexWidth(num) {
    if (num <= 3) {
      return 94;
    } else if (4 <= num && num <= 5) {
      return 104;
    } else {
      return 122;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: _flexWidth(text.length),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            height: height,
            decoration: BoxDecoration(
              color: selected ? kBasicColor : Colors.white,
              boxShadow: [
                BoxShadow(
                    color: kBasicColor.withOpacity(0.3),
                    blurRadius: 3,
                    spreadRadius: 0,
                    offset: Offset(
                      0,
                      1,
                    )),
              ],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    iconPath,
                    height: 18,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    text,
                    style: TextStyle(
                        fontFamily: 'Suit',
                        fontWeight:
                            selected ? FontWeight.w500 : FontWeight.w300,
                        fontSize: 13,
                        color: selected ? Colors.white : Colors.black),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RoundedAlcoholButton extends StatelessWidget {
  const RoundedAlcoholButton(
      {Key? key,
      required this.iconPath,
      required this.text,
      required this.onTap,
      required this.selected,
      required double this.height})
      : super(key: key);
  final iconPath;
  final text;
  final onTap;
  final selected;
  final height;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 5),
          child: Container(
            height: height,
            decoration: BoxDecoration(
              color: selected ? kBasicColor : Colors.white,
              boxShadow: [
                BoxShadow(
                    color: kBasicColor.withOpacity(0.3),
                    blurRadius: 3,
                    spreadRadius: 0,
                    offset: Offset(
                      0,
                      1,
                    )),
              ],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    iconPath,
                    height: 15,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    text,
                    style: TextStyle(
                        fontFamily: 'Suit',
                        fontWeight:
                            selected ? FontWeight.w500 : FontWeight.w300,
                        fontSize: 13,
                        color: selected ? Colors.white : Colors.black),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
