import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:hangeureut/constants.dart';
import 'package:hangeureut/providers/restaurants/restaurants_state.dart';
import 'package:hangeureut/providers/result/result_state.dart';
import 'package:hangeureut/repositories/restaurant_repository.dart';
import 'package:location/location.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/custom_error.dart';
import '../../restaurants.dart';
import '../../widgets/error_dialog.dart';
import '../../widgets/res_tile.dart';
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

  Map _getShowingRes(thisUniv) {
    Map rankMap = context.read<RestaurantsState>().ranking;
    if (thisUniv == 1) {
      return rankMap["Yonsei"];
    } else if (thisUniv == 2) {
      return rankMap["Ewha"];
    } else {
      return rankMap["Sogang"];
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    thisUniv = widget.univIndex;
    if (widget.univIndex == 2) univList = [2, 3, 1];
    if (widget.univIndex == 3) univList = [3, 1, 2];
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
            resMap: _getShowingRes(thisUniv),
          )
        ],
      ),
    );
  }
}

class UnivRestaurants extends StatelessWidget {
  UnivRestaurants({Key? key, required this.resMap}) : super(key: key);
  Map resMap;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.only(top: 29.5, bottom: 60),
        crossAxisCount: 2,
        childAspectRatio: 0.709,
        crossAxisSpacing: 10,
        children: List.generate(
            resMap.length,
            (index) => ResTile(
                  res: resMap[index + 1]!,
                  mainFilterIndex: resMap[index + 1]!["category1"],
                )));
  }
}
