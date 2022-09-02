import 'package:flutter/material.dart';
import 'package:hangeureut/constants.dart';
import 'package:hangeureut/models/friend.dart';
import 'package:hangeureut/providers/friend/recommend_friend_state.dart';
import 'package:hangeureut/providers/profile/profile_provider.dart';
import 'package:hangeureut/screens/basic_screen/basic_screen_page.dart';
import 'package:hangeureut/widgets/profile_icon_box.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../providers/profile/profile_state.dart';

class FriendRecommendPage extends StatefulWidget {
  const FriendRecommendPage({Key? key}) : super(key: key);
  static const String routeName = '/friend-recommend';

  @override
  State<FriendRecommendPage> createState() => _FriendRecommendPageState();
}

class _FriendRecommendPageState extends State<FriendRecommendPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<MealFriend> recommendFriends =
        context.read<RecommendFriendState>().recommendFriends;
    List realFriends = context.watch<ProfileState>().user.followings;
    List realFriendsId = [];
    for (var friend in realFriends) {
      realFriendsId.add(friend["id"]);
    }
    recommendFriends.removeWhere((e) => realFriendsId.contains(e.id));
    final myName = context.watch<ProfileState>().user.name;
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
                      context
                          .read<ProfileProvider>()
                          .setFriends(e.id, e.name, e.icon);
                      setState(() {});
                    },
                    child: Container(
                      width: double.infinity,
                      height: 28,
                      child: Center(
                          child: Text(
                        "찜하기",
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

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () async {
                    await context.read<ProfileProvider>().setLogin();
                    pushNewScreen(context,
                        screen: BasicScreenPage(
                          initialIndex: 2,
                        ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 34.0, top: 54),
                    child: Icon(Icons.arrow_back_ios),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 36,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${myName}",
                  style: TextStyle(
                      fontFamily: 'Suit',
                      color: kSecondaryTextColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 12),
                ),
                Text(
                  "님이 알 수도 잇는 친구들이에요.",
                  style: TextStyle(
                      fontFamily: 'Suit',
                      color: kSecondaryTextColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 12),
                ),
              ],
            ),
            SizedBox(
              height: 3,
            ),
            Text(
              "찜하고 친구의 기록을 계속 받아보세요!",
              style: TextStyle(
                  fontFamily: 'Suit',
                  color: kSecondaryTextColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 12),
            ),
            Expanded(
              child: GridView.count(
                childAspectRatio: 0.85,
                crossAxisCount: 2,
                children: friendsContainers,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
