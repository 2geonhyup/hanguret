import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hangeureut/constants.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ReviewFloatingButton extends StatelessWidget {
  ReviewFloatingButton({
    Key? key,
    required this.buttonColor,
    required this.onTap,
  }) : super(key: key);
  Color buttonColor;
  final onTap;

  @override
  Widget build(context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: Platform.isAndroid
          ? const EdgeInsets.only(bottom: 42.0, right: 5.0)  //일단은 갤럭시s20+에서는 맞춰놨는데 다른 폰들은 어떤지 모르겠음. floating버튼이라 폰마다 다를 가능성 있음.
          : const EdgeInsets.only(right: 8.0, bottom: 8.0),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(56),
              color: kSecondaryTextColor),
          child: Center(
            child: Icon(
              MdiIcons.pencilOutline,
              color: Colors.white,
              size: 30.0,
            ),
          ),
        ),
      ),
    );
  }
}

// showModalBottomSheet(
//     context: context,
//     useRootNavigator: true,
//     builder: (BuildContext context) {
//       return Container(
//         height: 100,
//       );
//     });

//   RawMaterialButton(
//   onPressed: () {
//
//   },
//   elevation: 2.0,
//   fillColor: buttonColor,
//   child: Icon(
//   MdiIcons.pencilOutline,
//   color: Colors.white,
//   size: 30.0,
//   ),
//   padding: EdgeInsets.all(12.0),
//   shape: CircleBorder(),
//   );
