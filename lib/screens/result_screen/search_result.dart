import 'package:flutter/material.dart';
import 'package:hangeureut/constants.dart';
import 'package:location/location.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/custom_error.dart';
import '../../providers/restaurants/restaurants_state.dart';
import '../../providers/result/result_state.dart';
import '../../repositories/location_repository.dart';
import '../../repositories/restaurant_repository.dart';
import '../../restaurants.dart';
import '../../widgets/error_dialog.dart';
import '../../widgets/res_tile.dart';
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
  TextEditingController textEditingController = TextEditingController();
  late Stream<LocationData?> locationDataStream;
  LocationData? locationData;

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
    locationDataStream = context.read<LocationRepository>().getLocation;
    locationDataStream.listen((event) {
      locationData = event;
    });
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getSearchedRes();
    });
    textEditingController.text = widget.searchTerm;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      padding: EdgeInsets.zero,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 25.0, top: 54),
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () async {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
        searchPageItem(),
      ],
    ));
  }

  Widget searchPageItem() {
    List resTileList = [];
    if (resList == null) {
      resTileList.add(const Center(
        child: Text(
          "검색결과가 없습니다!",
          style: TextStyle(
              fontWeight: FontWeight.w700,
              color: kSecondaryTextColor,
              fontSize: 20,
              fontFamily: 'Suit'),
        ),
      ));
    } else {
      for (var res in resList!) {
        resTileList.add(ResTile(
          mainFilterIndex: res["category1"],
          res: res,
          locationData: locationData,
        ));
      }
    }

    return Stack(
      children: [
        Column(
          children: [
            SearchBox(controller: textEditingController),
            GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.only(top: 29.5, bottom: 60),
                crossAxisCount: 2,
                childAspectRatio: 0.709,
                crossAxisSpacing: 10,
                children: List.generate(
                    resTileList.length, (index) => resTileList[index])),
          ],
        ),
      ],
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

class SearchBox extends StatelessWidget {
  SearchBox({Key? key, required this.controller}) : super(key: key);
  TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 23, top: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              height: 28,
              decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 1, color: kSecondaryTextColor)),
              ),
              child: TextFormField(
                controller: controller,
                style: const TextStyle(
                    fontFamily: 'Suit',
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: kSecondaryTextColor),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "음식 또는 식당으로 검색해보세요.",
                    hintStyle: TextStyle(
                        fontFamily: 'Suit',
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                        color: kSecondaryTextColor)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 21.0),
            child: GestureDetector(
              onTap: () {
                print(controller.text);
                if (controller.text == "") {
                  errorDialog(context,
                      CustomError(code: "알림", message: "검색어는 하나 이상 입력해주세요"));
                  return;
                }
                pushNewScreen(context,
                    screen: SearchResult(
                      searchTerm: controller.text,
                    ));
              },
              child: Image.asset(
                "images/icons/searchbig.png",
                color: kSecondaryTextColor,
                width: 33,
                height: 33,
              ),
            ),
          )
        ],
      ),
    );
  }
}
