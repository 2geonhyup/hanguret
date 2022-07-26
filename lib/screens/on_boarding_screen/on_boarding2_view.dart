import 'package:flutter/material.dart';
import 'package:hangeureut/constants.dart';

Widget subTitleRow(iconPath, text, subText) {
  return Row(
    mainAxisSize: MainAxisSize.max,
    children: [
      Image.asset(
        iconPath,
        height: 22,
      ),
      SizedBox(
        width: 10,
      ),
      Text(
        text,
        style: TextStyle(
            fontFamily: 'Suit', fontWeight: FontWeight.w400, fontSize: 14),
      ),
      SizedBox(
        width: 13,
      ),
      Text(
        subText,
        style: TextStyle(
            fontFamily: 'Suit',
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: kBasicColor),
      ),
    ],
  );
}

class FoodInputField extends StatefulWidget {
  FoodInputField(
      {Key? key,
      required this.title,
      this.initialVal,
      required this.hintText,
      required this.onSubmit})
      : super(key: key);
  final String title;
  final String hintText;
  final String? initialVal;
  final void Function(String?) onSubmit;

  @override
  State<FoodInputField> createState() => _FoodInputFieldState();
}

class _FoodInputFieldState extends State<FoodInputField> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          children: [
            subTitleRow("images/icons/emoji-happy.png", widget.title, ""),
            SizedBox(
              height: 14,
            ),
            Container(
              height: 45,
              child: TextFormField(
                initialValue: widget.initialVal,
                style: TextStyle(
                    fontFamily: 'Suit',
                    fontWeight: FontWeight.w300,
                    fontSize: 13),
                onFieldSubmitted: widget.onSubmit,
                onChanged: widget.onSubmit,
                textInputAction: TextInputAction.done,
                textAlign: TextAlign.left,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(15.5),
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color(0xff3c3e24).withOpacity(0.3),
                          width: 0.5),
                      borderRadius: BorderRadius.circular(17)),
                  hintText: widget.hintText,
                  hintStyle: TextStyle(
                      fontFamily: 'Suit',
                      fontWeight: FontWeight.w300,
                      color: Colors.grey.withOpacity(0.7),
                      fontSize: 13),
                ),
              ),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: kBasicColor.withOpacity(0.3),
                      blurRadius: 6,
                      spreadRadius: 0,
                      offset: Offset(
                        0,
                        1,
                      )),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.circular(17),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SpicyLevelButton extends StatelessWidget {
  SpicyLevelButton(
      {Key? key,
      required this.image,
      required this.text,
      required this.onPressed,
      required this.clicked})
      : super(key: key);
  final String image;
  final String text;
  final Function() onPressed;
  final bool clicked;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
                top: 22,
                left: 0,
                right: 0,
                child: Image.asset(
                  image,
                  height: 15,
                )),
            Positioned(
              top: 42,
              child: Text(
                text,
                style: TextStyle(
                    fontSize: 13,
                    fontFamily: "Suit",
                    color: clicked ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w300),
              ),
            )
          ],
        ),
        style: ElevatedButton.styleFrom(
            fixedSize: Size(76, 76),
            shadowColor: kBasicColor.withOpacity(0.3),
            elevation: 5,
            shape: CircleBorder(),
            primary: clicked ? kBasicColor : Colors.white));
  }
}
