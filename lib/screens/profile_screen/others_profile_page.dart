import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hangeureut/constants.dart';
import 'package:hangeureut/models/custom_error.dart';
import 'package:hangeureut/providers/profile/profile_provider.dart';
import 'package:hangeureut/screens/profile_screen/others_profile_view.dart';
import 'package:hangeureut/screens/profile_screen/profile_reviews_view.dart';
import 'package:hangeureut/widgets/error_dialog.dart';
import 'package:hangeureut/widgets/loading_widget.dart';
import 'package:provider/provider.dart';

import '../../models/review_model.dart';
import '../../models/user_model.dart';
import '../../providers/profile/profile_state.dart';
import '../../repositories/restaurant_repository.dart';

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
  User? profile;
  List? otherReviews;
  int reviewNum = 3;
  int savedNum = 3;

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

  void _getReviews() async {
    try {
      otherReviews = await context
          .read<RestaurantRepository>()
          .getUsersReviews(userId: widget.userId);
      otherReviews = otherReviews!.toList();
      setState(() {});
    } on CustomError catch (e) {
      errorDialog(context, e);
    }
  }

  ScrollController controller = ScrollController();
  void _scrollListener() {
    if (controller.position.extentAfter < 500) {
      setState(() {
        if (option) {
          savedNum = savedNum + 3;
        } else {
          reviewNum = reviewNum + 3;
        }
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getReviews();
    });
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    controller = ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User curUser = context.watch<ProfileState>().user;

    return FutureBuilder(
        future: _getProfile(widget.userId),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.hasData) {
            final followings = profile == null ? [] : profile!.followings;
            final followers = profile == null ? [] : profile!.followers;

            List curFollowings = curUser.followings;
            List curFollowers = curUser.followers;
            List followingsId = [];
            for (var friend in curFollowings) {
              followingsId.add(friend["id"]);
            }
            List followersId = [];
            for (var friend in curFollowers) {
              followersId.add(friend["id"]);
            }

            //상대가 나를 팔로우 하는지
            bool followed = followersId.contains(widget.userId);
            //내가 상대를 팔로우 하는지
            bool following = followingsId.contains(widget.userId);
            return Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: Colors.white,
                body: ListView(
                  padding: EdgeInsets.zero,
                  controller: controller,
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: 200,
                          color: kBasicColor,
                        ),
                        const SizedBox(
                          height: 320,
                        ),
                        Positioned(
                            top: 54,
                            left: 34,
                            child: IconButton(
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            )),
                        Positioned(
                            top: 80,
                            left: 0,
                            right: 0,
                            child: ScoreBar(
                              followingCnt: followings.length,
                              followerCnt: followers.length,
                            )),
                        Positioned(
                            top: 111,
                            left: 40,
                            right: 40,
                            child: Container(
                              child: ProfileCard(
                                icon: profile != null ? profile!.icon : 0,
                                name: profile != null ? profile!.name : "",
                                id: profile != null ? profile!.id : "",
                                cId: profile != null ? profile!.cId : "",
                                followed: followed,
                                following: following,
                              ),
                            ))
                      ],
                    ),
                    const SizedBox(
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
                    const SizedBox(
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
                                          : const BorderSide(
                                              color: kSecondaryTextColor,
                                              width: 1))),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "남긴 기록 ",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: option
                                                ? FontWeight.w400
                                                : FontWeight.w700,
                                            color: kSecondaryTextColor
                                                .withOpacity(option ? 0.5 : 1)),
                                      ),
                                      Text(
                                        '${otherReviews == null ? 0 : otherReviews!.length}',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: kBasicColor
                                                .withOpacity(option ? 0.7 : 1)),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 26),
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
                                          ? const BorderSide(
                                              color: kSecondaryTextColor,
                                              width: 1)
                                          : BorderSide.none)),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "저장한 곳 ",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: option
                                                ? FontWeight.w700
                                                : FontWeight.w400,
                                            color: kSecondaryTextColor
                                                .withOpacity(option ? 1 : 0.5)),
                                      ),
                                      Text(
                                        '${profile!.saved.length}',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: kBasicColor
                                                .withOpacity(option ? 1 : 0.7)),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 19.5, bottom: 80),
                      child: option
                          ? ProfileReviewsView(
                              saved: profile!.saved,
                              count: profile!.saved.length,
                              showingLength: savedNum,
                              forSaved: true)
                          : ProfileReviewsView(
                              reviews: otherReviews == null
                                  ? []
                                  : otherReviews!
                                      .map((e) => Review.fromDoc(e))
                                      .toList(),
                              count: otherReviews == null
                                  ? 0
                                  : otherReviews!.length,
                              forSaved: false,
                              showingLength: reviewNum,
                              others: true,
                            ),
                    ),
                  ],
                ));
          } else {
            return const Scaffold(
              body: Center(
                child: LoadingWidget(),
              ),
            );
          }
        });
  }
}
