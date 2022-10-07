// fbAuth로 임포하는 이유는 우리가 정의한 usermodel과 firebase의 usermodel이 충돌하는 것을 방지하기 위함이다.
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:hangeureut/models/custom_error.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

import '../constants.dart';
import 'auth_repositories_functions.dart';

class AuthRepository {
  final FirebaseFirestore firebaseFirestore;
  final fbAuth.FirebaseAuth firebaseAuth;
  FirebaseFunctions functions = FirebaseFunctions.instance;

  AuthRepository({
    required this.firebaseFirestore,
    required this.firebaseAuth,
  });

  // firebase user의 상태가 변할 때마다 알려줌
  // 따라서 listen으로 적절한 조치를 취하면 됨
  Stream<fbAuth.User?> get user => firebaseAuth.userChanges();

  Future<dynamic> loginOrSignup() async {
    // get user info from kakao
    OAuthToken? kakaoToken;
    late String firebaseToken;
    try {
      kakaoToken = await kakaoLogin();

      // set user in firebase
      try {
        firebaseToken = await createOrUpdateUser(kakaoToken!.accessToken);
      } catch (e) {
        //setfirebaseuser error
        rethrow;
      }
      try {
        final signedInUser = await _login(firebaseToken: firebaseToken);

        // userRef: user 콜렉션 경로
        final DocumentSnapshot userDoc =
            await usersRef.doc(signedInUser.uid).get();
        print("authrepooooo$userDoc");
        if (!userDoc.exists) {
          await usersRef.doc(signedInUser.uid).set({
            'name': signedInUser.displayName!.substring(1),
            'email': signedInUser.email,
            'first-login': true,
            'icon': Random().nextInt(78),
            'c-id': getRandomString(10, signedInUser.uid),
          });
        }
      } catch (e) {
        //firebaselogin error
        rethrow;
      }
    } catch (e) {
      //kakaologin error
      rethrow;
    }
  }

  Future<void> signout() async {
    await firebaseAuth.signOut();
  }

  Future<fbAuth.User> _login({
    required String firebaseToken,
  }) async {
    try {
      final fbAuth.UserCredential userCredential =
          await firebaseAuth.signInWithCustomToken(firebaseToken);
      return userCredential.user!;
    } on fbAuth.FirebaseAuthException catch (e) {
      throw CustomError(
        code: e.code,
        message: e.message!,
        plugin: e.plugin,
      );
    } catch (e) {
      throw CustomError(
        code: 'Exception',
        message: e.toString(),
        plugin: 'flutter_error/server_error',
      );
    }
  }
}

Random _rnd = Random();

String getRandomString(int length, String _chars) =>
    String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
