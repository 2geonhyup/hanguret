import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hangeureut/constants.dart';
import 'package:hangeureut/providers/profile/profile_provider.dart';
import 'package:provider/provider.dart';

import '../../widgets/profile_icon_box.dart';

enum ModifyingField { none, favorite, hate, alcohol, spicy }

class ProfileCard extends StatefulWidget {
  ProfileCard(
      {Key? key,
      required this.icon,
      required this.name,
      required this.id,
      required this.followed,
      required this.following})
      : super(key: key);

  int icon;
  String name;
  String id;
  //내가 이 사람에게 찜을 당했는지
  bool followed;
  //내가 이 사람을 찜 하는지
  bool following;

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  @override
  Widget build(BuildContext context) {
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
          ProfileIconBox(content: profileIcons[widget.icon]),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.name,
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
          SizedBox(
            height: 3,
          ),
          Text("@${widget.id}",
              style: TextStyle(
                  color: kBasicTextColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Suit')),
          SizedBox(
            height: 20,
          ),
          widget.following
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 105,
                      height: 28,
                      decoration: BoxDecoration(
                          color: Color(0xffe5e5e5),
                          borderRadius: BorderRadius.circular(6)),
                      child: Center(
                        child: Text(
                          "구독 중",
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Suit',
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () async {
                        await context
                            .read<ProfileProvider>()
                            .removeFriends(widget.id, widget.name, widget.icon);
                      },
                      child: Container(
                        width: 105,
                        height: 28,
                        decoration: BoxDecoration(
                            color: Color(0xffe5e5e5).withOpacity(0.5),
                            borderRadius: BorderRadius.circular(6)),
                        child: Center(
                          child: Text(
                            "구독 끊기",
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
                )
              : GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () async {
                    await context
                        .read<ProfileProvider>()
                        .setFriends(widget.id, widget.name, widget.icon);
                  },
                  child: Container(
                    width: 220,
                    height: 28,
                    decoration: BoxDecoration(
                        color: Color(0xffe5e5e5),
                        borderRadius: BorderRadius.circular(6)),
                    child: Center(
                      child: Text(
                        widget.followed ? "나도 찜하기" : "찜하기",
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
            height: 24,
          ),
        ],
      ),
    );
  }
}

class ScoreBar extends StatelessWidget {
  ScoreBar({Key? key, required this.followerCnt, required this.followingCnt})
      : super(key: key);
  int followerCnt;
  int followingCnt;
//TODO: 진짜 데이터로 바꿔야 함!!!!!!!!!
  @override
  Widget build(BuildContext context) {
    return Row(
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
  const TasteProfile(
      {Key? key, required this.tasteKeyword, required this.alcoholType})
      : super(key: key);

  final Map tasteKeyword;
  final Map alcoholType;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 44,
          child: Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: ListView(scrollDirection: Axis.horizontal, children: [
              for (var keyword in keyWordList)
                RoundedButton(
                  iconPath: "${tasteProfileIconPath}/${keyword[0]}.png",
                  text: keyword[1],
                  selected: tasteKeyword[keyword[0]] ?? false,
                ),
              for (var alcohol in alcoholTypeList2)
                RoundedButton(
                  iconPath: "${tasteProfileIconPath}/${alcohol[0]}.png",
                  text: alcohol[1],
                  selected: alcoholType[alcohol[0]] ?? false,
                )
            ]),
          ),
        ),
      ],
    );
  }
}

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    Key? key,
    required this.iconPath,
    required this.text,
    required this.selected,
  }) : super(key: key);
  final iconPath;
  final text;
  final selected;
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
                ),
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
