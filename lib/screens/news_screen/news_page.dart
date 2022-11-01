import 'package:flutter/material.dart';
import 'package:hangeureut/constants.dart';
import 'package:hangeureut/models/custom_error.dart';
import 'package:hangeureut/providers/profile/profile_provider.dart';
import 'package:hangeureut/repositories/news_repository.dart';
import 'package:hangeureut/restaurants.dart';
import 'package:hangeureut/widgets/error_dialog.dart';
import 'package:hangeureut/widgets/review_box.dart';
import 'package:provider/provider.dart';
import '../../providers/profile/profile_state.dart';
import 'news_view.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  List? friendsNews;
  List? recommendNews;
  List likes = [];
  List originLikes = [];
  List<Widget> newsWidgets = [];
  List followings = [];
  List followingsId = [];
  bool loading = true;
  bool showReco = false;

  Future<void> _getNews() async {
    followings = context.read<ProfileState>().user.followings;
    followingsId = followings.map((e) => e["id"]).toList();
    loading = true;
    try {
      friendsNews = await context
          .read<NewsRepository>()
          .getFriendsNews(friendsIds: followingsId);
    } on CustomError catch (e) {
      errorDialog(context, e);
    }

    String myId = context.read<ProfileState>().user.id;
    if (friendsNews != []) {
      for (var e in friendsNews!) {
        if (e["likes"].contains(myId)) {
          likes.add(true);
          originLikes.add(true);
        } else {
          likes.add(false);
          originLikes.add(false);
        }
      }
    }

    try {
      recommendNews = await context.read<NewsRepository>().getRecoNews();

      for (var e in recommendNews!) {
        likes.add(e["liked"]);
      }
      loading = false;
    } on CustomError catch (e) {
      errorDialog(context, e);
    }

    setState(() {});
  }

  void _makeWidgetsList() {
    newsWidgets = [];

    if (friendsNews != null) {
      friendsNews!.asMap().forEach((index, news) {
        int icon = context
            .read<ProfileProvider>()
            .findFollowingsIcon(id: news["userId"]);
        print(news);
        newsWidgets.add(Column(
          children: [
            //수정
            NewsInfoBox(
                icon: icon,
                userId: news["userId"],
                name: news["userName"],
                date: news["date"],
                resId: news["resId"],
                resName: ""),
            SizedBox(
              height: 23,
            ),
            //수정
            ReviewBox(
              resName: "",
              userId: news["userId"],
              reviewId: news["reviewId"],
              imgUrl: news["imgUrl"],
              icon: resFilterIcons[news!["category"]][news!["icon"]],
              tag: resFilterTextsSh[news!["category"]][news!["icon"]],
              onLike: () {
                setState(() {
                  likes[index] = !likes[index];
                });
              },
              likes: likes[index] == originLikes[index]
                  ? news["likes"].length
                  : !likes[index] && originLikes[index]
                      ? news["likes"].length - 1
                      : news["likes"].length + 1,
              liked: likes[index],
              isDate: false,
            ),
          ],
        ));
      });
    }

    if (recommendNews != null) {
      newsWidgets.add(showReco
          ? Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0, bottom: 14),
                        child: Text(
                          "추천 게시물",
                          style: TextStyle(
                              height: 1,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Suit',
                              color: kSecondaryTextColor),
                        ),
                      ),
                      Padding(
                          padding:
                              const EdgeInsets.only(bottom: 11.0, right: 33),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                showReco = false;
                              });
                            },
                            child: Icon(
                              Icons.close_rounded,
                              size: 13,
                              color: kSecondaryTextColor,
                            ),
                          ))
                    ],
                  ),
                  Divider(
                    height: 0.5,
                    thickness: 0.5,
                    color: kBorderGreenColor.withOpacity(0.5),
                  )
                ],
              ),
            )
          : GestureDetector(
              onTap: () {
                setState(() {
                  showReco = true;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Center(
                  child: Text(
                    "추천 게시물 보기",
                    style: TextStyle(
                        height: 1,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Suit',
                        color: kBasicColor),
                  ),
                ),
              ),
            ));

      recommendNews!.asMap().forEach((index, news) {
        newsWidgets.add(showReco
            ? Column(
                children: [
                  //수정
                  NewsInfoBox(
                    icon: 21,
                    userId: news["userId"],
                    name: news["userName"],
                    date: news["date"],
                    resId: news["resId"],
                    resName: news["resName"],
                    zzim: true,
                  ),
                  SizedBox(
                    height: 23,
                  ),
                  //수정
                  ReviewBox(
                    resName: news["resName"],
                    userId: news["userId"],
                    reviewId: news["reviewId"],
                    imgUrl: news["imgUrl"],
                    icon: resFilterTextIconMap[news["category"]]
                        [news!["icon"]]!,
                    tag: news["icon"],
                    onLike: () {
                      setState(() {
                        likes[index] = !likes[index];
                      });
                    },
                    likes: likes[index] == news["liked"]
                        ? news["likes"]
                        : !likes[index] && news["liked"]
                            ? news["likes"] - 1
                            : news["likes"] + 1,
                    liked: likes[index],
                    isDate: false,
                  ),
                ],
              )
            : SizedBox.shrink());
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getNews();
    });
  }

  @override
  Widget build(BuildContext context) {
    _makeWidgetsList();
    return Scaffold(
        body: loading
            ? Center(
                child: CircularProgressIndicator(
                  color: kBasicColor,
                  strokeWidth: 2,
                ),
              )
            : RefreshIndicator(
                onRefresh: _getNews,
                color: kBasicColor,
                backgroundColor: Colors.white,
                strokeWidth: 2,
                child: ListView.builder(
                  padding: EdgeInsets.only(top: 40, bottom: 100),
                  itemCount: newsWidgets.length,
                  itemBuilder: (context, index) {
                    return newsWidgets[index];
                  },
                ),
              ));
  }
}
