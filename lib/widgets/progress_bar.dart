import 'package:flutter/material.dart';
import 'package:hangeureut/constants.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar({Key? key, required this.level}) : super(key: key);

  final level;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          children: [
            ProgressBox(level: 1, curLevel: level),
            ProgressBox(level: 2, curLevel: level),
            ProgressBox(level: 3, curLevel: level),
          ],
        ),
      ),
    );
  }
}

class ProgressBox extends StatelessWidget {
  const ProgressBox({Key? key, required this.level, required this.curLevel})
      : super(key: key);

  final level;
  final curLevel;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3.9),
      child: Container(
        height: 10,
        decoration: BoxDecoration(
            color:
                level == curLevel ? kBasicColor : kBasicColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(45)),
      ),
    ));
  }
}
