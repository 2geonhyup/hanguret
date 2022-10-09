import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:hangeureut/constants.dart';

String getUniv(univ) {
  String result = "";
  univ == 1
      ? result = "연대생"
      : univ == 2
          ? result = "이대생"
          : result = "서강대생";
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

class RecommendPlacePage extends StatelessWidget {
  RecommendPlacePage({Key? key, required this.univIndex}) : super(key: key);
  int univIndex;
  List univList = [1, 2, 3];

  @override
  Widget build(BuildContext context) {
    if (univIndex == 2) univList = [2, 3, 1];
    if (univIndex == 3) univList = [3, 1, 2];
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Container(
                height: 255,
                child: Swiper(
                  itemCount: 3,
                  pagination: null,
                  physics: ClampingScrollPhysics(),
                  viewportFraction: 0.63,
                  scale: 1,
                  itemBuilder: (BuildContext context, int index) {
                    int thisUniv = univList[index];
                    Color _color = thisUniv == 1
                        ? const Color(0xff4169E1)
                        : thisUniv == 2
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
                              thisUniv == 1
                                  ? "images/ring_round_y.png"
                                  : thisUniv == 2
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
                                  getUniv(thisUniv),
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
            ],
          ),
          Positioned(
              left: 34,
              top: 54,
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
    );
  }
}
