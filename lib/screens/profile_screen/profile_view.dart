import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hangeureut/constants.dart';
import 'package:hangeureut/providers/profile/profile_provider.dart';
import 'package:hangeureut/screens/profile_screen/modify_taste.dart';
import 'package:hangeureut/screens/profile_screen/profile_view.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../providers/friend/recommend_friend_state.dart';
import '../../providers/profile/profile_state.dart';
import '../../widgets/profile_icon_box.dart';
import '../friend_screen/friend_recommend_page.dart';
import 'others_profile_page.dart';

enum ModifyingField { none, favorite, hate, alcohol, spicy }

class ProfileCard extends StatelessWidget {
  ProfileCard(
      {Key? key,
      required this.onNameClicked,
      required this.onIdClicked,
      required this.onModifyClicked,
      required this.nameModify,
      required this.idModify,
      required this.modifyClicked,
      required this.watchFollow})
      : super(key: key);
  Function onNameClicked;
  Function onIdClicked;
  Function onModifyClicked;
  bool nameModify;
  bool idModify;
  bool modifyClicked;
  bool watchFollow;

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileState>().user;
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
                color: Color(0xff000000).withOpacity(0.08),
                blurRadius: 6,
                spreadRadius: 0,
                offset: Offset(
                  0,
                  4,
                )),
          ]),
      height: 203,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 24,
          ),
          ProfileIconBox(content: profileIcons[profile.icon]),
          SizedBox(
            height: 10,
          ),
          nameModify
              ? TextFormField(
                  onFieldSubmitted: (val) {
                    onNameClicked();
                    context.read<ProfileProvider>().setName(name: val);
                  },
                  textAlign: TextAlign.center,
                  initialValue: profile.name,
                  showCursor: true,
                  autofocus: true,
                  cursorColor: kSecondaryTextColor.withOpacity(0.7),
                  cursorWidth: 0.5,
                  style: TextStyle(
                      color: kSecondaryTextColor.withOpacity(0.7),
                      fontFamily: 'Suit',
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                  decoration: InputDecoration.collapsed(hintText: "이름 입력"),
                )
              : GestureDetector(
                  onTap: () {
                    onNameClicked();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        profile.name,
                        style: TextStyle(
                            color: kBasicColor,
                            fontFamily: 'Suit',
                            fontSize: 20,
                            fontWeight: FontWeight.w700),
                      ),
                      Text(
                        "의 식탁",
                        style: TextStyle(
                            color: kSecondaryTextColor,
                            fontFamily: 'Suit',
                            fontSize: 20,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
          SizedBox(
            height: 3,
          ),
          Text("@${profile.id}",
              style: TextStyle(
                  color: kBasicTextColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Suit')),
          SizedBox(
            height: 20,
          ),
          modifyClicked
              ? Center(
                  child: GestureDetector(
                    onTap: () {
                      onModifyClicked();
                    },
                    child: Container(
                      width: 220,
                      height: 28,
                      decoration: BoxDecoration(
                          color: Color(0xffE5E5E5),
                          borderRadius: BorderRadius.circular(6)),
                      child: Center(
                        child: Text(
                          "수정 완료",
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Suit',
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    watchFollow
                        ? GestureDetector(
                            onTap: () {
                              pushNewScreen(
                                context,
                                screen: FriendRecommendPage(),
                                withNavBar: false,
                              );
                            },
                            child: Container(
                              width: 154,
                              height: 28,
                              decoration: BoxDecoration(
                                  color: kBasicColor.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(6)),
                              child: Center(
                                child: Text(
                                  "찜하기 추천",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Suit',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              onModifyClicked();
                            },
                            child: Container(
                              width: 154,
                              height: 28,
                              decoration: BoxDecoration(
                                  color: Color(0xffe5e5e5),
                                  borderRadius: BorderRadius.circular(6)),
                              child: Center(
                                child: Text(
                                  "프로필 수정",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Suit',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                          ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 55,
                        height: 28,
                        decoration: BoxDecoration(
                            color: Color(0xfff2f2f2),
                            borderRadius: BorderRadius.circular(6)),
                        child: Center(
                          child: Text(
                            "공유",
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Suit',
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
          SizedBox(
            height: 24,
          ),
        ],
      ),
    );
  }
}

class ScoreBar extends StatelessWidget {
  ScoreBar(
      {Key? key,
      required this.tapped,
      required this.followerCnt,
      required this.followingCnt})
      : super(key: key);
  bool tapped;
  int followerCnt;
  int followingCnt;
//TODO: 진짜 데이터로 바꿔야 함!!!!!!!!!
  @override
  Widget build(BuildContext context) {
    return tapped
        ? Center(
            child: Text(
              "돌아가기",
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Suit',
                  fontSize: 13,
                  fontWeight: FontWeight.w500),
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "나를 찜한 ${followerCnt}   |",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Suit',
                    fontSize: 13,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                "   내가 찜한 ${followingCnt}",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Suit',
                    fontSize: 13,
                    fontWeight: FontWeight.w500),
              )
            ],
          );
  }
}

class TasteProfile extends StatelessWidget {
  const TasteProfile({
    Key? key,
    required this.modifyClicked,
    required this.modifyingField,
    required this.onModifyingFieldChange,
    required this.alcoholAdd,
  }) : super(key: key);

  final bool modifyClicked;
  final ModifyingField modifyingField;
  final Function onModifyingFieldChange;
  final Function alcoholAdd;

  @override
  Widget build(BuildContext context) {
    final onboarding = context.watch<ProfileState>().user.onboarding;
    final tasteKeyword = onboarding["tasteKeyword"];
    final alcoholType = onboarding["alcoholType"];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 44,
          child: Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: ListView(scrollDirection: Axis.horizontal, children: [
              modifyClicked
                  ? GestureDetector(
                      onTap: () {
                        pushNewScreen(
                          context,
                          screen: ModifyTaste(),
                          withNavBar: false,
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.all(4),
                        child: Container(
                          width: 48,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: kBasicColor.withOpacity(0.3),
                                  blurRadius: 6,
                                  spreadRadius: 0,
                                  offset: Offset(
                                    0,
                                    1,
                                  )),
                            ],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: kSecondaryTextColor.withOpacity(0.2)),
                          ),
                          child: Center(
                              child: Text(
                            "+",
                            style: TextStyle(
                                fontFamily: 'Suit',
                                fontWeight: FontWeight.w400,
                                fontSize: 17,
                                color: Color(0xff9e9f92)),
                          )),
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
              for (var keyword in keyWordList)
                RoundedButton(
                    iconPath: "${tasteProfileIconPath}/${keyword[0]}.png",
                    text: keyword[1],
                    selected: tasteKeyword[keyword[0]],
                    modifying: modifyClicked),
              for (var alcohol in alcoholTypeList2)
                RoundedButton(
                    iconPath: "${tasteProfileIconPath}/${alcohol[0]}.png",
                    text: alcohol[1],
                    selected: alcoholType[alcohol[0]],
                    modifying: modifyClicked)
            ]),
          ),
        ),
      ],
    );
  }
}

class RoundedButton extends StatelessWidget {
  const RoundedButton(
      {Key? key,
      required this.iconPath,
      required this.text,
      required this.selected,
      required this.modifying})
      : super(key: key);
  final iconPath;
  final text;
  final selected;
  final modifying;
  @override
  Widget build(BuildContext context) {
    return selected
        ? GestureDetector(
            child: Padding(
              padding: EdgeInsets.all(4),
              child: Container(
                height: 36,
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: kBasicColor.withOpacity(0.3),
                          blurRadius: 6,
                          spreadRadius: 0,
                          offset: Offset(
                            0,
                            1,
                          )),
                    ],
                    borderRadius: BorderRadius.circular(12),
                    border: modifying
                        ? Border.all(
                            color: kSecondaryTextColor.withOpacity(0.2),
                            width: 0.5)
                        : null),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        iconPath,
                        height: 18,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        text,
                        style: TextStyle(
                            fontFamily: 'Suit',
                            fontWeight: FontWeight.w300,
                            fontSize: 12,
                            color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : SizedBox.shrink();
  }
}

class FriendModal extends StatelessWidget {
  FriendModal({Key? key, required this.option}) : super(key: key);
  bool option;
  @override
  Widget build(BuildContext context) {
    final following = context.watch<ProfileState>().user.followings;
    final follower = [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 29),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(
                  color: kSecondaryTextColor,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(25)),
            child: Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 15),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                          hintText: '친구 이름',
                          hintStyle: TextStyle(
                              fontFamily: 'Suit',
                              fontWeight: FontWeight.w300,
                              fontSize: 14,
                              color: kSecondaryTextColor.withOpacity(0.4)),
                          border: InputBorder.none),
                    ),
                  ),
                  Icon(
                    Icons.search,
                    color: kBasicColor,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        //TODO: 검색창에 focus되어 있다면, 검색 결과가 떠야함(배열 순서: 서로 찜->내가 찜->상대가 찜-> 상관없는 사람)
        for (var user in option ? following : follower)
          Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: FriendRow(
                icon: user["icon"], name: user["name"], id: user["id"]),
          ),
      ],
    );
  }
}

class FriendRow extends StatelessWidget {
  FriendRow(
      {Key? key, required this.icon, required this.name, required this.id})
      : super(key: key);
  int icon;
  String name;
  String id;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        pushNewScreen(context,
            screen: OthersProfilePage(
              userId: id,
            ),
            withNavBar: true);
      },
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              width: 33,
            ),
            FriendIconBox(content: profileIcons[icon]),
            SizedBox(
              width: 12,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                      color: kSecondaryTextColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Suit'),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  "@$id",
                  style: TextStyle(
                      color: kSecondaryTextColor,
                      fontFamily: 'Suit',
                      fontWeight: FontWeight.w400,
                      fontSize: 11),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class FriendIconBox extends StatelessWidget {
  FriendIconBox({Key? key, required this.content}) : super(key: key);
  String content;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: Text(
        content,
        style: TextStyle(fontSize: 27),
      )),
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Color(0xffe5e5e5).withOpacity(0.5),
        borderRadius: BorderRadius.circular(50),
      ),
    );
  }
}
