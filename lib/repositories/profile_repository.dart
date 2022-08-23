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
      List followingList = [];
      List followerList = [];
      final DocumentSnapshot userDoc = await usersRef.doc(uid).get();

      final QuerySnapshot followings =
          await usersRef.doc(uid).collection('followings').get();
      if (followings.docs.isNotEmpty) {
        followingList = followings.docs.map((e) => e.data()).toList();
      }
      final QuerySnapshot followers =
          await usersRef.doc(uid).collection('followers').get();
      if (followers.docs.isNotEmpty) {
        followerList = followers.docs.map((e) => e.data()).toList();
      }
      // 존재하는 uid를 입력받은 경우
      if (userDoc.exists) {
        final User currentUser =
            User.fromDoc(userDoc, followerList, followingList);

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

  Future<void> setFollowings(
      {required String id,
      required String name,
      required int icon,
      bool? remove}) async {
    final String curUid = fbAuth.FirebaseAuth.instance.currentUser!.uid;
    try {
      if (remove == true) {
        await usersRef.doc(curUid).collection('followings').doc(id).delete();
        await usersRef.doc(id).collection('followers').doc(curUid).delete();
      } else {
        await usersRef
            .doc(curUid)
            .collection('followings')
            .doc(id)
            .set({"id": id, "name": name, "icon": icon});
      }
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

  Future<void> setFollowers(
      {required String followingId, required User currentUser}) async {
    try {
      await usersRef
          .doc(followingId)
          .collection('followers')
          .doc(currentUser.id)
          .set({
        "id": currentUser.id,
        "name": currentUser.name,
        "icon": currentUser.icon
      });
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
