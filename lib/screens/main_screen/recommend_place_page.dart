import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:hangeureut/constants.dart';
import 'package:hangeureut/repositories/restaurant_repository.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/custom_error.dart';
import '../../restaurants.dart';
import '../../widgets/error_dialog.dart';
import '../restaurant_detail_screen/restaurant_detail_page.dart';

Future<void> _launchUrl(url) async {
  if (!await launchUrl(url)) {
    throw 'Could not launch $url';
  }
}

String getUniv(univ) {
  String result = "";
  univ == 1
      ? result = "연대생"
      : univ == 2
          ? result = "이대생"
          : result = "서강대생";
  return result;
}

String getUnivEng(univ) {
  String result = "";
  univ == 1
      ? result = "YONSEI"
      : univ == 2
          ? result = "EWHA"
          : result = "SOGANG";
  return result;
}

TextStyle _regularStyle = const TextStyle(
    fontFamily: 'Suit',
    fontWeight: FontWeight.w400,
    fontSize: 13,
    color: kSecondaryTextColor,
    height: 1);

TextStyle _eBoldStyle = const TextStyle(
    fontFamily: 'Suit', fontWeight: FontWeight.w800, fontSize: 13, height: 1);

class RecommendPlacePage extends StatefulWidget {
  RecommendPlacePage({Key? key, required this.univIndex}) : super(key: key);
  int univIndex;

  @override
  State<RecommendPlacePage> createState() => _RecommendPlacePageState();
}

class _RecommendPlacePageState extends State<RecommendPlacePage> {
  List univList = [1, 2, 3];
  int thisUniv = 0;
  List? allRes;

  Future<void> _getAllRes() async {
    allRes = await context.read<RestaurantRepository>().getResByPopularity();
  }

  List _getShowingRes() {
    List showingRes = [];
    String _univName = getUnivEng(thisUniv);
    print("sow$_univName");
    if (allRes != null) {
      for (var res in allRes!) {
        if (_univName == res["univ"]) {
          print(res["univ"]);
          showingRes.add(res);
        }
      }
    }
    return showingRes;
  }

  @override
  void initState() {
    // TODO: implement initState
    thisUniv = widget.univIndex;
    if (widget.univIndex == 2) univList = [2, 3, 1];
    if (widget.univIndex == 3) univList = [3, 1, 2];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getAllRes();
      _getShowingRes();
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 15,
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 255,
                child: Swiper(
                  onIndexChanged: (index) {
                    setState(() {
                      thisUniv = univList[index];
                    });
                  },
                  itemCount: 3,
                  pagination: null,
                  physics: ClampingScrollPhysics(),
                  viewportFraction: 0.7,
                  scale: 1,
                  itemBuilder: (BuildContext context, int index) {
                    int _thisUniv = univList[index];
                    Color _color = _thisUniv == 1
                        ? const Color(0xff4169E1)
                        : _thisUniv == 2
                            ? const Color(0xff016c41)
                            : const Color(0xffa03332);
                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 6.0, right: 6.0, bottom: 28),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(0, 1),
                                  blurRadius: 17,
                                  color: Colors.black.withOpacity(0.1),
                                  blurStyle: BlurStyle.outer)
                            ]),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 47,
                            ),
                            Image.asset(
                              _thisUniv == 1
                                  ? "images/ring_round_y.png"
                                  : _thisUniv == 2
                                      ? "images/ring_round_e.png"
                                      : "images/ring_round_s.png",
                              width: 77,
                              height: 77,
                            ),
                            SizedBox(
                              height: 14,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  getUniv(_thisUniv),
                                  style: _eBoldStyle.copyWith(color: _color),
                                ),
                                Text(
                                  "과 한그릇이 함께 고른",
                                  style: _regularStyle,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 7,
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
                    );
                  },
                ),
              ),
              Positioned(
                  left: 34,
                  top: 39,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: SizedBox(
                      height: 18,
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: kBasicTextColor.withOpacity(0.8),
                      ),
                    ),
                  )),
            ],
          ),
          UnivRestaurants(
            resList: _getShowingRes(),
          )
        ],
      ),
    );
  }
}

class UnivRestaurants extends StatelessWidget {
  UnivRestaurants({Key? key, required this.resList}) : super(key: key);
  List resList;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.only(top: 29.5, bottom: 60),
        crossAxisCount: 2,
        childAspectRatio: 0.709,
        crossAxisSpacing: 10,
        children: resList.map((e) => _ResTile(res: e)).toList());
  }
}

class _ResTile extends StatelessWidget {
  _ResTile({Key? key, required this.res}) : super(key: key);
  Map res;

  @override
  Widget build(BuildContext context) {
    List<Widget> resInfoTiles = [];
    resInfoTiles = makeTiles(res);
    return GestureDetector(
      onTap: () {
        pushNewScreen(context,
            //option true일 때 error

            screen: RestaurantDetailPage(
              resId: res["resId"].toString(),
              option: true,
            ),
            withNavBar: false);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Container(
                  width: double.infinity,
                  child: Image.asset(
                    res["imgUrl"],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                left: 12,
                top: 12,
                child: Row(
                  children: resInfoTiles,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 13,
                    ),
                    Text(
                      res["name"],
                      style: TextStyle(
                          height: 1.357,
                          fontWeight: FontWeight.w900,
                          color: kSecondaryTextColor,
                          fontFamily: 'Suit',
                          fontSize: 14),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Row(
                      children: [
                        Text(
                          "지금 내 위치에서 ",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: kSecondaryTextColor,
                              fontFamily: 'Suit',
                              fontSize: 11),
                        ),
                        Text(
                          "${res["distance"]}m",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: kBasicColor,
                              fontFamily: 'Suit',
                              fontSize: 11),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: GestureDetector(
                  onTap: () async {
                    final Uri _url = Uri.parse(
                        'https://map.kakao.com/link/to/${res["kakaoId"]}');
                    try {
                      await _launchUrl(_url);
                    } catch (e) {
                      print(e);
                      final ec =
                          CustomError(code: '', message: '카카오맵을 열 수 없습니다');
                      errorDialog(context, ec);
                    }
                  },
                  child: Image.asset(
                    "images/location-marker.png",
                    width: 25,
                    height: 25,
                    color: kBasicColor,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

List<Widget> makeTiles(res) {
  List<Widget> resInfoList = [];
  if (res["score"] != null)
    resInfoList.add(
      Padding(
        padding: const EdgeInsets.only(right: 4.0),
        child: Container(
          child: Center(
            child: Text(res["score"].toString(),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Suit')),
          ),
          width: 36,
          height: 22,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  if (res["tag1"] != null)
    resInfoList.add(
      Padding(
        padding: const EdgeInsets.only(right: 4.0),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Center(
            child: Text(resFilterTextsSh[res["category1"]][res["tag1"] + 1],
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Suit')),
          ),
          height: 22,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  if (res["tag2"] != null) {
    resInfoList.add(
      Padding(
        padding: const EdgeInsets.only(right: 4.0),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Center(
            child: Text(resFilterTextsSh[res["category1"]][res["tag2"] + 1],
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Suit')),
          ),
          height: 22,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
  return resInfoList;
}
