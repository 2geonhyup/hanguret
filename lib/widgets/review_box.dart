import 'package:flutter/material.dart';
import 'package:hangeureut/providers/profile/profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';

import '../constants.dart';
import '../repositories/restaurant_repository.dart';
import '../restaurants.dart';

class ReviewBox extends StatefulWidget {
  ReviewBox(
      {Key? key,
      required this.resName,
      this.userId,
      required this.reviewId,
      this.date, //isDate가 트루라면 받아야함
      this.isDate = true,
      this.score, //isDate 가 트루라면 받아야함
      required this.imgUrl,
      required this.icon,
      required this.tag,
      required this.onLike,
      required this.likes,
      required this.liked,
      this.paddingHeight})
      : super(key: key);

  String resName;
  String? userId;
  String reviewId;
  String? date;
  bool isDate;
  int? score;
  String imgUrl;
  String icon;
  String tag;
  final onLike;
  int likes;
  bool liked;
  double? paddingHeight;

  @override
  State<ReviewBox> createState() => _ReviewBoxState();
}

class _ReviewBoxState extends State<ReviewBox> {
  Future<void> _like() async {
    widget.onLike();
    if (widget.userId == null) return;
    await context.read<ProfileProvider>().reviewLike(
        resName: widget.resName,
        targetId: widget.userId!,
        reviewId: widget.reviewId,
        isAdd: !widget.liked);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 33),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          widget.isDate
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.date!,
                      style: TextStyle(
                          height: 1,
                          fontFamily: 'Suit',
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          color: kSecondaryTextColor),
                    ),
                    Text(
                      " | ${resScoreIcons[widget.score!][0]} ${resScoreIcons[widget.score!][1]}",
                      style: TextStyle(
                          height: 1,
                          fontFamily: 'Suit',
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: kSecondaryTextColor),
                    )
                  ],
                )
              : SizedBox.shrink(),
          widget.isDate
              ? SizedBox(
                  height: widget.paddingHeight ?? 18,
                )
              : SizedBox.shrink(),
          SizedBox(
            height: 380,
            child: Stack(
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onDoubleTap: _like,
                      child: Container(
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                              offset: Offset(0, 4),
                              blurRadius: 19,
                              color: Colors.black.withOpacity(0.25))
                        ]),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(19),
                          child: Image.asset(
                            widget.imgUrl,
                            width: 324,
                            height: 324,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: _like,
                            child: Icon(
                              widget.liked
                                  ? Icons.favorite
                                  : Icons.favorite_border_outlined,
                              size: 16,
                              color: kBasicColor,
                            )),
                        Text(
                          " ${widget.likes}명",
                          style: TextStyle(
                              height: 1.5,
                              fontFamily: 'Suit',
                              fontWeight: FontWeight.w800,
                              fontSize: 12,
                              color: kBasicColor),
                        ),
                        Text(
                          "이 좋아했어요!",
                          style: TextStyle(
                              height: 1.5,
                              fontFamily: 'Suit',
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: kBasicColor),
                        ),
                      ],
                    )
                  ],
                ),
                Positioned(
                  top: 270,
                  right: 14,
                  child: Transform.rotate(
                    angle: 0.16965,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                          color: Color(0xfff3f3f2),
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, 1),
                                blurRadius: 15,
                                color: Colors.black.withOpacity(0.2))
                          ]),
                      child: Stack(
                        children: [
                          Positioned(
                              left: 0,
                              right: 0,
                              top: 30,
                              child: Column(
                                children: [
                                  Center(
                                    child: Text(
                                      widget.icon,
                                      style: TextStyle(
                                          height: 1,
                                          fontSize: 24,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: 'Suit',
                                          color: kSecondaryTextColor),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 9,
                                  ),
                                  Text(widget.tag,
                                      style: TextStyle(
                                          fontSize: 12,
                                          height: 1,
                                          fontWeight: FontWeight.w800,
                                          fontFamily: 'Suit',
                                          color: kSecondaryTextColor))
                                ],
                              )),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
