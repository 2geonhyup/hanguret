// auth에 따라 분기시키는 역할을 하는 페이지
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:flutter/material.dart';
import 'package:hangeureut/constants.dart';
import 'package:hangeureut/providers/friend/recommend_friend_provider.dart';
import 'package:hangeureut/providers/news/news_provider.dart';
import 'package:hangeureut/providers/profile/profile_state.dart';
import 'package:hangeureut/screens/on_boarding_screen/on_boarding1_page.dart';
import 'package:hangeureut/screens/start_screen/start_page.dart';
import 'package:provider/provider.dart';

import '../../models/custom_error.dart';
import '../../providers/profile/profile_provider.dart';
import '../../providers/restaurants/restaurants_provider.dart';
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
  bool alReady = false;
  Future<String> _login() async {
    final String uid = fbAuth.FirebaseAuth.instance.currentUser!.uid;
    //동의 한 경우만 하도록 수정
    // try {
    //   await context.read<RecommendFriendProvider>().getRecommendFriends();
    // } on CustomError catch (e) {
    //   errorDialog(context, e);
    //   return;
    // }
    try {
      await context.read<RestaurantsProvider>().getRes(sortType: false);
    } on CustomError catch (e) {
      rethrow;
    }
    try {
      await context.read<ProfileProvider>().getProfile(uid: uid);
    } on CustomError catch (e) {
      rethrow;
    }

    final profileState = context.read<ProfileState>();
    final onBoardingState = profileState.user.onboarding;

    await Future.delayed(const Duration(milliseconds: 300));
    if (onBoardingState["level"] == 3) {
      Navigator.pushReplacementNamed(context, BasicScreenPage.routeName);
    } else if (onBoardingState["level"] == 2) {
      Navigator.pushReplacementNamed(context, OnBoarding1Page.routeName);
    } else {
      Navigator.pushReplacementNamed(context, OnBoarding1Page.routeName);
    }
    return "login";
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _login(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            errorDialog(
                context,
                CustomError(
                    code: "알림",
                    message: "유저 정보를 가져오는 과정에서 오류가 발생했습니다",
                    plugin: snapshot.error.toString()));
          }
          return Scaffold(
              resizeToAvoidBottomInset: false,
              body: Center(
                child: Stack(
                  children: [
                    Center(
                        child: Image.asset(
                      "images/fork.png",
                      width: 50,
                      color: snapshot.hasData
                          ? kBasicColor
                          : kBasicColor.withOpacity(0.6),
                    )),
                    Center(
                      child: SizedBox(
                          width: 114,
                          height: 114,
                          child: CircularProgressIndicator(
                            value: snapshot.hasData ? 1 : null,
                            color: kBasicColor,
                          )),
                    ),
                  ],
                ),
              ));
        });
  }
}
