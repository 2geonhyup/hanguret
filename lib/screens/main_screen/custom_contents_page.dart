import 'package:flutter/material.dart';
import 'package:hangeureut/constants.dart';
import 'package:hangeureut/screens/restaurant_detail_screen/restaurant_detail_page.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../repositories/restaurant_repository.dart';
import '../../widgets/loading_widget.dart';

class CustomContentsPage extends StatefulWidget {
  const CustomContentsPage(
      {Key? key,
      this.images = const [],
      this.title = "",
      this.subTitle = "",
      this.tag = "",
      this.icon = "",
      required this.titleImage,
      required this.allContents,
      this.resIds = const []})
      : super(key: key);
  final List images;
  final String title;
  final String subTitle;
  final String icon;
  final String tag;
  final String titleImage;
  final List allContents;
  final List resIds;

  @override
  State<CustomContentsPage> createState() => _CustomContentsPageState();
}

class _CustomContentsPageState extends State<CustomContentsPage> {
  Future<Map> getRes(String resId) async {
    Map res = await context
        .read<RestaurantRepository>()
        .getRestaurantsDetail(resId: resId);
    return res;
  }

  List imgList = [];

  Future getImages() async {
    for (var e in widget.images) {
      imgList.add(NetworkImage(e));
    }
    for (var img in imgList) {
      await precacheImage(img, context);
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: getImages(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return LoadingWidget();
            else {
              List<Widget> items = [];
              items.add(topWidget(context));
              int length = widget.images.length;

              widget.images.asMap().forEach((index, element) {
                index == 0 || index == length - 1
                    ? items.add(Image(image: imgList[index]))
                    : items.add(Column(
                        children: [
                          !widget.resIds.asMap().containsKey(index - 1)
                              ? const SizedBox.shrink()
                              : FutureBuilder(
                                  future: getRes(widget.resIds[index - 1]),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      Map dataMap = snapshot.data as Map;
                                      return ResCard(
                                        title: dataMap["name"],
                                        detail: dataMap["detail"],
                                        score: dataMap["score"],
                                        resId: dataMap["resId"].toString(),
                                      );
                                    } else {
                                      return ResCard();
                                    }
                                  },
                                ),
                          Container(
                              color: Colors.white,
                              child: Image(image: imgList[index])),
                        ],
                      ));
              });

              items.add(const SizedBox(
                height: 50,
              ));

              items.add(Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      child: Divider(
                        thickness: 1,
                        color: kSecondaryTextColor,
                      ),
                      width: 350,
                    ),
                    const SizedBox(
                      height: 38,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 33,
                        ),
                        const Text(
                          "다른",
                          style: TextStyle(
                              fontFamily: 'Suit',
                              fontSize: 18,
                              color: kBasicColor,
                              fontWeight: FontWeight.w900,
                              height: 1),
                        ),
                        const Text(" 콘텐츠도 보기",
                            style: TextStyle(
                                fontFamily: 'Suit',
                                fontSize: 18,
                                color: kSecondaryTextColor,
                                fontWeight: FontWeight.w900,
                                height: 1)),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ));

              var list = List<int>.generate(widget.allContents.length, (i) => i)
                ..shuffle();
              list = list.take(3).toList();
              for (var i in list) {
                items.add(Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: nextWidget(widget.allContents[i], widget.allContents),
                ));
              }

              items.add(const SizedBox(
                height: 70,
              ));
              return ListView(
                padding: EdgeInsets.zero,
                children: items,
              );
            }
          }),
    );
  }

  Widget nextWidget(targetContents, List allContents) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 37.0),
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CustomContentsPage(
                  titleImage: targetContents["titleImage"],
                  images: targetContents["images"],
                  title: targetContents["title"],
                  subTitle: targetContents["subTitle"],
                  icon: targetContents["icon"],
                  tag: targetContents["tag"],
                  allContents: allContents,
                  resIds: targetContents.containsKey("resIds")
                      ? targetContents["resIds"]
                      : [],
                ),
              ));
        },
        child: Stack(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 324),
                child: ClipRRect(
                  child: Image.network(
                    targetContents["titleImage"],
                    fit: BoxFit.cover,
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
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            Positioned(
              bottom: 27,
              left: 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    targetContents["subTitle"],
                    style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        //height: 1,
                        fontSize: 14,
                        color: Colors.white,
                        fontFamily: 'Suit'),
                  ),
                  Text(
                    targetContents["title"],
                    style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        //height: 1,
                        fontSize: 30,
                        color: Colors.white,
                        fontFamily: 'Suit'),
                  )
                ],
              ),
            ),
            Positioned(
              left: 23,
              top: 17,
              child: Container(
                height: 35,
                width: 82,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(19.5)),
                child: Center(
                    child: Text(
                  "${targetContents["icon"]} ${targetContents["tag"]}",
                  style: const TextStyle(
                      fontFamily: 'Suit',
                      color: kSecondaryTextColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w300),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget topWidget(context) {
    return SizedBox(
      height: 338,
      child: Stack(
        children: [
          SizedBox(
            height: 303,
            child: Stack(
              children: [
                SizedBox(
                  height: 303,
                  width: double.infinity,
                  child: Image.network(
                    widget.titleImage,
                    fit: BoxFit.cover,
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
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 216,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0),
                          Colors.black.withOpacity(0.23)
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      )),
                    )),
                Positioned(
                  bottom: 30,
                  left: 31,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.subTitle,
                        style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            //height: 1,
                            fontSize: 18,
                            color: Colors.white,
                            fontFamily: 'Suit'),
                      ),
                      Text(
                        widget.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            //height: 1,
                            fontSize: 35,
                            color: Colors.white,
                            fontFamily: 'Suit'),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 17.5,
            right: 30,
            child: Container(
              width: 82,
              height: 35,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(19.5),
                  boxShadow: [
                    BoxShadow(
                        offset: const Offset(0, 1),
                        blurRadius: 5,
                        color: kSecondaryTextColor.withOpacity(0.4))
                  ]),
              child: Center(
                child: Text(
                  "${widget.icon} ${widget.tag}",
                  style: const TextStyle(
                      height: 1,
                      fontSize: 14,
                      fontFamily: 'Suit',
                      fontWeight: FontWeight.w300,
                      color: kSecondaryTextColor),
                ),
              ),
            ),
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
        ],
      ),
    );
  }
}

class ResCard extends StatelessWidget {
  ResCard(
      {Key? key,
      this.title = "",
      this.detail = "",
      this.score = "?",
      this.resId})
      : super(key: key);
  final String title;
  final String detail;
  final String score;
  final String? resId;
  BorderSide _borderSide =
      BorderSide(color: kSecondaryTextColor.withOpacity(0.2), width: 1);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 14.0),
          child: Container(
            width: 310,
            height: 126,
            child: Padding(
              padding: const EdgeInsets.only(right: 23.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Suit',
                        fontSize: 18,
                        color: kSecondaryTextColor),
                  ),
                  Text(
                    detail,
                    style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Suit',
                        fontSize: 12,
                        color: kSecondaryTextColor),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 70,
                        height: 29,
                        decoration: BoxDecoration(
                            color: const Color(0xfff3f3f2),
                            borderRadius: BorderRadius.circular(11)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "평점 ",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Suit',
                                  fontSize: 12,
                                  color: kSecondaryTextColor),
                            ),
                            Text(
                              score,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'Suit',
                                  fontSize: 12,
                                  color: kBasicColor),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          if (resId != null) {
                            pushNewScreen(context,
                                screen: RestaurantDetailPage(
                                    resId: resId!, option: true),
                                withNavBar: false);
                          }
                        },
                        child: Container(
                          width: 70,
                          height: 29,
                          decoration: BoxDecoration(
                              color: const Color(0xfff3f3f2),
                              borderRadius: BorderRadius.circular(11)),
                          child: const Center(
                            child: Text(
                              "자세히",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Suit',
                                  fontSize: 12,
                                  color: kSecondaryTextColor),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(19),
                    bottomRight: Radius.circular(19)),
                border: Border(
                    right: _borderSide,
                    bottom: _borderSide,
                    top: _borderSide,
                    left: _borderSide)),
          ),
        ),
        Expanded(
          child: Container(
            height: 126,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(19),
                    bottomLeft: Radius.circular(19)),
                border: Border(
                    right: _borderSide,
                    bottom: _borderSide,
                    top: _borderSide,
                    left: _borderSide)),
          ),
        ),
      ],
    );
  }
}
