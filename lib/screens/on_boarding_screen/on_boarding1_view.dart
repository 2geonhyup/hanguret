import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:flutter/material.dart';
import 'package:hangeureut/constants.dart';
import 'package:hangeureut/models/custom_error.dart';
import 'package:provider/provider.dart';

import '../../providers/profile/profile_provider.dart';
import '../../providers/profile/profile_state.dart';
import '../../widgets/error_dialog.dart';

class NickNameSetting extends StatefulWidget {
  const NickNameSetting({Key? key}) : super(key: key);

  @override
  State<NickNameSetting> createState() => _NickNameSettingState();
}

class _NickNameSettingState extends State<NickNameSetting> {
  final _formkey = GlobalKey<FormState>();
  String? name = "";
  String? originName = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name = context.read<ProfileState>().user.name;
    originName = name;
  }

  @override
  Widget build(BuildContext context) {
    print("name${originName}");
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
              "$name",
              style: TextStyle(color: Colors.white, fontSize: 15),
            )),
            decoration: BoxDecoration(
              color: kBasicColor,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 33.0),
          child: Container(
            height: 47,
            child: Form(
              key: _formkey,
              child: TextFormField(
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "직접 입력",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                ),
                onChanged: (String? value) {
                  setState(() {
                    name = value;
                  });
                },
                onFieldSubmitted: (val) async {
                  print(name);
                  name == "" || name == null ? name = originName : null;
                  try {
                    await context.read<ProfileProvider>().setName(name: name);
                  } on CustomError catch (e) {
                    errorDialog(context, e);
                  }
                },
              ),
            ),
            decoration: BoxDecoration(
              color: Color(0xFFE1E1D5).withOpacity(0.39),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}
