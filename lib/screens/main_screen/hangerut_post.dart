import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:hangeureut/restaurants.dart';
import 'package:hangeureut/screens/main_screen/recommend_place_page.dart';
import 'package:hangeureut/screens/profile_screen/others_profile_page.dart';
import 'package:hangeureut/screens/restaurant_detail_screen/restaurant_detail_page.dart';
import 'package:hangeureut/widgets/profile_icon_box.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../providers/profile/profile_state.dart';
import '../../providers/restaurants/restaurants_state.dart';
import 'custom_contents_page.dart';

TextStyle _eBoldStyle = const TextStyle(
    fontFamily: 'Suit',
    fontWeight: FontWeight.w800,
    fontSize: 20,
    color: kSecondaryTextColor,
    height: 1);
TextStyle _regularStyle = const TextStyle(
    fontFamily: 'Suit',
    fontWeight: FontWeight.w400,
    fontSize: 20,
    color: kSecondaryTextColor,
    height: 1);

String getUniv(univ) {
  String result = "";
  univ == 1
      ? result = "연대생"
      : univ == 2
          ? result = "이대생"
          : result = "서강대생";
  return result;
}

class HangerutPostWidget extends StatelessWidget {
  HangerutPostWidget({Key? key, required this.contents}) : super(key: key);

  Map contents;

  @override
  Widget build(BuildContext context) {
    //1연세 2이화 3서강

    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      children: contents != {} && contents.containsKey('customContents')
          ? [
              const SizedBox(
                height: 112,
              ),
              CustomContents(contents: contents["customContents"]),
              const SizedBox(height: 80),
              UnivContents(contents: contents),
              const SizedBox(
                height: 88,
              ),
            ]
          : [],
    );
  }
}

class CustomContents extends StatefulWidget {
  CustomContents({Key? key, required this.contents}) : super(key: key);
  List contents;
  @override
  State<CustomContents> createState() => _CustomContentsState();
}

class _CustomContentsState extends State<CustomContents> {
  int num = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              width: 37,
            ),
            Text(
              "지금 우리 ",
              style: _regularStyle,
            ),
            Text("신촌", style: _eBoldStyle),
            Text(
              "은",
              style: _regularStyle,
            ),
          ],
        ),
        const SizedBox(
          height: 25,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.width - 74, // padding 37+37
          child: Swiper(
            //loop: false,
            itemCount: widget.contents.length,
            pagination: null,
            onIndexChanged: (index) {
              setState(() {
                num = index;
              });
            },
            itemBuilder: (BuildContext context, int index) {
              Map targetContents = widget.contents[index];

              return customWidget(targetContents, widget.contents);
            },
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        DotsIndicator(
          dotsCount: 3,
          position: (num % 3).toDouble(),
          decorator: DotsDecorator(
            color: kSecondaryTextColor.withOpacity(0.2),
            activeColor: kSecondaryTextColor.withOpacity(0.7),
            size: const Size.square(10),
            activeSize: const Size(25, 10),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
          ),
        )
      ],
    );
  }

  Widget customWidget(targetContents, List allContents) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 37.0),
      child: GestureDetector(
        onTap: () {
          pushNewScreen(
            context,
            screen: CustomContentsPage(
                titleImage: targetContents["titleImage"],
                images: targetContents["images"],
                title: targetContents["title"],
                subTitle: targetContents["subTitle"],
                icon: targetContents["icon"],
                tag: targetContents["tag"],
                allContents: allContents,
                resIds: targetContents.containsKey("resIds")
                    ? targetContents["resIds"]
                    : []),
          );
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
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 192,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
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
                  style: _regularStyle.copyWith(
                      fontSize: 13, fontWeight: FontWeight.w300),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UnivContents extends StatefulWidget {
  UnivContents({Key? key, required this.contents}) : super(key: key);

  Map contents;

  @override
  State<UnivContents> createState() => _UnivContentsState();
}

class _UnivContentsState extends State<UnivContents> {
  Row univTitle(int univ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(getUniv(univ), style: _eBoldStyle),
        Text(
          "이 요즘 찾는",
          style: _regularStyle,
        ),
      ],
    );
  }

  int userUniv = 1;
  int num = 0;
  Map rankMap = {};
  List imageList = [];

  @override
  void initState() {
    // TODO: implement initState
    userUniv =
        context.read<ProfileState>().user.onboarding["mainLocation"] ?? 1;

    rankMap = context.read<RestaurantsState>().ranking;
    for (var i in ["Yonsei", "Ewha", "Sogang"]) {
      imageList.add(CachedNetworkImage(
        imageUrl: rankMap[i][1]["imgUrl"],
        fit: BoxFit.cover,
        progressIndicatorBuilder: (context, url, downloadProgress) => Container(
          color: Colors.black.withOpacity(0.1),
        ),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ));
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List univList = [1, 2, 3];

    if (userUniv == 2) univList = [2, 3, 1];
    if (userUniv == 3) univList = [3, 1, 2];

    //swipe시 univNum바뀜
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.width + 100,
          child: Swiper(
            itemCount: 3,
            pagination: null,
            onIndexChanged: (index) {
              setState(() {
                num = index;
              });
            },
            itemBuilder: (BuildContext context, int index) {
              Map? res;
              if (univList[index] == 1) {
                res = rankMap["Yonsei"][1];
              } else if (univList[index] == 2) {
                res = rankMap["Ewha"][1];
              } else {
                res = rankMap["Sogang"][1];
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 37.0),
                child: Column(
                  children: [
                    univTitle(univList[index]),
                    const SizedBox(
                      height: 25,
                    ),
                    univImage(context, res, univList[index],
                        imageList[univList[index] - 1]),
                    const SizedBox(
                      height: 14,
                    ),
                    univCard(context, univList[index]),
                  ],
                ),
              );
            },
          ),
        ),
        DotsIndicator(
          dotsCount: 3,
          position: num.toDouble(),
          decorator: DotsDecorator(
            color: kSecondaryTextColor.withOpacity(0.2),
            activeColor: kSecondaryTextColor.withOpacity(0.7),
            size: const Size.square(10),
            activeSize: const Size(25, 10),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
          ),
        )
      ],
    );
  }

  Widget univImage(context, res, univNum, Widget image) {
    return res != null
        ? GestureDetector(
            onTap: () {
              pushNewScreen(context,
                  screen: RestaurantDetailPage(
                      resId: res["resId"].toString(), option: true),
                  withNavBar: false);
            },
            child: Stack(
              children: [
                Center(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 324),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: image),
                    ),
                  ),
                ),
                Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 192,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
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
                      "${resFilterTextsSh[res["category1"]][res["tag1"] + 1]} ${resFilterIcons[res["category1"]][res["tag1"] + 1]}",
                      style: _regularStyle.copyWith(
                          fontSize: 13, fontWeight: FontWeight.w300),
                    )),
                  ),
                ),
                Positioned(
                  left: 27,
                  bottom: 32,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        res["detail"],
                        style: _regularStyle.copyWith(
                            color: Colors.white, fontSize: 14),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        res["name"],
                        style: _regularStyle.copyWith(
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            fontSize: 30),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        : Center(
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 324),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black.withOpacity(0.1),
                ),
              ),
            ),
          );
  }

  Widget univCard(context, int index) {
    Color _color = index == 1
        ? const Color(0xff4169E1)
        : index == 2
            ? const Color(0xff016c41)
            : const Color(0xffa03332);
    String univName = getUniv(index);
    return GestureDetector(
      onTap: () {
        pushNewScreen(context,
            screen: RecommendPlacePage(
              univIndex: index,
            ));
      },
      child: Container(
        clipBehavior: Clip.hardEdge,
        height: 105,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 29,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Icon(
                          Icons.done_rounded,
                          size: 20,
                          color: _color,
                        ),
                      ),
                      Text(
                        univName,
                        style: _regularStyle.copyWith(
                            fontWeight: FontWeight.w900,
                            fontSize: 13,
                            color: _color),
                      ),
                      Text(
                        "과 한그릇이 함께 고른",
                        style: _regularStyle.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    "#여긴꼭가야해",
                    style: _regularStyle.copyWith(
                      fontWeight: FontWeight.w900,
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 20,
              right: -38,
              child: Transform.rotate(
                angle: -7.474,
                child: Container(
                  height: 87.64,
                  width: 143.35,
                  color: kSecondaryTextColor.withOpacity(0.8),
                ),
              ),
            ),
            Positioned(
              top: 46,
              right: 19,
              child: Image.asset(
                'images/icons/arrow_right.png',
                width: 38,
                height: 28,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class UserContents extends StatelessWidget {
  UserContents({Key? key, required this.userContents}) : super(key: key);
  Map userContents;

  @override
  Widget build(BuildContext context) {
    List<Widget> userWidget = [
      const SizedBox(
        width: 37,
      )
    ];
    for (var e in userContents["users"] ?? []) {
      userWidget.add(Padding(
        padding: const EdgeInsets.only(right: 11.0),
        child: GestureDetector(
          onTap: () {
            pushNewScreen(context, screen: OthersProfilePage(userId: e["id"]));
          },
          child: Container(
            width: 213,
            height: 261,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      blurStyle: BlurStyle.outer,
                      offset: const Offset(0, 2),
                      blurRadius: 10,
                      color: Colors.black.withOpacity(0.07))
                ]),
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CachedNetworkImage(
                    imageUrl: e["imgUrl"],
                    fit: BoxFit.cover,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Container(
                      color: Colors.black.withOpacity(0.1),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
                Positioned(
                  top: 175,
                  left: -22,
                  child: ClipOval(
                    clipper: MyClipper(),
                    child: Container(
                      width: 257,
                      height: 130,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              e["name"],
                              style: _eBoldStyle.copyWith(fontSize: 17),
                            ),
                            Text(
                              "의 식탁",
                              style: _regularStyle.copyWith(fontSize: 17),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                    top: 150,
                    left: 80,
                    right: 80,
                    child: ProfileIconBox(content: profileIcons[e["icon"]]))
              ],
            ),
          ),
        ),
      ));
    }
    return Column(
      children: [
        Row(
          children: [
            const SizedBox(
              width: 37,
            ),
            Text(
              "신촌을 빛낸 ",
              style: _regularStyle,
            ),
            Text(
              "한그릇",
              style: _eBoldStyle,
            )
          ],
        ),
        const SizedBox(
          height: 26,
        ),
        SizedBox(
          height: 261,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: userWidget,
          ),
        ),
        const SizedBox(
          height: 100,
        ),
      ],
    );
  }
}

class MyClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    // 하위 요소의 사이즈를 가져오는 메소드
    return Rect.fromLTWH(0, 0, size.width,
        size.height); // 하위 요소의 사이즈에 상관없이 넓이와 높이 사이즈를 200px, 100px로 놓았다.
  }

  @override
  bool shouldReclip(oldClipper) {
    return false;
  }
}
