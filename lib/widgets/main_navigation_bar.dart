import 'package:flutter/material.dart';
import 'package:hangeureut/constants.dart';

class MainNavigationBar extends StatelessWidget {
  MainNavigationBar(
      {required this.option1,
      required this.option2,
      required this.nav1,
      required this.nav2});

  String option1;
  String option2;
  String nav1;
  String nav2;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, nav1);
            },
            child: OptionCard(
              optionText: option1,
              optionColor: kThirdColor.withOpacity(0.5),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, nav2);
            },
            child: OptionCard(
              optionText: option2,
              optionColor: kThirdColor,
            ),
          ),
        ),
      ],
    );
  }
}

class OptionCard extends StatelessWidget {
  OptionCard({required this.optionText, required this.optionColor});

  String optionText;
  Color optionColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 20.0),
          Text(
            optionText,
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ],
      ),
      color: optionColor,
      height: 83,
    );
  }
}
