import 'package:flutter/material.dart';
import 'package:hangeureut/constants.dart';
import 'package:hangeureut/models/friend.dart';
import 'package:hangeureut/providers/friend/recommend_friend_state.dart';
import 'package:hangeureut/providers/profile/profile_provider.dart';
import 'package:hangeureut/widgets/profile_icon_box.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:provider/provider.dart';

import '../../models/custom_error.dart';
import '../../providers/friend/recommend_friend_provider.dart';
import '../../providers/profile/profile_state.dart';
import '../../widgets/error_dialog.dart';

class FriendRecommendPage extends StatefulWidget {
  const FriendRecommendPage({Key? key}) : super(key: key);
  static const String routeName = '/friend-recommend';

  @override
  State<FriendRecommendPage> createState() => _FriendRecommendPageState();
}

class _FriendRecommendPageState extends State<FriendRecommendPage> {
  Future<void> _getRecommends() async {
    //동의 한 경우만 하도록 수정
    try {
      await context.read<RecommendFriendProvider>().getRecommendFriends();
    } on CustomError catch (e) {
      errorDialog(context, e);
      return;
    }
  }

  Future<bool> getKakaoFriends() async {
    if (await AuthApi.instance.hasToken()) {
      try {
        AccessTokenInfo tokenInfo = await UserApi.instance.accessTokenInfo();
        await _getRecommends();
        return true;
      } catch (error) {
        try {
          // 카카오 계정으로 로그인
          OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
          await _getRecommends();
          return true;
        } catch (error) {
          return false;
        }
      }
    } else {
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
        await _getRecommends();
        return true;
      } catch (error) {
        return false;
      }
    }
  }

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     _getRecommends();
  //     setState(() {});
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: getKakaoFriends(),
          builder: (context, snapshot) {
            List<MealFriend> recommendFriends =
                context.watch<RecommendFriendState>().recommendFriends;
            List realFriends = context.watch<ProfileState>().user.followings;
            if (snapshot.data == true) {
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
                      ? const EdgeInsets.only(left: 31, right: 7.5, bottom: 15)
                      : const EdgeInsets.only(left: 7.5, right: 31, bottom: 15),
                  child: Container(
                    width: 154,
                    height: 203,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                              color: const Color(0xff000000).withOpacity(0.08),
                              blurRadius: 17,
                              spreadRadius: 0,
                              offset: const Offset(
                                0,
                                4,
                              )),
                        ]),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 27,
                        ),
                        ProfileIconBox(content: profileIcons[e.icon]),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          e.name,
                          style: const TextStyle(
                              fontFamily: 'Suit',
                              color: kBasicTextColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 20),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Text(
                          "@${e.id}",
                          style: const TextStyle(
                              fontFamily: 'Suit',
                              color: kBasicTextColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 11),
                        ),
                        const SizedBox(
                          height: 28,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 27),
                          child: GestureDetector(
                              onTap: () {
                                context
                                    .read<ProfileProvider>()
                                    .setFriends(e.id, e.name, e.icon, e.cId);
                                setState(() {});
                              },
                              child: Container(
                                width: double.infinity,
                                height: 28,
                                child: const Center(
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
              return Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 34.0, top: 54),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios),
                            onPressed: () async {
                              // await context.read<ProfileProvider>().setLogin();
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 36,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${myName}",
                          style: const TextStyle(
                              fontFamily: 'Suit',
                              color: kSecondaryTextColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 12),
                        ),
                        const Text(
                          "님이 알 수도 있는 친구들이에요.",
                          style: TextStyle(
                              fontFamily: 'Suit',
                              color: kSecondaryTextColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    const Text(
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
                    )
                  ],
                ),
              );
            } else if (snapshot.data == false) {
              return Container(
                color: Colors.white,
                child: const Center(
                  child: Text(
                    "친구를 받아오려면 카카오톡과 연결해야해요",
                    style: TextStyle(
                        fontFamily: 'Suit',
                        color: kSecondaryTextColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 12),
                  ),
                ),
              );
            } else {
              return Container(
                color: Colors.white,
              );
            }
          }),
    );
  }
}
