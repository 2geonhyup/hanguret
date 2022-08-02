import 'package:flutter/material.dart';
import 'package:hangeureut/constants.dart';
import 'package:hangeureut/providers/profile/profile_state.dart';
import 'package:hangeureut/screens/friend_screen/friend_recommend_page.dart';
import 'package:hangeureut/screens/profile_screen/profile_page.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../widgets/profile_icon_box.dart';
import 'friends_view.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({Key? key}) : super(key: key);
  static const String routeName = "/friends";

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  @override
  Widget build(BuildContext context) {
    final myProfile = context.watch<ProfileState>().user;
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(
            height: 71,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 33.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "밥친구들",
                  style: TextStyle(
                      fontFamily: 'Cafe24',
                      fontWeight: FontWeight.w700,
                      fontSize: 30,
                      color: kBasicColor),
                ),
                GestureDetector(
                  onTap: () {
                    pushNewScreen(context,
                        screen: FriendRecommendPage(), withNavBar: true);
                  },
                  child: Image.asset(
                    "images/user_fill_add.png",
                    width: 35,
                    height: 35,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 32,
          ),
          Expanded(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 34.0),
                  child: MyProfileCard(
                      icon: myProfile.icon,
                      name: myProfile.name,
                      id: myProfile.id),
                ),
                SizedBox(
                  height: 33,
                ),
                SizedBox.expand(
                  child: DraggableScrollableSheet(
                    initialChildSize: 0.62,
                    minChildSize: 0.62,
                    maxChildSize: 1,
                    builder: (BuildContext context,
                        ScrollController scrollController) {
                      return Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(48),
                                  topRight: Radius.circular(48)),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 17,
                                    spreadRadius: 0,
                                    offset: Offset(0, -4))
                              ]),
                          child: MediaQuery.removePadding(
                            context: context,
                            removeTop: true,
                            child: ListView(
                              controller: scrollController,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 30.0, right: 30.0, top: 29),
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: kSecondaryTextColor,
                                          width: 0.5,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 24.0, right: 15),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: TextFormField(
                                              decoration: InputDecoration(
                                                  hintText: '친구 이름',
                                                  hintStyle: TextStyle(
                                                      fontFamily: 'Suit',
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      fontSize: 14,
                                                      color: kSecondaryTextColor
                                                          .withOpacity(0.4)),
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
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 31.0, top: 36),
                                  child: Text(
                                    "밥친구 ${myProfile.friends.length}",
                                    style: TextStyle(
                                        color: kBasicTextColor.withOpacity(0.6),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                        fontFamily: 'Suit'),
                                  ),
                                ),
                                SizedBox(
                                  height: 18,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 33,
                                    ),
                                    FriendIconBox(
                                        content: profileIcons[
                                            myProfile.friends[0]["icon"]]),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          myProfile.friends[0]["name"],
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
                                          "@${myProfile.friends[0]["id"]}",
                                          style: TextStyle(
                                              color: kSecondaryTextColor,
                                              fontFamily: 'Suit',
                                              fontWeight: FontWeight.w400,
                                              fontSize: 11),
                                        )
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          ));
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
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
