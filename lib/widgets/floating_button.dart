import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../screens/review_screen/review_page.dart';

class ReviewFloatingButton extends StatelessWidget {
  ReviewFloatingButton({Key? key, required this.buttonColor}) : super(key: key);
  Color buttonColor;
  @override
  Widget build(context) {
    return RawMaterialButton(
      onPressed: () {
        Navigator.pushNamed(context, ReviewPage.routeName);
      },
      elevation: 2.0,
      fillColor: buttonColor,
      child: Icon(
        MdiIcons.pencilOutline,
        color: Colors.white,
        size: 30.0,
      ),
      padding: EdgeInsets.all(12.0),
      shape: CircleBorder(),
    );
  }
}
