import 'package:flutter/material.dart';
import 'package:hangeureut/constants.dart';
import 'package:hangeureut/models/friend.dart';
import 'package:hangeureut/providers/friend/recommend_friend_state.dart';
import 'package:hangeureut/screens/friend_screen/friends_page.dart';
import 'package:hangeureut/widgets/profile_icon_box.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import 'friend_recommend_view.dart';

class FriendRecommendPage extends StatelessWidget {
  const FriendRecommendPage({Key? key}) : super(key: key);
  static const String routeName = '/friend-recommend';

  @override
  Widget build(BuildContext context) {
    List<MealFriend> recommendFriends =
        context.watch<RecommendFriendState>().recommendFriends;
    // recommendFriends = [
    //   recommendFriends[0],
    //   recommendFriends[0],
    //   recommendFriends[0],
    // ];
    bool odd = false;
    List<Widget> friendsContainers = recommendFriends.map((e) {
      odd = !odd;
      return Padding(
        padding: odd
            ? EdgeInsets.only(left: 31, right: 7.5, bottom: 15)
            : EdgeInsets.only(left: 7.5, right: 31, bottom: 15),
        child: Container(
          width: 154,
          height: 203,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                    color: Color(0xff000000).withOpacity(0.08),
                    blurRadius: 17,
                    spreadRadius: 0,
                    offset: Offset(
                      0,
                      4,
                    )),
              ]),
          child: Column(
            children: [
              SizedBox(
                height: 27,
              ),
              ProfileIconBox(content: profileIcons[e.icon]),
              SizedBox(
                height: 10,
              ),
              Text(
                e.name,
                style: TextStyle(
                    fontFamily: 'Suit',
                    color: kBasicTextColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 20),
              ),
              SizedBox(
                height: 3,
              ),
              Text(
                "@${e.id}",
                style: TextStyle(
                    fontFamily: 'Suit',
                    color: kBasicTextColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 11),
              ),
              SizedBox(
                height: 28,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 27),
                child: GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return FriendRequestDialog(friend: e);
                          });
                    },
                    child: Container(
                      width: double.infinity,
                      height: 28,
                      child: Center(
                          child: Text(
                        "친구 맺기",
                        style: TextStyle(
                            fontFamily: 'Suit',
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 12),
                      )),
                      decoration: BoxDecoration(
                          color: kSecondaryTextColor,
                          borderRadius: BorderRadius.circular(14)),
                    )),
              )
            ],
          ),
        ),
      );
    }).toList();

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  pushNewScreen(context,
                      screen: FriendsPage(),
                      withNavBar: true,
                      pageTransitionAnimation:
                          PageTransitionAnimation.slideRight);
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 34.0, top: 53),
                  child: Icon(Icons.arrow_back_ios),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 36,
          ),
          Text("밥친구를 맺으면 서로의 플레이스를 확인하고,"),
          Text("친구의 식사 기록을 구경할 수 있습니다."),
          Expanded(
            child: GridView.count(
              childAspectRatio: 0.85,
              crossAxisCount: 2,
              children: friendsContainers,
            ),
          ),
        ],
      ),
    );
  }
}
