import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';
import '../models/custom_error.dart';
import '../restaurants.dart';
import '../screens/restaurant_detail_screen/restaurant_detail_page.dart';
import 'error_dialog.dart';

class ResTile extends StatefulWidget {
  ResTile({
    Key? key,
    required this.res,
    required this.mainFilterIndex,
  }) : super(key: key);
  Map res;
  int mainFilterIndex;

  @override
  State<ResTile> createState() => _ResTileState();
}

class _ResTileState extends State<ResTile> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                    progressIndicatorBuilder: (context, _, __) {
                      return Container(
                        color: Colors.black.withOpacity(0.1),
                      );
                    },
                    errorWidget: (_, __, ___) {
                      return Image.asset(
                        "images/error_tile.png",
                        fit: BoxFit.cover,
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
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
                      Text(
                        widget.res["detail"],
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.143,
                            color: kSecondaryTextColor.withOpacity(0.6),
                            fontFamily: 'Suit',
                            fontSize: 11),
                      )
                    ],
                  ),
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
                      final ec = const CustomError(
                          code: '', message: '카카오맵을 열 수 없습니다');
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
                  style: const TextStyle(
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
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Center(
              child: Text(
                  resFilterTextsSh[widget.mainFilterIndex][res["tag1"] + 1],
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
    if (res["tag2"] != null && res["tag2"] != -1) {
      resInfoList.add(
        Padding(
          padding: const EdgeInsets.only(right: 4.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
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
