import 'package:flutter/material.dart';
import 'package:hangeureut/constants.dart';
import 'package:hangeureut/providers/profile/profile_provider.dart';
import 'package:hangeureut/repositories/restaurant_repository.dart';
import 'package:hangeureut/screens/profile_screen/profile_view.dart';
import 'package:hangeureut/screens/profile_screen/review_detail_page.dart';
import 'package:hangeureut/screens/restaurant_detail_screen/restaurant_detail_page.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../providers/profile/profile_state.dart';
import 'modify_loction.dart';

final countStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontFamily: 'Suit',
    color: kBasicColor);

final countStyle2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w300,
    fontFamily: 'Suit',
    color: kBasicColor.withOpacity(0.7));

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
  List? myReviews;
  bool friendSearching = false;
  bool keyBoardShowing = false;

  void _getReviews() async {
    myReviews = await context
        .read<RestaurantRepository>()
        .getUsersReviews(userId: context.read<ProfileState>().user.id);
    setState(() {});
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getReviews();
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final following = context.watch<ProfileState>().user.followings;
    final follower = context.watch<ProfileState>().user.followers;
    final saved = context.watch<ProfileState>().user.saved;
    return GestureDetector(
      onTap: () {
        setState(() {
          friendSearching = false;
        });
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          body: ListView(
              physics: ClampingScrollPhysics(),
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
                              option = false;
                            });
                          },
                          child: ScoreBar(
                            tapped: watchFollow,
                            followingCnt: following.length,
                            followerCnt: follower.length,
                          ),
                        )),
                    Positioned(
                      top: 111,
                      left: 40,
                      right: 40,
                      child: Container(
                          child: ProfileCard(
                              onNameClicked: () {
                                // setState(() {
                                //   nameModify = !nameModify;
                                //   idModify = false;
                                // });
                              },
                              onIdClicked: () {
                                setState(() {
                                  idModify = !idModify;
                                  nameModify = false;
                                });
                              },
                              onModifyClicked: () {
                                setState(() {
                                  modifyClicked = !modifyClicked;
                                  modifyingField = ModifyingField.none;
                                  idModify = false;
                                  nameModify = false;
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
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          setState(() {
                            option = false;
                            friendSearching = false;
                          });
                        },
                        child: Container(
                          width: 152,
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: !option && !friendSearching
                                      ? BorderSide(
                                          color: kSecondaryTextColor, width: 1)
                                      : BorderSide.none)),
                          child: Column(
                            children: [
                              watchFollow
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "나를 찜한 ",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight:
                                                  !option && !friendSearching
                                                      ? FontWeight.w700
                                                      : FontWeight.w400,
                                              color: kSecondaryTextColor
                                                  .withOpacity(!option &&
                                                          !friendSearching
                                                      ? 1
                                                      : 0.5)),
                                        ),
                                        Text(
                                          "${follower.length}",
                                          style: !option && !friendSearching
                                              ? countStyle
                                              : countStyle2,
                                        )
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "남긴 기록 ",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: option
                                                  ? FontWeight.w400
                                                  : FontWeight.w700,
                                              color: kSecondaryTextColor
                                                  .withOpacity(
                                                      option ? 0.5 : 1)),
                                        ),
                                        Text(
                                          '${myReviews == null ? 0 : myReviews!.length}',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: kBasicColor.withOpacity(
                                                  option ? 0.7 : 1)),
                                        )
                                      ],
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
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          setState(() {
                            option = true;
                            friendSearching = false;
                          });
                        },
                        child: Container(
                          width: 152,
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: option && !friendSearching
                                      ? BorderSide(
                                          color: kSecondaryTextColor, width: 1)
                                      : BorderSide.none)),
                          child: Column(
                            children: [
                              watchFollow
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "내가 찜한 ",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight:
                                                  option && !friendSearching
                                                      ? FontWeight.w700
                                                      : FontWeight.w400,
                                              color: kSecondaryTextColor
                                                  .withOpacity(
                                                      option && !friendSearching
                                                          ? 1
                                                          : 0.5)),
                                        ),
                                        Text(
                                          "${following.length}",
                                          style: option && !friendSearching
                                              ? countStyle
                                              : countStyle2,
                                        )
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "저장한 곳 ",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: option
                                                  ? FontWeight.w700
                                                  : FontWeight.w400,
                                              color: kSecondaryTextColor
                                                  .withOpacity(
                                                      option ? 1 : 0.5)),
                                        ),
                                        Text(
                                          '${saved.length}',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: kBasicColor.withOpacity(
                                                  option ? 1 : 0.7)),
                                        )
                                      ],
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
                watchFollow
                    ? SizedBox.shrink()
                    : Padding(
                        padding: const EdgeInsets.only(top: 19.5, bottom: 80),
                        child: option
                            ? ProfileReviewsView(
                                reviews: saved,
                                count: saved.length,
                                forSaved: true)
                            : ProfileReviewsView(
                                reviews: myReviews ?? [],
                                count:
                                    myReviews == null ? 0 : myReviews!.length,
                                forSaved: false,
                              ),
                      ),
                watchFollow
                    ? FriendModal(
                        option: option,
                        friendSearching: friendSearching,
                        searchedTap: (hasFocus) {
                          if (hasFocus) {
                            setState(() {
                              keyBoardShowing = true;
                              friendSearching = true;
                            });
                          }
                        })
                    : SizedBox.shrink()
              ])),
    );
  }
}
