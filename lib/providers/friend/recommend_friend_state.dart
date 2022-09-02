import 'package:equatable/equatable.dart';
import 'package:hangeureut/models/friend.dart';

class RecommendFriendState extends Equatable {
  final List<MealFriend> recommendFriends;

  RecommendFriendState({required this.recommendFriends});

  factory RecommendFriendState.initial() {
    return RecommendFriendState(recommendFriends: []);
  }

  @override
  List<Object> get props => [recommendFriends];

  @override
  bool get stringify => true;

  RecommendFriendState copyWith({List<MealFriend>? recommendFriends}) {
    return RecommendFriendState(
        recommendFriends: recommendFriends ?? this.recommendFriends);
  }
}
