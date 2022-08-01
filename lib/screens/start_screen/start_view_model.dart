import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:flutter/material.dart';
import 'package:hangeureut/providers/profile/profile_provider.dart';
import 'package:hangeureut/providers/profile/profile_state.dart';
import 'package:hangeureut/providers/signup/signup_provider.dart';
import 'package:hangeureut/widgets/error_dialog.dart';
import 'package:provider/provider.dart';
import 'package:hangeureut/providers/signup/signup_state.dart';

import '../../models/custom_error.dart';
import '../on_boarding_screen/on_boarding1_page.dart';
import '../splash_screen/splash_page.dart';

/// 카카오로그인을 수행하고 유저닉네임을 반환한다.
/// (닉네임 파악 실패는 null return, 로그인 실패는 error return)
Future<void> loginButtonPressed(BuildContext context) async {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => SplashPage()));
}
