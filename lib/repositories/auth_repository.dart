// fbAuth로 임포하는 이유는 우리가 정의한 usermodel과 firebase의 usermodel이 충돌하는 것을 방지하기 위함이다.
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:hangeureut/models/custom_error.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

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

  Future<void> appleLogin() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final oauthCredential = fbAuth.OAuthProvider("apple.com").credential(
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode,
      );
      try {
        final signedInCredential =
            await firebaseAuth.signInWithCredential(oauthCredential);
        final signedInUser = signedInCredential.user;

        final DocumentSnapshot userDoc =
            await usersRef.doc(signedInUser!.uid).get();
        if (!userDoc.exists) {
          await usersRef.doc(signedInUser.uid).set({
            'name': "",
            'email': signedInUser.email,
            'first-login': true,
            'icon': Random().nextInt(78),
            'c-id': getRandomString(12, signedInUser.uid),
          });
        }
      } catch (e) {
        print(e);
      }
    } catch (e) {
      throw CustomError(message: "애플 로그인 오류");
    }
  }

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
        // print("authrepooooo$userDoc");

        if (!userDoc.exists) {
          await usersRef.doc(signedInUser.uid).set({
            'name': signedInUser.displayName!.substring(1),
            'email': signedInUser.email,
            'first-login': true,
            'icon': Random().nextInt(78),
            'c-id': getRandomString(12, signedInUser.uid),
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

  Future<void> delUser(
      {required List followings, required List followers}) async {
    try {
      fbAuth.User? user = fbAuth.FirebaseAuth.instance.currentUser;
      print(user);
      if (user == null) return;
      for (var friend in followings) {
        await usersRef
            .doc(friend["id"])
            .collection("followers")
            .doc(user.uid)
            .delete();
      }
      for (var friend in followers) {
        await usersRef
            .doc(friend["id"])
            .collection("followings")
            .doc(user.uid)
            .delete();
      }
      usersRef.doc(user.uid).collection('followers').get().then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      });
      usersRef.doc(user.uid).collection('followings').get().then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      });
      await usersRef.doc(user.uid).delete();
      await user.delete();
      await firebaseAuth.signOut();
    } catch (e) {
      throw CustomError(
          message: "탈퇴 중 오류가 발생했습니다", code: "알림", plugin: e.toString());
    }
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
