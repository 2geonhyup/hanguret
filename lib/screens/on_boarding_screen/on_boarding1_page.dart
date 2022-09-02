import 'package:flutter/material.dart';
import 'package:hangeureut/providers/profile/profile_state.dart';
import 'package:hangeureut/widgets/bottom_navigation_bar.dart';
import 'package:hangeureut/widgets/progress_bar.dart';
import 'package:provider/provider.dart';

import '../../models/custom_error.dart';
import '../../providers/profile/profile_provider.dart';
import '../../widgets/error_dialog.dart';
import 'on_boarding1_view.dart';
import 'on_boarding2_page.dart';

class OnBoarding1Page extends StatefulWidget {
  static const String routeName = '/onboarding1';

  @override
  State<OnBoarding1Page> createState() => _OnBoarding1PageState();
}

class _OnBoarding1PageState extends State<OnBoarding1Page> {
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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: BasicBottomNavigationBar(
          option1: "취소",
          option2: "다음",
          nav1: OnBoarding1Page.routeName,
          nav2: OnBoarding2Page.routeName,
          withNav2: () async {
            try {
              await context.read<ProfileProvider>().setName(name: name);
              return true;
            } on CustomError catch (e) {
              errorDialog(context, e);
              return false;
            }
          },
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 84,
                ),
                NickNameSetting(
                  name: name,
                  originName: originName,
                  changeName: (val) {
                    setState(() {
                      if (val == "" || val == null) {
                        name = originName;
                      } else {
                        name = val;
                      }
                    });
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: ProgressBar(level: 1),
            )
          ],
        ),
      ),
    );
  }
}
