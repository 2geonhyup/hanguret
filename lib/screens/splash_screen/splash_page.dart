// auth에 따라 분기시키는 역할을 하는 페이지
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:flutter/material.dart';
import 'package:hangeureut/constants.dart';
import 'package:hangeureut/providers/friend/recommend_friend_provider.dart';
import 'package:hangeureut/providers/profile/profile_state.dart';
import 'package:hangeureut/screens/main_screen/main_screen_page.dart';
import 'package:hangeureut/screens/on_boarding_screen/on_boarding1_page.dart';
import 'package:provider/provider.dart';

import '../../models/custom_error.dart';
import '../../providers/profile/profile_provider.dart';
import '../../providers/signup/signup_provider.dart';
import '../../widgets/error_dialog.dart';
import '../basic_screen/basic_screen_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);
  static const String routeName = '/splash';

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool completed = false;
  Future<void> _login() async {
    try {
      await context.read<SignupProvider>().signup();
    } on CustomError catch (e) {
      errorDialog(context, e);
    }
    final String uid = fbAuth.FirebaseAuth.instance.currentUser!.uid;
    try {
      await context.read<ProfileProvider>().getProfile(uid: uid);
    } on CustomError catch (e) {
      errorDialog(context, e);
    }
    try {
      await context.read<RecommendFriendProvider>().getRecommendFriends();
    } on CustomError catch (e) {
      errorDialog(context, e);
    }

    completed = true;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _login();
  }

  @override
  Widget build(BuildContext context) {
    final onBoardingState = context.watch<ProfileState>().user.onboarding;
    print("hereisproblem$onBoardingState");
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (onBoardingState["level"] == 3) {
        Navigator.pushNamed(context, BasicScreenPage.routeName);
      } else if (onBoardingState["level"] == 2) {
        Navigator.pushNamed(context, OnBoarding1Page.routeName);
      } else if (onBoardingState.length == 0 && completed) {
        Navigator.pushNamed(context, OnBoarding1Page.routeName);
      }
    });

    return Scaffold(
        body: Center(
      child: Stack(
        children: [
          Center(
              child: Image.asset(
            "images/fork.png",
            width: 50,
          )),
          Center(
            child: SizedBox(
                width: 114,
                height: 114,
                child: CircularProgressIndicator(
                  color: kBasicColor,
                )),
          ),
        ],
      ),
    ));
  }
}
