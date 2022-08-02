import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;

import '../constants.dart';
import '../models/custom_error.dart';
import '../models/user_model.dart';

class ProfileRepository {
  final FirebaseFirestore firebaseFirestore;

  ProfileRepository({
    required this.firebaseFirestore,
  });

  Future<User> getProfile({required String uid}) async {
    try {
      final DocumentSnapshot userDoc = await usersRef.doc(uid).get();
      print(userDoc.exists);

      // 존재하는 uid를 입력받은 경우
      if (userDoc.exists) {
        print("profilerepo${userDoc.data()}");
        final User currentUser = User.fromDoc(userDoc);

        print("Profilerepo21${currentUser}");
        return currentUser;
      }

      throw 'User not found';
    } on FirebaseException catch (e) {
      throw CustomError(
        code: e.code,
        message: e.message!,
        plugin: e.plugin,
      );
    } catch (e) {
      print("profilerepo error");
      throw CustomError(
        code: 'Exception',
        message: e.toString(),
        plugin: 'flutter_error/server_error',
      );
    }
  }

  Future<void> setLogin() async {
    final String uid = fbAuth.FirebaseAuth.instance.currentUser!.uid;
    try {
      await usersRef.doc(uid).update({'first-login': false});
    } on FirebaseException catch (e) {
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

//onboarding1에서 활용할 setName함수
  Future<void> setName({required String name}) async {
    print("setname");
    final String uid = fbAuth.FirebaseAuth.instance.currentUser!.uid;
    try {
      await usersRef.doc(uid).update({'name': name});
    } on FirebaseException catch (e) {
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

//onboarding2에서 활용할 setOnboarding함수
  Future<void> setOnboarding({required Map? onboarding}) async {
    final String uid = fbAuth.FirebaseAuth.instance.currentUser!.uid;
    try {
      await usersRef.doc(uid).update({'onboarding': onboarding ?? {}});
    } on FirebaseException catch (e) {
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
