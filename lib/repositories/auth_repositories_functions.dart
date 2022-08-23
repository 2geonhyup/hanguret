// 카카오 로그인 후 토큰 반환
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import '../models/custom_error.dart';
import 'package:hangeureut/models/custom_error.dart';
import 'package:cloud_functions/cloud_functions.dart';

Future<OAuthToken?> kakaoLogin() async {
  bool installed = await isKakaoTalkInstalled();
  // 카카오톡 설치된 경우
  if (installed) {
    try {
      OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
      return token;
    } catch (e) {
      // 사용자가 로그인하다가 중간에 취소한 경우
      if (e is PlatformException && e.code == 'CANCELED') {
        return null;
      }
      // 중간에 취소한 경우가 아니라면 카카오계정으로 로그인
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
        return token;
      } catch (error) {
        throw CustomError(
            code: 'Login Failed',
            message: e.toString(),
            plugin: 'flutter_error/server_error');
      }
    }
  }
  // 카카오톡 미설치인 경우
  else {
    try {
      OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
      return token;
    } catch (e) {
      throw CustomError(
          code: 'Login Failed',
          message: e.toString(),
          plugin: 'flutter_error/server_error');
    }
  }
}

Future<Map<String, String>?> getUserInfoFromKakao() async {
  try {
    User user = await UserApi.instance.me();

    return {
      'id': '${user.id}',
      'name': '${user.kakaoAccount?.profile?.nickname}',
      'email': '${user.kakaoAccount?.email}'
    };
  } catch (e) {
    throw CustomError(
        code: 'KakaoGetUser Exception',
        message: e.toString(),
        plugin: 'flutter_error/server_error');
  }
}

Future<String> createOrUpdateUser(accessToken) async {
  HttpsCallable callable =
      FirebaseFunctions.instanceFor(region: 'asia-northeast3')
          .httpsCallable('kakaoToken');
  try {
    final result = await callable.call({"access_token": accessToken});

    return result.data.toString();
  } catch (e) {
    throw CustomError(
        code: 'SetFirebaseUser Exception',
        message: e.toString(),
        plugin: 'flutter_error/server_error');
  }
}
