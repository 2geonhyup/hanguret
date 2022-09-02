import 'package:flutter/material.dart';
import 'package:hangeureut/constants.dart';

class NickNameSetting extends StatefulWidget {
  NickNameSetting(
      {Key? key,
      required this.name,
      required this.originName,
      required this.changeName})
      : super(key: key);

  String? name;
  String? originName = "";
  Function changeName;

  @override
  State<NickNameSetting> createState() => _NickNameSettingState();
}

class _NickNameSettingState extends State<NickNameSetting> {
  final _formkey = GlobalKey<FormState>();
  bool change = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 33.0),
          child: Text(
            "닉네임 설정",
            style: TextStyle(
                fontFamily: 'Suit',
                fontSize: 20.0,
                fontWeight: FontWeight.w600),
          ),
        ),
        SizedBox(
          height: 48,
          child: Divider(
            color: kBorderGreenColor.withOpacity(0.5),
          ),
        ),
        SizedBox(height: 11),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 33.0),
          child: Container(
            height: 47,
            child: Center(
                child: Text(
              "${widget.name}",
              style: TextStyle(color: Colors.white, fontSize: 15),
            )),
            decoration: BoxDecoration(
              color: change ? Color(0xffc7c7c0) : kBasicColor,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 33.0),
          child: Focus(
            onFocusChange: (focus) {
              if (focus) {
                setState(() {
                  change = true;
                });
              } else {
                setState(() {
                  change = false;
                });
              }
            },
            child: Container(
              height: 47,
              child: Form(
                key: _formkey,
                child: TextFormField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "직접 입력",
                    hintStyle: TextStyle(
                        color: change ? Colors.transparent : Colors.grey,
                        fontSize: 15),
                  ),
                  onChanged: (val) {
                    widget.changeName(val);
                  },
                ),
              ),
              decoration: BoxDecoration(
                color: kBasicColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
