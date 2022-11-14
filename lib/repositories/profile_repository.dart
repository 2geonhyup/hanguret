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
      List savedList = [];
      final DocumentSnapshot userDoc = await usersRef.doc(uid).get();

      final QuerySnapshot followings =
          await usersRef.doc(uid).collection('followings').get();
      if (followings.docs.isNotEmpty) {
        for (var e in followings.docs) {
          followingList.add(await getUserViewInfo(id: e.id));
        }
      }
      final QuerySnapshot followers =
          await usersRef.doc(uid).collection('followers').get();
      if (followers.docs.isNotEmpty) {
        for (var e in followers.docs) {
          followerList.add(await getUserViewInfo(id: e.id));
        }
      }
      final QuerySnapshot saved =
          await usersRef.doc(uid).collection('saved').get();
      if (saved.docs.isNotEmpty) {
        savedList = saved.docs.map((e) => e.data()).toList();
      }
      // 존재하는 uid를 입력받은 경우
      if (userDoc.exists) {
        final User currentUser =
            User.fromDoc(userDoc, followerList, followingList, savedList);

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
        code: 'getprofilerepo',
        message: e.toString(),
        plugin: 'flutter_error/server_error',
      );
    }
  }

  Future<List> getFollower({required String myId}) async {
    List followerList = [];
    try {
      final QuerySnapshot followers =
          await usersRef.doc(myId).collection('followers').get();
      if (followers.docs.isNotEmpty) {
        for (var e in followers.docs) {
          followerList.add(await getUserViewInfo(id: e.id));
        }
      }
    } catch (e) {
      throw CustomError(code: "알림", message: "팔로워 목록을 가져오는 중 오류가 발생했습니다");
    }

    return followerList;
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

  Future<void> setIcon({required int icon}) async {
    final String uid = fbAuth.FirebaseAuth.instance.currentUser!.uid;
    try {
      await usersRef.doc(uid).update({'icon': icon});
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

  Future<void> setCID({required String cID}) async {
    final String uid = fbAuth.FirebaseAuth.instance.currentUser!.uid;
    try {
      await usersRef.doc(uid).update({'c-id': cID});
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
      {required String myId,
      required int myIcon,
      required String myName,
      required String id,
      required String name,
      required int icon,
      bool? remove}) async {
    try {
      if (remove == true) {
        await usersRef.doc(myId).collection('followings').doc(id).delete();
        await usersRef.doc(id).collection('followers').doc(myId).delete();
        await usersRef.doc(id).collection('news').doc(myId).delete();
      } else {
        await usersRef
            .doc(myId)
            .collection('followings')
            .doc(id)
            .set({"id": id});
        await usersRef.doc(id).collection('news').doc(myId).set({
          "type": 1,
          "date": DateTime.now(),
          "content": {
            "id": myId,
            "name": myName,
            "icon": myIcon,
          }
        });
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

  Future<Map> getUserViewInfo({required String id}) async {
    try {
      DocumentSnapshot searchById = await usersRef.doc(id).get();
      Map? data = searchById.data() as Map<String, dynamic>?;
      return {
        "id": searchById.id,
        "cId": data!["c-id"] ?? "",
        "name": data["name"] ?? "",
        "icon": data["icon"] ?? 0,
      };
    } catch (e) {
      throw CustomError(code: "알림", message: "유저 정보를 가져오지 못했습니다.");
    }
  }

  //all user search
  Future<List> allUserSearch(
      {required String searchTerm, required List preSearchedId}) async {
    List searchByNameList = [];
    List searchByCIdList = [];

    try {
      Query searchByName = usersRef.where("name", isEqualTo: searchTerm);
      QuerySnapshot dataN = await searchByName.get();
      bool nameSearched = dataN.docs.isNotEmpty;

      if (nameSearched) {
        QuerySnapshot searchByNameFt = preSearchedId.isNotEmpty
            ? await searchByName
                .where(FieldPath.documentId, whereNotIn: preSearchedId)
                .get()
            : await searchByName.get();
        searchByNameList = searchByNameFt.docs.map((e) {
          Map? user = e.data() as Map<String, dynamic>?;
          return {
            "id": e.id,
            "cId": user!["c-id"],
            "icon": user["icon"] ?? 0,
            "name": user["name"] ?? "",
          };
        }).toList();
      }

      Query searchByCId = usersRef.where("c-id", isEqualTo: searchTerm);
      QuerySnapshot dataI = await searchByCId.get();
      bool cIdSearched = dataI.docs.isNotEmpty;

      if (cIdSearched) {
        QuerySnapshot searchByCIdFt = preSearchedId.isNotEmpty
            ? await searchByCId
                .where(FieldPath.documentId, whereNotIn: preSearchedId)
                .get()
            : await searchByCId.get();

        searchByCIdList = searchByCIdFt.docs.map((e) {
          Map? user = e.data() as Map<String, dynamic>?;
          return {
            "id": e.id,
            "cId": user!["c-id"],
            "icon": user["icon"] ?? 0,
            "name": user["name"] ?? "",
          };
        }).toList();
      }
    } catch (e) {
      throw CustomError(
        code: "알림",
        message: e.toString(),
      );
    }

    return [...searchByNameList, ...searchByCIdList];
  }
}
