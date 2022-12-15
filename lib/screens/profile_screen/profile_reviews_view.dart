import 'package:flutter/material.dart';
import 'package:hangeureut/screens/profile_screen/review_detail_page.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../models/review_model.dart';
import '../../providers/profile/profile_provider.dart';
import '../restaurant_detail_screen/restaurant_detail_page.dart';

class ProfileReviewsView extends StatefulWidget {
  ProfileReviewsView(
      {Key? key,
      this.reviews = const [],
      this.saved = const [],
      required this.count,
      required this.forSaved,
      required this.showingLength,
      this.others = false})
      : super(key: key);

  List<Review> reviews;
  List saved;
  final int count;
  final bool forSaved;
  final int showingLength;
  final bool others;

  @override
  State<ProfileReviewsView> createState() => _ProfileReviewsViewState();
}

class _ProfileReviewsViewState extends State<ProfileReviewsView> {
  // 1. 기록을 세개씩 묶어서 리스트로 저장, 나머지는 처음에 넣어야 함

  List reviewsCollection = [];
  int cnt = 0;

  List<Review> reviewList = [];

  void _setReviewsCollection() {
    int changePoint = widget.count % 3;
    List imsiList = [];
    int cnt = 0;
    if (widget.forSaved) {
      for (var save in widget.saved) {
        imsiList.add([save["imgUrl"], save["resId"]]);
        if ((cnt % 3 + 1) % 3 == changePoint) {
          if (imsiList.isNotEmpty) {
            reviewsCollection.add(imsiList);
            if (cnt > widget.showingLength) break;
          }
          imsiList = [];
        }
        cnt++;
      }
    } else {
      for (var review in widget.reviews) {
        imsiList.add([review.imgUrl, review.resId, cnt]);
        if ((cnt % 3 + 1) % 3 == changePoint) {
          if (imsiList.isNotEmpty) {
            reviewsCollection.add(imsiList);
            if (cnt > widget.showingLength) break;
          }
          imsiList = [];
        }
        cnt++;
      }
    }
  }

  void _reviewClicked(int index) {
    if (widget.others) {
      pushNewScreen(context,
          screen: ReviewDetailPage(
            reviews: widget.reviews,
            others: true,
            clickedReviewIndex: index,
          ),
          withNavBar: false);
    } else {
      pushNewScreen(context,
          screen: ReviewDetailPage(
            reviews: widget.reviews,
            clickedReviewIndex: index,
          ),
          withNavBar: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double sideLength2 = screenWidth / 2 - 4;
    double sideLength31 = (screenWidth - 16) / 3;
    double sideLength32 = 2 * sideLength31 + 8;
    bool direction = true;
    reviewsCollection = [];
    reviewList = [];
    cnt = 0;
    _setReviewsCollection();

    return GestureDetector(
      onTap: () {},
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: reviewsCollection.length,
        itemBuilder: (context, index) {
          if (reviewsCollection[index].length == 3) {
            direction = !direction;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: row3(
                sideLength31: sideLength31,
                sideLength32: sideLength32,
                direction: direction,
                reviews: reviewsCollection[index],
                forSaved: widget.forSaved,
                reviewClicked: _reviewClicked,
              ),
            );
          } else if (reviewsCollection[index].length == 1) {
            return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: row1(
                  screenWidth: screenWidth,
                  reviews: reviewsCollection[index],
                  forSaved: widget.forSaved,
                  reviewClicked: _reviewClicked,
                ));
          } else {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: row2(
                sideLength2: sideLength2,
                reviews: reviewsCollection[index],
                forSaved: widget.forSaved,
                reviewClicked: _reviewClicked,
              ),
            );
          }
        },
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
      ),
    );
  }
}

class SavedTile extends StatelessWidget {
  const SavedTile(this.width, this.height, this.resId, this.imgUrl);

  final double width;
  final double height;
  final String resId;
  final String imgUrl;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          pushNewScreen(context,
              screen: RestaurantDetailPage(resId: resId, option: false));
        },
        child: Stack(
          children: [
            SizedBox(
              width: width,
              height: height,
              child: Image.network(
                imgUrl,
                fit: BoxFit.fill,
                loadingBuilder: (context, widget, _) {
                  return Container(
                    color: Colors.black.withOpacity(0.1),
                    child: widget,
                  );
                },
                errorBuilder: (context, widget, _) {
                  return Image.asset(
                    "images/error_tile.png",
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            Positioned(
              top: 13,
              right: 13,
              child: GestureDetector(
                onTap: () async {
                  await context.read<ProfileProvider>().saveRemoveRes(
                      resId: resId, imgUrl: imgUrl, isSave: false);
                },
                child: Image.asset(
                  "images/icons/bookmark_fill.png",
                  color: Colors.white,
                  width: 17,
                ),
              ),
            )
          ],
        ));
  }
}

class row1 extends StatelessWidget {
  row1(
      {Key? key,
      required this.forSaved,
      required this.screenWidth,
      required this.reviews,
      required this.reviewClicked})
      : super(key: key);

  bool forSaved;
  double screenWidth;
  List reviews;
  Function reviewClicked;

  @override
  Widget build(BuildContext context) {
    return forSaved
        ? SavedTile(screenWidth, screenWidth, reviews[0][1], reviews[0][0])
        : reviewTile(
            index: reviews[0][2],
            reviewClicked: reviewClicked,
            width: screenWidth,
            height: screenWidth,
            imgUrl: reviews[0][0]);
  }
}

class row3 extends StatelessWidget {
  row3(
      {Key? key,
      required this.sideLength31,
      required this.sideLength32,
      required this.direction,
      required this.reviews,
      required this.forSaved,
      required this.reviewClicked})
      : super(key: key);
  double sideLength31;
  double sideLength32;
  bool direction;
  List reviews;
  bool forSaved;
  Function reviewClicked;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: direction
          ? [
              forSaved
                  ? SavedTile(
                      sideLength32, sideLength32, reviews[0][1], reviews[0][0])
                  : reviewTile(
                      index: reviews[0][2],
                      reviewClicked: reviewClicked,
                      width: sideLength32,
                      height: sideLength32,
                      imgUrl: reviews[0][0]),
              SizedBox(
                height: sideLength32,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    forSaved
                        ? SavedTile(sideLength31, sideLength31, reviews[1][1],
                            reviews[1][0])
                        : reviewTile(
                            index: reviews[1][2],
                            reviewClicked: reviewClicked,
                            width: sideLength31,
                            height: sideLength31,
                            imgUrl: reviews[1][0]),
                    forSaved
                        ? SavedTile(sideLength31, sideLength31, reviews[2][1],
                            reviews[2][0])
                        : reviewTile(
                            index: reviews[2][2],
                            reviewClicked: reviewClicked,
                            width: sideLength31,
                            height: sideLength31,
                            imgUrl: reviews[2][0])
                  ],
                ),
              )
            ]
          : [
              SizedBox(
                height: sideLength32,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    forSaved
                        ? SavedTile(sideLength31, sideLength31, reviews[0][1],
                            reviews[0][0])
                        : reviewTile(
                            index: reviews[0][2],
                            reviewClicked: reviewClicked,
                            width: sideLength31,
                            height: sideLength31,
                            imgUrl: reviews[0][0]),
                    forSaved
                        ? SavedTile(sideLength31, sideLength31, reviews[1][1],
                            reviews[1][0])
                        : reviewTile(
                            index: reviews[1][2],
                            reviewClicked: reviewClicked,
                            width: sideLength31,
                            height: sideLength31,
                            imgUrl: reviews[1][0])
                  ],
                ),
              ),
              forSaved
                  ? SavedTile(
                      sideLength32, sideLength32, reviews[2][1], reviews[2][0])
                  : reviewTile(
                      index: reviews[2][2],
                      reviewClicked: reviewClicked,
                      width: sideLength32,
                      height: sideLength32,
                      imgUrl: reviews[2][0])
            ],
    );
  }
}

class reviewTile extends StatelessWidget {
  reviewTile(
      {Key? key,
      required this.width,
      required this.height,
      required this.imgUrl,
      required this.reviewClicked,
      required this.index})
      : super(key: key);
  double width;
  double height;
  String imgUrl;
  Function reviewClicked;
  int index;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: GestureDetector(
        onTap: () {
          print(index);
          reviewClicked(index);
        },
        child: Image.network(
          imgUrl,
          fit: BoxFit.fill,
          loadingBuilder: (context, widget, _) {
            return Container(
              color: Colors.black.withOpacity(0.1),
              child: widget,
            );
          },
          errorBuilder: (context, widget, _) {
            return Image.asset(
              "images/error_tile.png",
              fit: BoxFit.cover,
            );
          },
        ),
      ),
    );
  }
}

class row2 extends StatelessWidget {
  row2(
      {Key? key,
      required this.sideLength2,
      required this.reviews,
      required this.forSaved,
      required this.reviewClicked})
      : super(key: key);
  double sideLength2;
  List reviews;
  bool forSaved;
  Function reviewClicked;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        forSaved
            ? SavedTile(sideLength2, sideLength2, reviews[0][1], reviews[0][0])
            : reviewTile(
                index: reviews[0][2],
                reviewClicked: reviewClicked,
                width: sideLength2,
                height: sideLength2,
                imgUrl: reviews[0][0],
              ),
        forSaved
            ? SavedTile(sideLength2, sideLength2, reviews[1][1], reviews[1][0])
            : reviewTile(
                index: reviews[1][2],
                reviewClicked: reviewClicked,
                width: sideLength2,
                height: sideLength2,
                imgUrl: reviews[1][0]),
      ],
    );
  }
}
