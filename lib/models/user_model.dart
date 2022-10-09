import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final Map onboarding;
  final List followings;
  final List followers;
  final int icon;
  final bool first;
  final List saved;
  final String cId;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.onboarding,
    required this.followings,
    required this.followers,
    required this.icon,
    required this.first,
    required this.saved,
    required this.cId,
  });

  factory User.fromDoc(DocumentSnapshot userDoc, List followers,
      List followings, List savedList) {
    final userData = userDoc.data() as Map<String, dynamic>?;

    //onboarding은 가입할 당시에는 null일 수 있다. 나머지는 정해진다.
    return User(
        id: userDoc.id,
        name: userData!['name'],
        email: userData['email'],
        onboarding: userData['onboarding'] ?? {},
        followings: followings,
        followers: followers,
        icon: userData['icon'] ?? 0,
        first: userData['first-login'] ?? false,
        saved: savedList,
        cId: userData["c-id"] ?? "");
  }

  // 어떤 state에서 유저정보를 읽어올 때,
  // 앱이 시작될 때는 서버에서 데이터를 읽어오기 전이기에
  // user 관련정보는 null이 되고 로그아웃 할 때도 null 이 된다.
  // null을 허용하면, 귀찮은 일이 많이 생길 수 있어서
  // 겹칠 염려가 없는 non-null user를 사용하기 위해서 해당 initialuser()를 만듦
  factory User.initialUser() {
    return User(
      id: '',
      name: '',
      email: '',
      onboarding: {},
      followings: [],
      followers: [],
      icon: 0,
      first: false,
      saved: [],
      cId: '',
    );
  }

  @override
  List<Object> get props {
    return [
      id,
      name,
      email,
      onboarding,
      followings,
      followers,
      icon,
      first,
      saved,
      cId,
    ];
  }

  User copyWith(
      {String? id,
      String? name,
      String? email,
      Map? onboarding,
      List? followings,
      List? followers,
      int? icon,
      bool? first,
      List? saved,
      String? cId}) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      onboarding: onboarding ?? this.onboarding,
      followings: followings ?? this.followings,
      followers: followers ?? this.followers,
      icon: icon ?? this.icon,
      first: first ?? this.first,
      saved: saved ?? this.saved,
      cId: cId ?? this.cId,
    );
  }

  @override
  bool get stringify => true;
}
