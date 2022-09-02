import 'package:flutter/material.dart';
import 'package:hangeureut/models/custom_error.dart';
import 'package:hangeureut/restaurants.dart';
import 'package:hangeureut/screens/restaurant_detail_screen/thumb_shape.dart';
import 'package:hangeureut/widgets/error_dialog.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants.dart';
import '../../widgets/res_title.dart';
import '../review_screen/review_page.dart';
// 레이아웃 잡은 것 참고

class RestaurantDetailPage extends StatefulWidget {
  RestaurantDetailPage({Key? key, required this.res, required this.option})
      : super(key: key);
  final res;
  final bool option; // false: 기록, true: 탐색

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  late bool opt;
  late int score;
  late double scrollScore;

  Future<void> _launchUrl(url) async {
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    opt = widget.option;
    score = 5;
    scrollScore = 0;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List items = [
      ResTitle(
          category: widget.res["category1"],
          icon: widget.res["tag1"],
          name: widget.res["name"],
          detail: widget.res["detail"]),
      SizedBox(
        height: 35,
      ),
      OptionRow(
        onTap: () {
          setState(() {
            opt = !opt;
          });
        },
        option: opt,
      ),
      opt
          ? Container()
          : ScoringBox(
              onCompleted: () {
                pushNewScreen(
                  context,
                  screen: ReviewPage(
                    res: widget.res,
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
    ];
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 34.0, top: 54),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: kBasicTextColor.withOpacity(0.8),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 28.0, top: 40),
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
                      "images/icons/bookmark.png",
                      width: 26,
                      height: 26,
                    )
                  ],
                ),
              )
            ],
          ),
          Expanded(
            child: ListView.separated(
                separatorBuilder: (_, __) => SizedBox.shrink(),
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: items.length,
                itemBuilder: (context, int index) {
                  return items[index];
                }),
          ),
          Container(
            height: 83,
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                  offset: Offset(0, -4),
                  blurRadius: 17,
                  color: Colors.black.withOpacity(0.15))
            ]),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 18.0, left: 28),
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
                            "{백엔드}m",
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
                        widget.res["address"],
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
                        'https://map.kakao.com/link/to/${widget.res["kakaoId"]}');
                    try {
                      await _launchUrl(_url);
                    } catch (e) {
                      print(e);
                      final ec =
                          CustomError(code: '', message: '카카오맵을 열 수 없습니다');
                      errorDialog(context, ec);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 18, right: 30),
                    child: Container(
                        width: 79,
                        height: 36,
                        decoration: BoxDecoration(
                            color: kBasicColor,
                            borderRadius: BorderRadius.circular(19)),
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
          ),
        ],
      ),
    );
  }
}

class OptionRow extends StatelessWidget {
  const OptionRow({Key? key, required this.onTap, required this.option})
      : super(key: key);
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
                    "기록하기",
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
  const ScoringBox(
      {Key? key,
      required this.onCompleted,
      required this.score,
      required this.scrollScore,
      required this.onScroll,
      required this.onScrollEnd})
      : super(key: key);
  final onCompleted;
  final int score;
  final double scrollScore;
  final onScroll;
  final onScrollEnd;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 66.0, left: 38, right: 38),
      child: Container(
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
                  fontFamily: 'Suit',
                  fontWeight: FontWeight.w800,
                  fontSize: 55),
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
                      thumbShape: RoundSliderThumbShape(
                        enabledThumbRadius: 8,
                        elevation: 0,
                      )),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 34.0),
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
                padding: EdgeInsets.symmetric(horizontal: 40),
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
