import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'dart:convert';

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final Map onboarding;

  User(
      {required this.id,
      required this.name,
      required this.email,
      required this.onboarding});

  factory User.fromDoc(DocumentSnapshot userDoc) {
    final userData = userDoc.data() as Map<String, dynamic>?;
    print("userfromdoc${userData}");
    //onboarding 필드만 null으로 나옴

    return User(
        id: userDoc.id,
        name: userData!['name'],
        email: userData['email'],
        onboarding: userData['onboarding'] ?? {});
  }

  // 어떤 state에서 유저정보를 읽어올 때,
  // 앱이 시작될 때는 서버에서 데이터를 읽어오기 전이기에
  // user 관련정보는 null이 되고 로그아웃 할 때도 null 이 된다.
  // null을 허용하면, 귀찮은 일이 많이 생길 수 있어서
  // 겹칠 염려가 없는 non-null user를 사용하기 위해서 해당 initialuser()를 만듦
  factory User.initialUser() {
    return User(id: '', name: '', email: '', onboarding: {});
  }

  @override
  List<Object> get props {
    return [id, name, email, onboarding];
  }

  @override
  bool get stringify => true;
}
