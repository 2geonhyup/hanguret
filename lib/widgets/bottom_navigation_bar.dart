import 'package:flutter/material.dart';
import 'package:hangeureut/constants.dart';

class BasicBottomNavigationBar extends StatelessWidget {
  BasicBottomNavigationBar({
    required this.option1,
    required this.option2,
    required this.nav1,
    required this.nav2,
    this.withNav1,
    this.withNav2,
    this.noBack = false,
  });

  String option1;
  String option2;
  String nav1;
  String nav2;
  Function? withNav1;
  Function? withNav2;
  bool noBack;

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
              optionColor: kThirdColor,
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () async {
              if (withNav2 != null) {
                bool navigate = await withNav2!();
                if (navigate == false) return;
              }
              if (noBack) {
                Navigator.pushNamedAndRemoveUntil(
                    context, nav2, (Route<dynamic> route) => false);
              } else {
                if (nav2 == "") return;
                Navigator.pushNamed(context, nav2);
              }
            },
            child: OptionCard(
              optionText: option2,
              optionColor: Color(0xffc7c7c0),
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
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontFamily: 'Suit',
              fontSize: 18,
              color: Colors.black,
            ),
          ),
        ],
      ),
      color: optionColor,
      height: 83,
    );
  }
}

class BasicBottomPopBar extends StatelessWidget {
  BasicBottomPopBar({
    required this.option1,
    required this.option2,
    this.withNav1,
    required this.withNav2,
  });

  String option1;
  String option2;
  Function? withNav1;
  Function withNav2;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              if (withNav1 != null) {
                withNav1!();
              }
              Navigator.pop(context);
            },
            child: OptionCard(
              optionText: option1,
              optionColor: kThirdColor,
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () async {
              bool navigate = await withNav2();
              if (navigate == false) return;
              Navigator.pop(context);
            },
            child: OptionCard(
              optionText: option2,
              optionColor: Color(0xffc7c7c0),
            ),
          ),
        ),
      ],
    );
  }
}
