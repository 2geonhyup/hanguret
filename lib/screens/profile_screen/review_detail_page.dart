import 'package:flutter/material.dart';
import 'package:hangeureut/constants.dart';
import 'package:hangeureut/providers/profile/profile_state.dart';
import 'package:hangeureut/providers/reviews/reviews_provider.dart';
import 'package:hangeureut/providers/reviews/reviews_state.dart';
import 'package:hangeureut/screens/review_screen/review_page.dart';
import 'package:hangeureut/widgets/click_dialog.dart';
import 'package:hangeureut/widgets/error_dialog.dart';
import 'package:hangeureut/widgets/res_title.dart';
import 'package:hangeureut/widgets/review_box.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../models/custom_error.dart';
import '../../models/review_model.dart';
import '../../repositories/restaurant_repository.dart';
import '../../restaurants.dart';
import '../restaurant_detail_screen/restaurant_detail_page.dart';

class ReviewDetailPage extends StatefulWidget {
  ReviewDetailPage(
      {Key? key,
      required this.reviews,
      this.others = false,
      required this.clickedReviewIndex})
      : super(key: key);

  List<Review> reviews;
  bool others;
  int clickedReviewIndex = 0;

  @override
  State<ReviewDetailPage> createState() => _ReviewDetailPageState();
}

class _ReviewDetailPageState extends State<ReviewDetailPage> {
  List<bool> likes = [];
  List<bool> originLikes = [];
  ItemScrollController _controller = ItemScrollController();

  void _setLikes() {
    likes = [];
    originLikes = [];
    for (var review in widget.reviews) {
      if (review.likes.contains(context.read<ProfileState>().user.id)) {
        likes.add(true);
        originLikes.add(true);
      } else {
        likes.add(false);
        originLikes.add(false);
      }
    }
  }

  _updateReviews() {
    widget.reviews = context.read<ReviewState>().reviewList;
    _setLikes();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    _setLikes();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> reviewWidgets = [];
    widget.reviews.asMap().forEach((index, review) {
      reviewWidgets.add(Column(
        children: [
          const SizedBox(
            height: 42,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              index == 0
                  ? Padding(
                      padding: const EdgeInsets.only(left: 34),
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: kBasicTextColor.withOpacity(0.8),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    )
                  : const SizedBox.shrink(),
              Padding(
                padding: const EdgeInsets.only(right: 26.0),
                child: widget.others
                    ? const SizedBox.shrink()
                    : IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20))),
                              context: context,
                              builder: (context) {
                                return reviewModal(
                                    pContext: context,
                                    index: index,
                                    reviewId: review.reviewId,
                                    resId: review.resId,
                                    resImgUrl: review.imgUrl,
                                    score: int.parse(review.score));
                              });
                        },
                        icon: Icon(
                          Icons.more_horiz,
                          color: kBasicTextColor.withOpacity(0.8),
                        ),
                      ),
              ),
            ],
          ),
          const SizedBox(
            height: 13,
          ),
          GestureDetector(
            onTap: () {
              pushNewScreen(context,
                  screen:
                      RestaurantDetailPage(resId: review.resId, option: true));
            },
            child: ResTitle(
              category: review.category,
              icon: review.icon,
              name: review.resName,
            ),
          ),
          ReviewBox(
              resName: review.resName,
              userId: review.userId,
              paddingHeight: 46,
              reviewId: review.reviewId,
              date: review.date,
              score:
                  5 >= int.parse(review.score) && int.parse(review.score) >= 1
                      ? int.parse(review.score)
                      : 5,
              imgUrl: review.imgUrl,
              icon: review.icon == -1
                  ? ""
                  : resFilterIcons[review.category][review.icon],
              tag: resFilterTextsSh[review.category][review.icon + 1],
              onLike: () {
                setState(() {});
              },
              likes: review.likes.length,
              liked:
                  review.likes.contains(context.read<ProfileState>().user.id)),
          const SizedBox(
            height: 70,
          ),
          Divider(
            thickness: 0.5,
            height: 0.5,
            color: kBorderGreenColor.withOpacity(0.5),
          ),
        ],
      ));
    });
    return Scaffold(
      body: ScrollablePositionedList.builder(
        padding: EdgeInsets.zero,
        itemScrollController: _controller,
        initialScrollIndex: widget.clickedReviewIndex,
        itemCount: reviewWidgets.length,
        itemBuilder: (context, index) {
          return reviewWidgets[index];
        },
      ),
    );
  }

  Widget reviewModal(
      {required BuildContext pContext,
      required int index,
      required int reviewId,
      required String resId,
      required String resImgUrl,
      required int score}) {
    return Container(
      height: 321,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20), topLeft: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 15,
            ),
            Container(
              width: 60,
              height: 7,
              decoration: BoxDecoration(
                  color: const Color(0xffd9d9d9),
                  borderRadius: BorderRadius.circular(30)),
            ),
            const SizedBox(
              height: 41,
            ),
            GestureDetector(
              onTap: () {
                pushNewScreen(pContext,
                    screen: RestaurantDetailPage(
                      option: true,
                      resId: resId,
                    ));
              },
              child: Container(
                height: 60,
                child: const Center(
                    child: Text(
                  "가게 정보",
                  style: TextStyle(
                      fontSize: 14,
                      height: 1,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Suit',
                      color: kSecondaryTextColor),
                )),
              ),
            ),
            GestureDetector(
              onTap: () async {
                //수정 repository
                //다시 리뷰 받아오는 함수(덮어쓰기)옴
                Map? res;
                try {
                  res = await context
                      .read<RestaurantRepository>()
                      .getRestaurantsDetail(resId: resId);

                  Navigator.pop(context);
                  pushNewScreen(context,
                      screen: ReviewPage(
                        res: res,
                        score: score,
                        reviewId: reviewId,
                        imgUrl: resImgUrl,
                      ));
                } on CustomError catch (e) {
                  errorDialog(context, e);
                }
              },
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                    border: Border.symmetric(
                  horizontal: BorderSide(
                      width: 0.5, color: kBorderGreenColor.withOpacity(0.5)),
                )),
                child: const Center(
                    child: Text(
                  "수정",
                  style: TextStyle(
                      fontSize: 14,
                      height: 1,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Suit',
                      color: kSecondaryTextColor),
                )),
              ),
            ),
            GestureDetector(
              onTap: () async {
                //삭제 repository
                try {
                  clickCancelDialog(
                      context: context,
                      title: "알림",
                      content: "정말 리뷰를 삭제하시겠어요?",
                      clicked: () async {
                        await context.read<ReviewProvider>().reviewDelete(
                            resId: resId, reviewId: reviewId.toString());
                        Navigator.pop(context);
                        _updateReviews();
                        return false;
                      });
                } on CustomError catch (e) {
                  errorDialog(context, e);
                }
              },
              child: Container(
                height: 60,
                child: const Center(
                    child: Text(
                  "삭제",
                  style: TextStyle(
                      fontSize: 14,
                      height: 1,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Suit',
                      color: Color(0xffe01e1e)),
                )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
