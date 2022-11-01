import 'package:flutter/material.dart';
import 'package:hangeureut/constants.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/custom_error.dart';
import '../../providers/restaurants/restaurants_state.dart';
import '../../providers/result/result_state.dart';
import '../../repositories/restaurant_repository.dart';
import '../../restaurants.dart';
import '../../widgets/error_dialog.dart';
import '../restaurant_detail_screen/restaurant_detail_page.dart';

class SearchResult extends StatefulWidget {
  SearchResult({Key? key, required this.searchTerm}) : super(key: key);
  static const String routeName = "/search_result";

  String searchTerm;

  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  List? resList;
  Future<void> _launchUrl(url) async {
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }

  Future<void> _getSearchedRes() async {
    try {
      resList = await context
          .read<RestaurantRepository>()
          .getSearchedRestaurants(searchTerm: widget.searchTerm);

      setState(() {});
    } on CustomError catch (e) {
      Navigator.pop(context);
      errorDialog(context, e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getSearchedRes();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: searchPageItem());
  }

  Widget searchPageItem() {
    List resTileList = [];
    if (resList == null) {
      return const Center(
        child: CircularProgressIndicator(
          color: kBasicColor,
          strokeWidth: 2,
        ),
      );
    } else {
      resTileList = resList!.map((e) => resTile(e)).toList();
    }

    return Stack(
      children: [
        GridView.count(
            physics: ClampingScrollPhysics(),
            padding: EdgeInsets.only(top: 29.5, bottom: 60),
            crossAxisCount: 2,
            childAspectRatio: 0.709,
            crossAxisSpacing: 10,
            children: List.generate(
                resTileList.length, (index) => resTileList[index])),
      ],
    );
  }

  Widget resTile(Map res) {
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
                  child: Image.network(
                    res["imgUrl"],
                    fit: BoxFit.cover,
                    loadingBuilder: (context, widget, _) {
                      return Container(
                        color: Colors.black.withOpacity(0.1),
                        child: widget,
                      );
                    },
                    errorBuilder: (context, widget, _) {
                      return Container(
                        color: Colors.black.withOpacity(0.1),
                      );
                    },
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
                      style: const TextStyle(
                          height: 1.357,
                          fontWeight: FontWeight.w900,
                          color: kSecondaryTextColor,
                          fontFamily: 'Suit',
                          fontSize: 14),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Row(
                      children: [
                        const Text(
                          "지금 내 위치에서 ",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: kSecondaryTextColor,
                              fontFamily: 'Suit',
                              fontSize: 11),
                        ),
                        Text(
                          "${res["distance"] ?? "?"}m",
                          style: const TextStyle(
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

  Container loadingContainer() {
    return Container(
      color: Colors.grey,
    );
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
}
