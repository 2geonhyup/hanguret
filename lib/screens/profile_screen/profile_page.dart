import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hangeureut/constants.dart';
import 'package:hangeureut/providers/profile/profile_provider.dart';
import 'package:hangeureut/screens/location_select_screen/location_select_page.dart';
import 'package:hangeureut/screens/profile_screen/profile_view.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../providers/profile/profile_state.dart';
import '../../widgets/profile_icon_box.dart';
import 'modify_loction.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);
  static const String routeName = '/profile';

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool nameModify = false;
  bool idModify = false;
  bool modifyClicked = false;
  ModifyingField modifyingField = ModifyingField.none;
  //option이 false면 남긴기록, true 면 저장한 곳
  bool option = false;
  bool watchFollow = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
  }

  @override
  Widget build(BuildContext context) {
    final following = context.watch<ProfileState>().user.friends;
    final follower = [];
    return GestureDetector(
      onTap: () {
        setState(() {
          watchFollow = false;
        });
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          body: ListView(
            padding: EdgeInsets.zero,
            children: [
              Stack(
                children: [
                  Container(
                    height: 200,
                    color: watchFollow ? Color(0xff808761) : kBasicColor,
                  ),
                  SizedBox(
                    height: 320,
                  ),
                  Positioned(
                      top: 80,
                      left: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            watchFollow = !watchFollow;
                          });
                        },
                        child: ScoreBar(
                          tapped: watchFollow,
                          followingCnt: following.length,
                          followerCnt: 0,
                        ),
                      )),
                  Positioned(
                    top: 111,
                    left: 40,
                    right: 40,
                    child: Container(
                        child: ProfileCard(
                            onNameClicked: () {
                              print(nameModify);
                              setState(() {
                                nameModify = !nameModify;
                              });
                            },
                            onIdClicked: () {
                              setState(() {
                                idModify = !idModify;
                              });
                            },
                            onModifyClicked: () {
                              setState(() {
                                modifyClicked = !modifyClicked;
                                modifyingField = ModifyingField.none;
                              });
                            },
                            watchFollow: watchFollow,
                            nameModify: nameModify,
                            idModify: idModify,
                            modifyClicked: modifyClicked)),
                  )
                ],
              ),
              SizedBox(
                height: 26,
              ),
              modifyClicked
                  ? Center(
                      child: GestureDetector(
                      onTap: () {
                        pushNewScreen(
                          context,
                          screen: ModifyLocation(),
                          withNavBar: false,
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "images/icons/onboarding_icon/gps_fixed_fill.png",
                            width: 19,
                            height: 19,
                          ),
                          Text(
                            " 관심 지역 ",
                            style: TextStyle(
                                fontFamily: 'Suit',
                                color: kSecondaryTextColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 12),
                          ),
                          Text(
                            "수정하기",
                            style: TextStyle(
                                fontFamily: 'Suit',
                                color: kSecondaryTextColor,
                                fontWeight: FontWeight.w300,
                                fontSize: 12),
                          ),
                        ],
                      ),
                    ))
                  : SizedBox.shrink(),
              modifyClicked ? SizedBox(height: 23) : SizedBox.shrink(),
              watchFollow
                  ? SizedBox.shrink()
                  : TasteProfile(
                      modifyClicked: modifyClicked,
                      modifyingField: modifyingField,
                      onModifyingFieldChange: (val) {
                        setState(() {
                          modifyingField = val;
                        });
                      },
                      alcoholAdd: () {
                        setState(() {
                          modifyingField = ModifyingField.alcohol;
                        });
                      },
                    ),
              SizedBox(
                height: watchFollow ? 17 : 49,
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: kBorderGreenColor.withOpacity(0.5),
                            width: 0.5))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          option = false;
                        });
                      },
                      child: Container(
                        width: 152,
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: option
                                    ? BorderSide.none
                                    : BorderSide(
                                        color: kSecondaryTextColor, width: 1))),
                        child: Column(
                          children: [
                            Text(
                              watchFollow ? "나를 찜한" : "남긴 기록",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: option
                                      ? FontWeight.w400
                                      : FontWeight.w700,
                                  color: kSecondaryTextColor
                                      .withOpacity(option ? 0.5 : 1)),
                            ),
                            SizedBox(
                              height: 8,
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 26),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          option = true;
                        });
                      },
                      child: Container(
                        width: 152,
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: option
                                    ? BorderSide(
                                        color: kSecondaryTextColor, width: 1)
                                    : BorderSide.none)),
                        child: Column(
                          children: [
                            Text(
                              watchFollow ? "내가 찜한" : "저장한 곳",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: option
                                      ? FontWeight.w700
                                      : FontWeight.w400,
                                  color: kSecondaryTextColor
                                      .withOpacity(option ? 1 : 0.5)),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              watchFollow ? FriendModal(option: option) : SizedBox.shrink()
            ],
          )),
    );
  }
}
