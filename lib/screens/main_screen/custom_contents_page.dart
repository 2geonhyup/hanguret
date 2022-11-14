import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hangeureut/constants.dart';
import 'package:hangeureut/screens/restaurant_detail_screen/restaurant_detail_page.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../providers/contents/content_state.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CustomContentsPage extends StatefulWidget {
  const CustomContentsPage(
      {Key? key,
      this.images = const [],
      this.title = "",
      this.subTitle = "",
      this.tag = "",
      this.icon = "",
      required this.titleImage,
      required this.allContents})
      : super(key: key);
  final List images;
  final String title;
  final String subTitle;
  final String icon;
  final String tag;
  final String titleImage;
  final List allContents;

  @override
  State<CustomContentsPage> createState() => _CustomContentsPageState();
}

class _CustomContentsPageState extends State<CustomContentsPage> {
  @override
  Widget build(BuildContext context) {
    List<Widget> items = [];
    items.add(topWidget(context));
    int length = widget.images.length;

    widget.images.asMap().forEach((index, element) {
      index == 0 || index == length - 1
          ? items.add(CachedNetworkImage(
              imageUrl: element,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Container(
                color: Colors.black.withOpacity(0.1),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ))
          : items.add(Column(
              children: [
                ResCard(),
                Container(
                    color: Colors.white,
                    child: CachedNetworkImage(
                      imageUrl: element,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) => Container(
                        width: double.infinity,
                        height: 400,
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        color: Colors.grey.withOpacity(0.2),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    )),
              ],
            ));
    });

    items.add(SizedBox(
      height: 50,
    ));

    items.add(Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            child: Divider(
              thickness: 1,
              color: kSecondaryTextColor,
            ),
            width: 350,
          ),
          SizedBox(
            height: 38,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 33,
              ),
              Text(
                "다른",
                style: TextStyle(
                    fontFamily: 'Suit',
                    fontSize: 18,
                    color: kBasicColor,
                    fontWeight: FontWeight.w900,
                    height: 1),
              ),
              Text(" 콘텐츠도 보기",
                  style: TextStyle(
                      fontFamily: 'Suit',
                      fontSize: 18,
                      color: kSecondaryTextColor,
                      fontWeight: FontWeight.w900,
                      height: 1)),
            ],
          ),
          SizedBox(
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

    items.add(SizedBox(
      height: 70,
    ));

    //items.add();
    //List.generate(images.length, (index) => Image.network(images[index]));
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: items,
      ),
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
                  child: CachedNetworkImage(
                    imageUrl: targetContents["titleImage"],
                    fit: BoxFit.cover,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Container(
                      color: Colors.black.withOpacity(0.1),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
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
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        //height: 1,
                        fontSize: 14,
                        color: Colors.white,
                        fontFamily: 'Suit'),
                  ),
                  Text(
                    targetContents["title"],
                    style: TextStyle(
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
                  style: TextStyle(
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
    return Container(
      height: 338,
      child: Stack(
        children: [
          Container(
            height: 303,
            child: Stack(
              children: [
                Container(
                  height: 303,
                  width: double.infinity,
                  child: CachedNetworkImage(
                    imageUrl: widget.titleImage,
                    fit: BoxFit.cover,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Container(
                      width: double.infinity,
                      color: Colors.black.withOpacity(0.1),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                Positioned(
                  bottom: 30,
                  left: 31,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.subTitle,
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            //height: 1,
                            fontSize: 18,
                            color: Colors.white,
                            fontFamily: 'Suit'),
                      ),
                      Text(
                        widget.title,
                        style: TextStyle(
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
                        offset: Offset(0, 1),
                        blurRadius: 5,
                        color: kSecondaryTextColor.withOpacity(0.4))
                  ]),
              child: Center(
                child: Text(
                  "${widget.icon} ${widget.tag}",
                  style: TextStyle(
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
                icon: Icon(
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
      {Key? key, this.title = "", this.detail = "", this.score = 0, this.resId})
      : super(key: key);
  final String title;
  final String detail;
  final int score;
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
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "dhfkfkf",
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Suit',
                        fontSize: 18,
                        color: kSecondaryTextColor),
                  ),
                  Text(
                    "gddfdafdafdagd",
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Suit',
                        fontSize: 12,
                        color: kSecondaryTextColor),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 70,
                        height: 29,
                        decoration: BoxDecoration(
                            color: Color(0xfff3f3f2),
                            borderRadius: BorderRadius.circular(11)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "평점 ",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Suit',
                                  fontSize: 12,
                                  color: kSecondaryTextColor),
                            ),
                            Text(
                              "4.3",
                              style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'Suit',
                                  fontSize: 12,
                                  color: kBasicColor),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          if (resId != null) {
                            pushNewScreen(context,
                                screen: RestaurantDetailPage(
                                    resId: resId!, option: true));
                          }
                        },
                        child: Container(
                          width: 70,
                          height: 29,
                          decoration: BoxDecoration(
                              color: Color(0xfff3f3f2),
                              borderRadius: BorderRadius.circular(11)),
                          child: Center(
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
                borderRadius: BorderRadius.only(
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
                borderRadius: BorderRadius.only(
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
