import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hangeureut/constants.dart';
import 'package:hangeureut/providers/profile/profile_provider.dart';
import 'package:hangeureut/screens/profile_screen/review_detail_page.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../models/review_model.dart';
import '../../widgets/profile_icon_box.dart';
import '../restaurant_detail_screen/restaurant_detail_page.dart';

enum ModifyingField { none, favorite, hate, alcohol, spicy }

class ProfileCard extends StatefulWidget {
  ProfileCard(
      {Key? key,
      required this.icon,
      required this.name,
      required this.id,
      required this.cId,
      required this.followed,
      required this.following})
      : super(key: key);

  int icon;
  String name;
  String id;
  String cId;
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
                color: const Color(0xff000000).withOpacity(0.08),
                blurRadius: 6,
                spreadRadius: 0,
                offset: const Offset(
                  0,
                  4,
                )),
          ]),
      height: 203,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 24,
          ),
          ProfileIconBox(content: profileIcons[widget.icon]),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.name,
                style: const TextStyle(
                    color: kBasicColor,
                    fontFamily: 'Suit',
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
              ),
              const Text(
                "의 식탁",
                style: TextStyle(
                    color: kSecondaryTextColor,
                    fontFamily: 'Suit',
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(
            height: 3,
          ),
          Text("@${widget.cId}",
              style: const TextStyle(
                  color: kBasicTextColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Suit')),
          const SizedBox(
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
                          color: const Color(0xffe5e5e5),
                          borderRadius: BorderRadius.circular(6)),
                      child: const Center(
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
                    const SizedBox(
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
                            color: const Color(0xffe5e5e5).withOpacity(0.5),
                            borderRadius: BorderRadius.circular(6)),
                        child: const Center(
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
                    await context.read<ProfileProvider>().setFriends(
                        widget.id, widget.name, widget.icon, widget.cId);
                  },
                  child: Container(
                    width: 220,
                    height: 28,
                    decoration: BoxDecoration(
                        color: const Color(0xffe5e5e5),
                        borderRadius: BorderRadius.circular(6)),
                    child: Center(
                      child: Text(
                        widget.followed ? "나도 찜하기" : "찜하기",
                        style: const TextStyle(
                            color: Colors.black,
                            fontFamily: 'Suit',
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ),
          const SizedBox(
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
          style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Suit',
              fontSize: 13,
              fontWeight: FontWeight.w500),
        ),
        Text(
          "   내가 찜한 ${followingCnt}",
          style: const TextStyle(
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
              for (var keyword in keyWordList2)
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
              padding: const EdgeInsets.all(4),
              child: Container(
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: kBasicColor.withOpacity(0.3),
                        blurRadius: 6,
                        spreadRadius: 0,
                        offset: const Offset(
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
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        text,
                        style: const TextStyle(
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
        : const SizedBox.shrink();
  }
}

// class ProfileReviewsView extends StatelessWidget {
//   const ProfileReviewsView(
//       {Key? key,
//       required this.reviews,
//       required this.count,
//       required this.forSaved})
//       : super(key: key);
//
//   final List reviews;
//   final int count;
//   final bool forSaved;
//
//   // 1. 기록을 세개씩 묶어서 리스트로 저장, 나머지는 처음에 넣어야 함
//   // 2. 각 리스트를 돌면서 한개, 두개, 세개에 따라 다른 레이아웃을 적용시킴
//
//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double sideLength2 = screenWidth / 2 - 4;
//     double sideLength31 = (screenWidth - 16) / 3;
//     double sideLength32 = 2 * sideLength31 + 8;
//     int changePoint = count % 3;
//     List reviewsCollection = [];
//     List imsiList = [];
//     List<Widget> reviewsRows = [];
//
//     reviews.asMap().forEach((index, review) {
//       imsiList.add([review["imgUrl"], review["resId"]]);
//       if ((index % 3 + 1) % 3 == changePoint) {
//         if (imsiList.isNotEmpty) reviewsCollection.add(imsiList);
//         imsiList = [];
//       }
//     });
//
//     bool direction = true;
//
//     reviewsCollection.asMap().forEach((index, _reviews) {
//       if (_reviews.length == 3) {
//         reviewsRows.add(Padding(
//           padding: const EdgeInsets.only(bottom: 8.0),
//           child:
//               row3(sideLength31, sideLength32, direction, _reviews, forSaved),
//         ));
//         direction = !direction;
//       } else if (_reviews.length == 1) {
//         reviewsRows.add(Padding(
//             padding: const EdgeInsets.only(bottom: 8.0),
//             child: row1(screenWidth, _reviews, forSaved)));
//       } else if (_reviews.length == 2) {
//         reviewsRows.add(Padding(
//           padding: const EdgeInsets.only(bottom: 8.0),
//           child: row2(sideLength2, _reviews, forSaved),
//         ));
//       }
//     });
//
//     return GestureDetector(
//       onTap: () {
//         pushNewScreen(context,
//             screen: ReviewDetailPage(
//               reviews: reviews.map((e) => Review.fromDoc(e)).toList(),
//               others: true,
//             ),
//             withNavBar: false);
//       },
//       child: Column(
//         children: reviewsRows,
//       ),
//     );
//   }
//
//   Widget row3(sideLength31, sideLength32, direction, reviews, forSaved) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: direction
//           ? [
//               forSaved
//                   ? SavedTile(
//                       sideLength32, sideLength32, reviews[0][1], reviews[0][0])
//                   : reviewTile(sideLength32, sideLength32, reviews[0][0]),
//               SizedBox(
//                 height: sideLength32,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     forSaved
//                         ? SavedTile(sideLength31, sideLength31, reviews[1][1],
//                             reviews[1][0])
//                         : reviewTile(sideLength31, sideLength31, reviews[1][0]),
//                     forSaved
//                         ? SavedTile(sideLength31, sideLength31, reviews[2][1],
//                             reviews[2][0])
//                         : reviewTile(sideLength31, sideLength31, reviews[2][0])
//                   ],
//                 ),
//               )
//             ]
//           : [
//               SizedBox(
//                 height: sideLength32,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     forSaved
//                         ? SavedTile(sideLength31, sideLength31, reviews[0][1],
//                             reviews[0][0])
//                         : reviewTile(sideLength31, sideLength31, reviews[0][0]),
//                     forSaved
//                         ? SavedTile(sideLength31, sideLength31, reviews[1][1],
//                             reviews[1][0])
//                         : reviewTile(sideLength31, sideLength31, reviews[1][0])
//                   ],
//                 ),
//               ),
//               forSaved
//                   ? SavedTile(
//                       sideLength32, sideLength32, reviews[2][1], reviews[2][0])
//                   : reviewTile(sideLength32, sideLength32, reviews[2][0])
//             ],
//     );
//   }
//
//   Widget row1(screenWidth, reviews, forSaved) {
//     return forSaved
//         ? SavedTile(screenWidth, screenWidth, reviews[0][1], reviews[0][0])
//         : reviewTile(screenWidth, screenWidth, reviews[0][0]);
//   }
//
//   Widget row2(sideLength2, reviews, forSaved) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         forSaved
//             ? SavedTile(sideLength2, sideLength2, reviews[0][1], reviews[0][0])
//             : reviewTile(sideLength2, sideLength2, reviews[0][0]),
//         forSaved
//             ? SavedTile(sideLength2, sideLength2, reviews[1][1], reviews[1][0])
//             : reviewTile(sideLength2, sideLength2, reviews[1][0]),
//       ],
//     );
//   }
//
//   Widget reviewTile(width, height, imgUrl) {
//     return Container(
//       width: width,
//       height: height,
//       child: Image.network(
//         imgUrl,
//         fit: BoxFit.fill,
//       ),
//     );
//   }
// }
//
// class SavedTile extends StatelessWidget {
//   SavedTile(this.width, this.height, this.resId, this.imgUrl);
//
//   final double width;
//   final double height;
//   final String resId;
//   final String imgUrl;
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//         onTap: () async {
//           pushNewScreen(context,
//               screen: RestaurantDetailPage(resId: resId, option: false));
//         },
//         child: Stack(
//           children: [
//             Container(
//               width: width,
//               height: height,
//               child: Image.network(
//                 imgUrl,
//                 fit: BoxFit.fill,
//               ),
//             ),
//             Positioned(
//               top: 13,
//               right: 13,
//               child: Image.asset(
//                 "images/icons/bookmark_fill.png",
//                 color: Colors.white,
//                 width: 17,
//               ),
//             )
//           ],
//         ));
//   }
// }
