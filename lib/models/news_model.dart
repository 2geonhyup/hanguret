import 'package:equatable/equatable.dart';
//newsType
//0: 누가 나를 구독함 1: 누가 내 기록을 좋아함(할 수 있을까...) 2: 한그릇 콘텐츠

class FriendsNews extends Equatable {
  final String userId;
  final String userName;
  final int userIcon;
  final String cId;

  FriendsNews(
      {required this.userId,
      required this.userName,
      required this.userIcon,
      required this.cId});

  @override
  List<Object> get props => [userId, userName, userIcon, cId];
  @override
  bool get stringify => true;
}

class ReviewNews extends Equatable {
  final String userId;
  final String userName;
  final int userIcon;
  final String resName;
  final String cId;

  ReviewNews(
      {required this.userId,
      required this.userName,
      required this.userIcon,
      required this.resName,
      required this.cId});

  @override
  List<Object> get props => [userName, userIcon];
  @override
  bool get stringify => true;
}

class HangerutNews extends Equatable {
  final String title;
  final String content;
  final String navigate;

  HangerutNews(
      {required this.title, required this.content, required this.navigate});

  @override
  List<Object> get props => [title, content, navigate];
  @override
  bool get stringify => true;
}

class News extends Equatable {
  final int type;
  final dynamic content;
  final bool watched;

  News({required this.type, required this.content, required this.watched});

  @override
  // TODO: implement props
  List<Object> get props => [type, watched, content];
}
