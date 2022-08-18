import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hangeureut/constants.dart';
import 'package:hangeureut/models/custom_error.dart';
import 'package:hangeureut/providers/profile/profile_provider.dart';
import 'package:hangeureut/screens/location_select_screen/location_select_page.dart';
import 'package:hangeureut/screens/profile_screen/others_profile_view.dart';
import 'package:hangeureut/widgets/error_dialog.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';
import '../../providers/profile/profile_state.dart';

class OthersProfilePage extends StatefulWidget {
  const OthersProfilePage({Key? key, required this.userId}) : super(key: key);
  static const String routeName = '/others_profile';

  final userId;

  @override
  State<OthersProfilePage> createState() => _OthersProfilePageState();
}

class _OthersProfilePageState extends State<OthersProfilePage> {
  //option이 false면 남긴기록, true 면 저장한 곳
  bool option = false;
  bool watchFollow = false;
  User? profile;

  Future<User?> _getProfile(userId) async {
    try {
      final userProfile = await context
          .read<ProfileProvider>()
          .getOthersProfile(uid: widget.userId);
      profile = userProfile;
      return userProfile;
    } on CustomError catch (e) {
      errorDialog(context, e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getProfile(widget.userId),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          final following = context.watch<ProfileState>().user.friends;
          final follower = [];
          return Scaffold(
              backgroundColor: Colors.white,
              body: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 200,
                        color: kBasicColor,
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
                                  watchFollow = true;
                                });
                              },
                              child: ScoreBar(
                                tapped: watchFollow,
                                followingCnt: following.length,
                                followerCnt: 0,
                              ))),
                      Positioned(
                          top: 111,
                          left: 40,
                          right: 40,
                          child: Container(
                            child: ProfileCard(
                              icon: profile != null ? profile!.icon : 0,
                              name: profile != null ? profile!.name : "",
                              id: profile != null ? profile!.id : "",
                              followed: false,
                              following: false,
                            ),
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 26,
                  ),
                  TasteProfile(
                    tasteKeyword: profile != null
                        ? profile!.onboarding["tasteKeyword"]
                        : [],
                    alcoholType: profile != null
                        ? profile!.onboarding["alcoholType"]
                        : [],
                  ),
                  SizedBox(
                    height: 49,
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
                                            color: kSecondaryTextColor,
                                            width: 1))),
                            child: Column(
                              children: [
                                Text(
                                  "남긴 기록",
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
                                            color: kSecondaryTextColor,
                                            width: 1)
                                        : BorderSide.none)),
                            child: Column(
                              children: [
                                Text(
                                  "저장한 곳",
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
                ],
              ));
        });
  }
}
