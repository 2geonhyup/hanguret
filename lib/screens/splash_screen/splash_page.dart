// auth에 따라 분기시키는 역할을 하는 페이지
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:flutter/material.dart';
import 'package:hangeureut/providers/profile/profile_state.dart';
import 'package:hangeureut/screens/main_screen/main_screen_page.dart';
import 'package:hangeureut/screens/on_boarding_screen/on_boarding1_page.dart';
import 'package:provider/provider.dart';

import '../../providers/profile/profile_provider.dart';
import '../basic_screen/basic_screen_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);
  static const String routeName = '/splash';

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  void _getProfile() async {
    //stream provider로 위젯트리에 제공한 user정보 이용한 것 이용한 것
    final String uid = fbAuth.FirebaseAuth.instance.currentUser!.uid;
    // init state에서 async함수를 호출하는 것은 ui의 inconsistency를 야기시킬 수 있음
    await context.read<ProfileProvider>().getProfile(uid: uid);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getProfile();
  }

  @override
  Widget build(BuildContext context) {
    final onboardingState =
        context.read<ProfileState>().user.onboarding["level"];
    print("onboardingstate${onboardingState}");

    if (onboardingState == 3) {
      // build 내에서 네비게이션을 하기 때문에, safe한 동작을 위해 addpostframecallback을 사용
      // 이렇게 하면, 현재 build 작업이 끝난 후에 해당 동작을 실행할 수 있음
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        Navigator.pushNamed(context, BasicScreenPage.routeName);
      });
    } else {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        Navigator.pushNamed(context, OnBoarding1Page.routeName);
      });
    }
    return Scaffold(
        body: Center(
      child: CircularProgressIndicator(),
    ));
  }
}
