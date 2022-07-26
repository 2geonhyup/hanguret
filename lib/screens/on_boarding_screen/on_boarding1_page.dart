import 'package:flutter/material.dart';
import 'package:hangeureut/providers/profile/profile_state.dart';

import 'package:hangeureut/screens/on_boarding_screen/on_boarding2_page.dart';
import 'package:hangeureut/widgets/progress_bar.dart';
import 'package:provider/provider.dart';
import '../../models/custom_error.dart';
import '../../providers/profile/profile_provider.dart';
import '../../widgets/error_dialog.dart';
import 'on_boarding1_view.dart';
import 'package:hangeureut/widgets/bottom_navigation_bar.dart';

import 'package:firebase_auth/firebase_auth.dart' as fbAuth;

class OnBoarding1Page extends StatefulWidget {
  static const String routeName = '/onboarding1';

  @override
  State<OnBoarding1Page> createState() => _OnBoarding1PageState();
}

class _OnBoarding1PageState extends State<OnBoarding1Page> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                NickNameSetting(),
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
