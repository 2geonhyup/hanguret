import 'package:flutter/material.dart';
import 'package:hangeureut/screens/profile_screen/others_profile_page.dart';
import 'package:hangeureut/screens/restaurant_detail_screen/restaurant_detail_page.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import '../../constants.dart';
import '../../widgets/profile_icon_box.dart';

class NewsInfoBox extends StatelessWidget {
  const NewsInfoBox(
      {Key? key,
      required this.userId,
      required this.icon,
      required this.name,
      required this.date,
      required this.resId,
      required this.resName,
      this.zzim = false})
      : super(key: key);

  final String userId;
  final int icon;
  final String name;
  final String date;
  final String resId;
  final String resName;
  final bool zzim;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 37.0, top: 40),
      child: Row(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              pushNewScreen(context, screen: OthersProfilePage(userId: userId));
            },
            child: ProfileIconBox(
                content: icon == -1 ? profileIcons[0] : profileIcons[icon]),
          ),
          const SizedBox(
            width: 23,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  pushNewScreen(context,
                      screen: OthersProfilePage(userId: userId));
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                          fontFamily: 'Suit',
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                          color: kSecondaryTextColor,
                          height: 1),
                    ),
                    const Text(
                      "의 식탁",
                      style: TextStyle(
                          fontFamily: 'Suit',
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: kSecondaryTextColor,
                          height: 1),
                    ),
                    const SizedBox(
                      width: 7,
                    ),
                    zzim
                        ? GestureDetector(
                            onTap: () {},
                            child: Container(
                              width: 49,
                              height: 21,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.5),
                                  border: Border.all(
                                    color: kSecondaryTextColor,
                                    width: 0.5,
                                  )),
                              child: const Center(
                                  child: Text(
                                "찜하기",
                                style: TextStyle(
                                    height: 1,
                                    fontFamily: 'Suit',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 11,
                                    color: kSecondaryTextColor),
                              )),
                            ),
                          )
                        : const SizedBox.shrink()
                  ],
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Text(
                    "$date  | ",
                    style: const TextStyle(
                        fontFamily: 'Suit',
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: kSecondaryTextColor,
                        height: 1),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      pushNewScreen(context,
                          screen:
                              RestaurantDetailPage(resId: resId, option: true),
                          withNavBar: false);
                    },
                    child: Text(
                      "$resName ",
                      style: const TextStyle(
                          fontFamily: 'Suit',
                          fontWeight: FontWeight.w900,
                          fontSize: 12,
                          color: kBasicColor,
                          height: 1),
                    ),
                  ),
                  Image.asset(
                    "images/icons/search_big_bold.png",
                    width: 14,
                    height: 14,
                    color: kBasicColor,
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
