import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';
import '../models/custom_error.dart';
import '../providers/distance/distance_provider.dart';
import '../restaurants.dart';
import '../screens/restaurant_detail_screen/restaurant_detail_page.dart';
import 'error_dialog.dart';

class ResTile extends StatefulWidget {
  ResTile(
      {Key? key,
      required this.res,
      required this.mainFilterIndex,
      this.locationData})
      : super(key: key);
  Map res;
  int mainFilterIndex;
  LocationData? locationData;

  @override
  State<ResTile> createState() => _ResTileState();
}

class _ResTileState extends State<ResTile> {
  Future<String> _getDistance() async {
    if (widget.locationData != null) {
      String distance = await context.read<DistanceProvider>().getDistance(
          address: widget.res["address"],
          resId: widget.res["resId"].toString(),
          locationData: widget.locationData!);
      print(distance);
      return distance;
    } else {
      return "-";
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> resInfoTiles = [];
    resInfoTiles = makeTiles(widget.res);
    return GestureDetector(
      onTap: () {
        pushNewScreen(context,
            //option true일 때 error
            screen: RestaurantDetailPage(
              resId: widget.res["resId"].toString(),
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
                  child: CachedNetworkImage(
                    imageUrl: widget.res["imgUrl"],
                    fit: BoxFit.cover,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Container(
                      color: Colors.black.withOpacity(0.1),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
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
                      widget.res["name"],
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
                        FutureBuilder(
                            future: _getDistance(),
                            builder: (BuildContext context,
                                AsyncSnapshot<String> snapshot) {
                              if (!snapshot.hasData) {
                                return const Text(
                                  "-",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: kBasicColor,
                                      fontFamily: 'Suit',
                                      fontSize: 11),
                                );
                              } else {
                                return Text(
                                  snapshot.data!,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: kBasicColor,
                                      fontFamily: 'Suit',
                                      fontSize: 11),
                                );
                              }
                            }),
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: GestureDetector(
                  onTap: () async {
                    final Uri _url = Uri.parse(
                        'https://map.kakao.com/link/to/${widget.res["kakaoId"]}');
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

  List<Widget> makeTiles(res) {
    List<Widget> resInfoList = [];
    if (res["score"] != null)
      resInfoList.add(
        Padding(
          padding: const EdgeInsets.only(right: 4.0),
          child: Container(
            child: Center(
              child: Text(res["score"],
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
              child: Text(
                  resFilterTextsSh[widget.mainFilterIndex][res["tag1"] + 1],
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
              child: Text(
                  resFilterTextsSh[widget.mainFilterIndex][res["tag2"] + 1],
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

Future<void> _launchUrl(url) async {
  if (!await launchUrl(url)) {
    throw 'Could not launch $url';
  }
}
