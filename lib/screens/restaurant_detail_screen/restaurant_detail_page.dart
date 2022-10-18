import 'package:flutter/material.dart';
import 'package:hangeureut/models/custom_error.dart';
import 'package:hangeureut/providers/profile/profile_provider.dart';
import 'package:hangeureut/providers/profile/profile_state.dart';
import 'package:hangeureut/repositories/restaurant_repository.dart';
import 'package:hangeureut/restaurants.dart';
import 'package:hangeureut/widgets/error_dialog.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants.dart';
import '../../widgets/custom_round_rect_slider_thumb_shape.dart';
import '../../widgets/res_title.dart';
import '../../widgets/review_box.dart';
import '../review_screen/review_page.dart';
import 'dart:math' as math;
// 레이아웃 잡은 것 참고

class RestaurantDetailPage extends StatefulWidget {
  RestaurantDetailPage({
    Key? key,
    required this.resId,
    required this.option,
  }) : super(key: key);
  final String resId;
  final bool option; // false: 기록, true: 탐색
  static String routeName = "/restaurant_detail_page";

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  Map? res;
  late bool opt;
  late int score;
  late double scrollScore;
  bool preReview = false;
  Map? myReview;
  List? otherReviews;
  List<Widget> otherReviewWidgets = [];
  List<bool> likes = [];
  bool myLike = false;
  bool detailView = false;
  bool saved = false;
  bool savedSet = false; // save가 이미 한번 세팅되었는지 확인
  List savedList = [];

  Future<void> _launchUrl(url) async {
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }

  Future<void> _getResDetail() async {
    try {
      res = await context
          .read<RestaurantRepository>()
          .getRestaurantsDetail(resId: widget.resId);

      setState(() {});
    } on CustomError catch (e) {
      print(e);
    }
  }

  Future<void> _getReviews() async {
    String myId = context.read<ProfileState>().user.id;
    if (otherReviews == null) {
      try {
        otherReviews = await context
            .read<RestaurantRepository>()
            .getRestaurantsReviews(resId: widget.resId);
        likes = [];
        for (var e in otherReviews!) {
          if (myId == e["userId"]) {
            myReview = e;
          }
          likes.add(e["liked"]);
        }

        myReview != null ? preReview = true : null;
        if (myReview != null) {
          myLike = myReview!["liked"];
        }
      } on CustomError catch (e) {
        print(e);
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getResDetail();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getReviews();
    });

    opt = widget.option;
    score = 5;
    scrollScore = 0;
    // TODO: implement initState
    savedList = context.read<ProfileState>().user.saved;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (res != null && !savedSet) {
      savedSet = true;
      for (var e in savedList) {
        if (res!["id"] == e["resId"]) {
          setState(() {
            saved = true;
          });

          break;
        }
      }
    }
    List items = [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 34.0, top: 54),
            child: GestureDetector(
              onTap: () {
                detailView
                    ? setState(() {
                        detailView = false;
                      })
                    : Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: kBasicTextColor.withOpacity(0.8),
              ),
            ),
          ),
          res == null
              ? SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.only(right: 28.0, top: 40),
                  child: GestureDetector(
                    onTap: () async {
                      setState(() {
                        saved = !saved;
                      });
                      try {
                        await context.read<ProfileProvider>().saveRemoveRes(
                            resId: res!["id"],
                            imgUrl: res!["imgUrl"],
                            isSave: saved);
                      } on CustomError catch (e) {
                        errorDialog(context, e);
                      }
                    },
                    child: Column(
                      children: [
                        Text(
                          "저장",
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Suit',
                              color: kSecondaryTextColor),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Image.asset(
                          saved
                              ? "images/icons/bookmark_fill.png"
                              : "images/icons/bookmark_outline.png",
                          width: 26,
                          height: 26,
                        )
                      ],
                    ),
                  ),
                )
        ],
      ),
      res == null
          ? SizedBox.shrink()
          : Padding(
              padding: const EdgeInsets.only(top: 19.0),
              child: ResTitle(
                  category: res!["category1"],
                  icon: res!["tag1"],
                  name: res!["name"],
                  score: res!["score"],
                  detail: res!["detail"]),
            ),
      SizedBox(
        height: detailView ? 48 : 30,
      ),
      detailView
          ? Divider(
              height: 0.5,
              thickness: 0.5,
              color: kBorderGreenColor.withOpacity(0.5),
            )
          : OptionRow(
              reviewed: preReview,
              onTap: () async {
                setState(() {
                  opt = !opt;
                });
                if (opt) _getReviews();
              },
              option: opt,
            ),
      opt
          ? GestureDetector(
              onTap: () {
                setState(() {
                  if (!detailView) detailView = true;
                });
              },
              child: detailView
                  ? Padding(
                      padding: EdgeInsets.only(top: 44.5),
                      child: reviewsDetailView())
                  : reviewsView())
          : preReview
              ? Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: ReviewBox(
                    resName: res!["name"],
                    userId: null,
                    reviewId: myReview!["reviewId"],
                    date: myReview!["date"],
                    score: myReview!["score"],
                    imgUrl: myReview!["imgUrl"],
                    tag: resFilterTextsSh[myReview!["category"]]
                        [myReview!["icon"]],
                    icon: resFilterIcons[myReview!["category"]]
                        [myReview!["icon"]],
                    onLike: () {
                      setState(() {
                        myLike = !myLike;
                      });
                    },
                    likes: myLike == myReview!["liked"]
                        ? myReview!["likes"]
                        : !myLike && myReview!["liked"]
                            ? myReview!["likes"] - 1
                            : myReview!["likes"] + 1,
                    liked: myLike,
                  ),
                )
              : Padding(
                  padding:
                      const EdgeInsets.only(top: 66.0, left: 38, right: 38),
                  child: ScoringBox(
                      onCompleted: () {
                        pushNewScreen(
                          context,
                          screen: ReviewPage(
                            res: res,
                            score: score,
                          ),
                          withNavBar: false, // OPTIONAL VALUE. True by default.
                        );
                      },
                      score: score,
                      scrollScore: scrollScore,
                      onScrollEnd: (val) {
                        setState(() {
                          scrollScore = val.round().toDouble();
                          score = (5 - val.round()).toInt();
                        });
                      },
                      onScroll: (val) {
                        setState(() {
                          scrollScore = val;
                        });
                      }),
                ),
    ];
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: items.length,
                itemBuilder: (context, int index) {
                  return items[index];
                }),
          ),
          widget.option
              ? Container(
                  height: 83,
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                        offset: Offset(0, -4),
                        blurRadius: 17,
                        color: Colors.black.withOpacity(0.15))
                  ]),
                  child: res == null
                      ? SizedBox.shrink()
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 18.0, left: 28),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "지금 내 위치에서 ",
                                        style: TextStyle(
                                            height: 1.25,
                                            fontSize: 12,
                                            fontFamily: 'Suit',
                                            color: kSecondaryTextColor,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      Text(
                                        res!["distance"] == null
                                            ? "거리 확인 불가"
                                            : "${res!["distance"]}m",
                                        style: TextStyle(
                                            height: 1.25,
                                            fontSize: 12,
                                            fontFamily: 'Suit',
                                            color: kBasicColor,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    res!["address"],
                                    style: TextStyle(
                                        height: 1,
                                        fontSize: 11,
                                        fontFamily: 'Suit',
                                        color: kSecondaryTextColor,
                                        fontWeight: FontWeight.w300),
                                  )
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                final Uri _url = Uri.parse(
                                    'https://map.kakao.com/link/to/${res!["kakaoId"]}');
                                try {
                                  await _launchUrl(_url);
                                } catch (e) {
                                  final ec = CustomError(
                                      code: '', message: '카카오맵을 열 수 없습니다');
                                  errorDialog(context, ec);
                                }
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 18, right: 30),
                                child: Container(
                                    width: 79,
                                    height: 36,
                                    decoration: BoxDecoration(
                                        color: kBasicColor,
                                        borderRadius:
                                            BorderRadius.circular(19)),
                                    child: Center(
                                      child: Text(
                                        "길찾기",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Suit',
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    )),
                              ),
                            )
                          ],
                        ),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget reviewsView() {
    List<Widget> reviewWidgets1 = [];
    List<Widget> reviewWidgets2 = [];

    if (otherReviews != null) {
      otherReviews!.asMap().forEach((key, e) {
        if (key % 2 == 0) {
          reviewWidgets1.add(reviewTile(key, e));
        } else {
          reviewWidgets2.add(reviewTile(key, e));
        }
      });
    }

    return Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            children: reviewWidgets1,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: reviewWidgets2,
          )
        ],
      ),
    );
  }

  Widget reviewTile(key, e) {
    return Padding(
      padding: const EdgeInsets.all(4.5),
      child: GestureDetector(
        onDoubleTap: () async {
          setState(() {
            likes[key] = !likes[key];
          });
          await context.read<ProfileProvider>().reviewLike(
              resName: res!["name"],
              targetId: e["userId"],
              reviewId: e["reviewId"],
              isAdd: likes[key]);
        },
        child: Stack(
          children: [
            Container(
              width: 165,
              height: 165,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(7),
                  child: Image.asset(
                    e["imgUrl"],
                    fit: BoxFit.fill,
                  )),
            ),
            Positioned(
              top: 7,
              right: 8,
              child: Icon(
                likes[key] ? Icons.favorite : Icons.favorite_border_outlined,
                color: Colors.white,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget reviewsDetailView() {
    List<Widget> reviewTileWidgets = [];
    if (otherReviews != null) {
      otherReviews!.asMap().forEach((index, review) {
        reviewTileWidgets.add(Column(
          children: [
            Container(
              child: Center(
                child: Text(
                  review["userName"],
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: kSecondaryTextColor,
                      fontSize: 12,
                      fontFamily: "Suit"),
                ),
              ),
              width: 55,
              height: 29,
              decoration: BoxDecoration(
                  color: Color(0xfff3f3f2),
                  borderRadius: BorderRadius.circular(11)),
            ),
            SizedBox(
              height: 14,
            ),
            ReviewBox(
              resName: res!["name"],
              userId: review["userId"],
              reviewId: review["reviewId"],
              date: review["date"],
              score: review["score"],
              imgUrl: review["imgUrl"],
              icon: resFilterIcons[review["category"]][review["icon"]],
              tag: resFilterTextsSh[review["category"]][review["icon"]],
              onLike: () {
                setState(() {
                  likes[index] = !likes[index];
                });
              },
              likes: likes[index] == review["liked"]
                  ? review["likes"]
                  : !likes[index] && review["liked"]
                      ? review["likes"] - 1
                      : review["likes"] + 1,
              liked: likes[index],
            ),
            SizedBox(
              height: 65,
            )
          ],
        ));
      });
    }
    return Column(
      children: reviewTileWidgets,
    );
  }
}

class OptionRow extends StatelessWidget {
  const OptionRow(
      {Key? key,
      required this.reviewed,
      required this.onTap,
      required this.option})
      : super(key: key);
  final reviewed;
  final onTap;
  final option;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: kBorderGreenColor.withOpacity(0.5), width: 0.5))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: onTap,
            child: Container(
              width: 152,
              decoration: BoxDecoration(
                  border: Border(
                      bottom: option
                          ? BorderSide.none
                          : BorderSide(color: kSecondaryTextColor, width: 1))),
              child: Column(
                children: [
                  Text(
                    reviewed ? "나" : "기록하기",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: option ? FontWeight.w500 : FontWeight.w600,
                        color:
                            kSecondaryTextColor.withOpacity(option ? 0.5 : 1)),
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
            onTap: onTap,
            child: Container(
              width: 152,
              decoration: BoxDecoration(
                  border: Border(
                      bottom: option
                          ? BorderSide(color: kSecondaryTextColor, width: 1)
                          : BorderSide.none)),
              child: Column(
                children: [
                  Text(
                    "사람들",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: option ? FontWeight.w600 : FontWeight.w500,
                        color:
                            kSecondaryTextColor.withOpacity(option ? 1 : 0.5)),
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
    );
  }
}

class ScoringBox extends StatelessWidget {
  const ScoringBox({
    Key? key,
    required this.onCompleted,
    required this.score,
    required this.scrollScore,
    required this.onScroll,
    required this.onScrollEnd,
  }) : super(key: key);
  final onCompleted;
  final int score;
  final double scrollScore;
  final onScroll;
  final onScrollEnd;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 330,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 4),
                blurRadius: 17,
                color: Colors.black.withOpacity(0.08))
          ]),
      child: Column(
        children: [
          SizedBox(
            height: 48,
          ),
          Text(
            resScoreIcons[score - 1][0],
            style: TextStyle(
                fontFamily: 'Suit', fontWeight: FontWeight.w800, fontSize: 55),
          ),
          SizedBox(
            height: 1,
          ),
          Text(
            resScoreIcons[score - 1][1],
            style: TextStyle(
                fontFamily: 'Suit',
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: kSecondaryTextColor),
          ),
          SizedBox(
            height: 30,
          ),
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 34.0, right: 34, top: 5),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Color(0xffd9d9d9).withOpacity(0.5),
                  ),
                  height: 6,
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                    overlayShape: SliderComponentShape.noOverlay,
                    trackHeight: 0,
                    thumbColor: kBasicColor,
                    thumbShape: CustomRoundSliderThumbShape(
                      enabledThumbRadius: 8,
                      elevation: 0,
                    )),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: Slider(
                      value: scrollScore,
                      min: 0.0,
                      max: 4.0,
                      onChangeEnd: (val) {
                        onScrollEnd(val);
                      },
                      onChanged: (val) {
                        onScroll(val);
                      }),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 6,
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 48),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("5", style: ScoreTextStyle(5, score)),
                  Text("4", style: ScoreTextStyle(4, score)),
                  Text("3", style: ScoreTextStyle(3, score)),
                  Text("2", style: ScoreTextStyle(2, score)),
                  Text("1", style: ScoreTextStyle(1, score))
                ],
              )),
          SizedBox(
            height: 38,
          ),
          GestureDetector(
            onTap: onCompleted,
            child: Container(
              width: 92,
              height: 44,
              child: Center(
                  child: Text(
                "완료",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Suit',
                    color: kSecondaryTextColor,
                    fontSize: 15),
              )),
              decoration: BoxDecoration(
                  color: Color(0xffececec),
                  borderRadius: BorderRadius.circular(15)),
            ),
          ),
        ],
      ),
    );
  }
}

TextStyle ScoreTextStyle(num, score) {
  return num == score
      ? TextStyle(
          fontWeight: FontWeight.w900,
          fontFamily: 'Suit',
          color: kBasicColor,
          fontSize: 14)
      : TextStyle(
          fontWeight: FontWeight.w600,
          fontFamily: 'Suit',
          color: kSecondaryTextColor.withOpacity(0.7),
          fontSize: 14);
}
