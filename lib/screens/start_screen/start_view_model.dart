import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../splash_screen/splash_page.dart';

/// 카카오로그인을 수행하고 유저닉네임을 반환한다.
/// (닉네임 파악 실패는 null return, 로그인 실패는 error return)
Future<void> loginButtonPressed(BuildContext context) async {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => SplashPage()));
}
