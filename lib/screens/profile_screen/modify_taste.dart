import 'package:flutter/material.dart';
import 'package:hangeureut/constants.dart';
import 'package:hangeureut/models/custom_error.dart';
import 'package:hangeureut/providers/profile/profile_provider.dart';
import 'package:hangeureut/widgets/error_dialog.dart';
import 'package:provider/provider.dart';

import '../../providers/profile/profile_state.dart';
import '../../widgets/bottom_navigation_bar.dart';

class ModifyTaste extends StatefulWidget {
  const ModifyTaste({Key? key}) : super(key: key);
  static const String routeName = '/onboarding2';

  @override
  State<ModifyTaste> createState() => ModifyTasteState();
}

const _keyWordList = [
  "taste_baby",
  "taste_grandmother",
  "taste_daddy",
  "taste_bread",
  "taste_rice",
  "taste_visual",
  "taste_raw",
  "taste_meat",
  "taste_diet",
  "taste_spicy1",
  "taste_spicy2",
  "taste_sweet",
];

const alcoholTypeList = [
  "alcohol_soju",
  "alcohol_beer",
  "alcohol_liquor",
  "alcohol_traditional",
  "alcohol_wine",
  "alcohol_cocktail"
];

//우선 온보딩 정보를 프로바이더를 통해 가져온다음, 그것을 업데이트하는 코드를 짜야함
//온보딩 정보가 null이거나 빈 map일 경우에는 새로등록
class ModifyTasteState extends State<ModifyTaste> {
  Map alcoholType = {};
  Map tasteKeyword = {};
  Map onboarding = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    onboarding = context.read<ProfileState>().user.onboarding;

    alcoholType =
        onboarding["alcoholType"] ?? onboarding_initial["alcoholType"];
    tasteKeyword =
        onboarding["tasteKeyword"] ?? onboarding_initial["tasteKeyword"];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: BasicBottomPopBar(
          option1: "취소",
          option2: "완료",
          withNav2: () async {
            onboarding["alcoholType"] = alcoholType;
            onboarding["tasteKeyword"] = tasteKeyword;
            try {
              await context
                  .read<ProfileProvider>()
                  .setOnboarding(onboarding: onboarding);
            } on CustomError catch (e) {
              errorDialog(context, e);
              return false;
            }
            return true;
          },
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  height: 84,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 33.0),
                  child: Text(
                    "입맛 프로필",
                    style: TextStyle(
                        fontFamily: 'Suit',
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(
                  height: 48,
                  child: Divider(
                    color: kBorderGreenColor.withOpacity(0.5),
                  ),
                ),
                const SizedBox(height: 10.5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 33.0),
                  child: subTitleRow(
                      "images/icons/favorite.png", "입맛 키워드", "*2개 이상"),
                ),
                const SizedBox(
                  height: 14,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 29),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          RoundedButton(
                              height: 39,
                              iconPath:
                                  "$tasteProfileIconPath/${_keyWordList[0]}.png",
                              text: "애기입맛",
                              onTap: () {
                                setState(() {
                                  tasteKeyword[_keyWordList[0]] =
                                      !tasteKeyword[_keyWordList[0]];
                                });
                              },
                              selected: tasteKeyword[_keyWordList[0]]),
                          RoundedButton(
                              height: 39,
                              iconPath:
                                  "$tasteProfileIconPath/${_keyWordList[1]}.png",
                              text: "할매입맛",
                              onTap: () {
                                setState(() {
                                  tasteKeyword[_keyWordList[1]] =
                                      !tasteKeyword[_keyWordList[1]];
                                });
                              },
                              selected: tasteKeyword[_keyWordList[1]]),
                          RoundedButton(
                              height: 39,
                              iconPath:
                                  "$tasteProfileIconPath/${_keyWordList[2]}.png",
                              text: "아재입맛",
                              onTap: () {
                                setState(() {
                                  tasteKeyword[_keyWordList[2]] =
                                      !tasteKeyword[_keyWordList[2]];
                                });
                              },
                              selected: tasteKeyword[_keyWordList[2]]),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          RoundedButton(
                              height: 39,
                              iconPath:
                                  "$tasteProfileIconPath/${_keyWordList[3]}.png",
                              text: "빵순이",
                              onTap: () {
                                setState(() {
                                  tasteKeyword[_keyWordList[3]] =
                                      !tasteKeyword[_keyWordList[3]];
                                });
                              },
                              selected: tasteKeyword[_keyWordList[3]]),
                          RoundedButton(
                              height: 39,
                              iconPath:
                                  "$tasteProfileIconPath/${_keyWordList[4]}.png",
                              text: "밥순이",
                              onTap: () {
                                setState(() {
                                  tasteKeyword[_keyWordList[4]] =
                                      !tasteKeyword[_keyWordList[4]];
                                });
                              },
                              selected: tasteKeyword[_keyWordList[4]]),
                          RoundedButton(
                              height: 39,
                              iconPath:
                                  "$tasteProfileIconPath/${_keyWordList[5]}.png",
                              text: "눈으로 먹어요",
                              onTap: () {
                                setState(() {
                                  tasteKeyword[_keyWordList[5]] =
                                      !tasteKeyword[_keyWordList[5]];
                                });
                              },
                              selected: tasteKeyword[_keyWordList[5]]),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          RoundedButton(
                              height: 39,
                              iconPath:
                                  "$tasteProfileIconPath/${_keyWordList[6]}.png",
                              text: "날 것 좋아",
                              onTap: () {
                                setState(() {
                                  tasteKeyword[_keyWordList[6]] =
                                      !tasteKeyword[_keyWordList[6]];
                                });
                              },
                              selected: tasteKeyword[_keyWordList[6]]),
                          RoundedButton(
                              height: 39,
                              iconPath:
                                  "$tasteProfileIconPath/${_keyWordList[7]}.png",
                              text: "고기 좋아",
                              onTap: () {
                                setState(() {
                                  tasteKeyword[_keyWordList[7]] =
                                      !tasteKeyword[_keyWordList[7]];
                                });
                              },
                              selected: tasteKeyword[_keyWordList[7]]),
                          RoundedButton(
                              height: 39,
                              iconPath:
                                  "$tasteProfileIconPath/${_keyWordList[8]}.png",
                              text: "건강 챙겨",
                              onTap: () {
                                setState(() {
                                  tasteKeyword[_keyWordList[8]] =
                                      !tasteKeyword[_keyWordList[8]];
                                });
                              },
                              selected: tasteKeyword[_keyWordList[8]]),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          RoundedButton(
                              height: 39,
                              iconPath:
                                  "$tasteProfileIconPath/${_keyWordList[9]}.png",
                              text: "맵찔이",
                              onTap: () {
                                setState(() {
                                  tasteKeyword[_keyWordList[9]] =
                                      !tasteKeyword[_keyWordList[9]];
                                });
                              },
                              selected: tasteKeyword[_keyWordList[9]]),
                          RoundedButton(
                              height: 39,
                              iconPath:
                                  "$tasteProfileIconPath/${_keyWordList[10]}.png",
                              text: "맵고수",
                              onTap: () {
                                setState(() {
                                  tasteKeyword[_keyWordList[10]] =
                                      !tasteKeyword[_keyWordList[10]];
                                });
                              },
                              selected: tasteKeyword[_keyWordList[10]]),
                          RoundedButton(
                              height: 39,
                              iconPath:
                                  "$tasteProfileIconPath/${_keyWordList[11]}.png",
                              text: "달달구리 좋아",
                              onTap: () {
                                setState(() {
                                  tasteKeyword[_keyWordList[11]] =
                                      !tasteKeyword[_keyWordList[11]];
                                });
                              },
                              selected: tasteKeyword[_keyWordList[11]]),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 56,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 33.0),
                  child: subTitleRow(
                      "images/icons/favorite.png", "좋아하는 주종", "*1개 이상"),
                ),
                const SizedBox(
                  height: 14,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 29),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          RoundedAlcoholButton(
                              height: 39,
                              iconPath:
                                  "$tasteProfileIconPath/${alcoholTypeList[0]}.png",
                              text: "소주",
                              onTap: () {
                                setState(() {
                                  alcoholType[alcoholTypeList[0]] =
                                      !alcoholType[alcoholTypeList[0]];
                                });
                              },
                              selected: alcoholType[alcoholTypeList[0]]),
                          RoundedAlcoholButton(
                              height: 39,
                              iconPath:
                                  "$tasteProfileIconPath/${alcoholTypeList[1]}.png",
                              text: "맥주",
                              onTap: () {
                                setState(() {
                                  alcoholType[alcoholTypeList[1]] =
                                      !alcoholType[alcoholTypeList[1]];
                                });
                              },
                              selected: alcoholType[alcoholTypeList[1]]),
                          RoundedAlcoholButton(
                              height: 39,
                              iconPath:
                                  "$tasteProfileIconPath/${alcoholTypeList[2]}.png",
                              text: "양주",
                              onTap: () {
                                setState(() {
                                  alcoholType[alcoholTypeList[2]] =
                                      !alcoholType[alcoholTypeList[2]];
                                });
                              },
                              selected: alcoholType[alcoholTypeList[2]]),
                        ],
                      ),
                      Row(
                        children: [
                          RoundedAlcoholButton(
                              height: 39,
                              iconPath:
                                  "$tasteProfileIconPath/${alcoholTypeList[3]}.png",
                              text: "전통주",
                              onTap: () {
                                setState(() {
                                  alcoholType[alcoholTypeList[3]] =
                                      !alcoholType[alcoholTypeList[3]];
                                });
                              },
                              selected: alcoholType[alcoholTypeList[3]]),
                          RoundedAlcoholButton(
                              height: 39,
                              iconPath:
                                  "$tasteProfileIconPath/${alcoholTypeList[4]}.png",
                              text: "와인",
                              onTap: () {
                                setState(() {
                                  alcoholType[alcoholTypeList[4]] =
                                      !alcoholType[alcoholTypeList[4]];
                                });
                              },
                              selected: alcoholType[alcoholTypeList[4]]),
                          RoundedAlcoholButton(
                              height: 39,
                              iconPath:
                                  "$tasteProfileIconPath/${alcoholTypeList[5]}.png",
                              text: "칵테일",
                              onTap: () {
                                setState(() {
                                  alcoholType[alcoholTypeList[5]] =
                                      !alcoholType[alcoholTypeList[5]];
                                });
                              },
                              selected: alcoholType[alcoholTypeList[5]]),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget subTitleRow(iconPath, text, subText) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          Image.asset(
            iconPath,
            height: 22,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            text,
            style: const TextStyle(
                fontFamily: 'Suit', fontWeight: FontWeight.w400, fontSize: 14),
          ),
        ],
      ),
      Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: Text(
          subText,
          style: const TextStyle(
              fontFamily: 'Suit',
              fontWeight: FontWeight.w400,
              fontSize: 8.5,
              color: kSecondaryTextColor),
        ),
      ),
    ],
  );
}

class RoundedButton extends StatelessWidget {
  const RoundedButton(
      {Key? key,
      required this.iconPath,
      required this.text,
      required this.onTap,
      required this.selected,
      required double this.height})
      : super(key: key);
  final iconPath;
  final text;
  final onTap;
  final selected;
  final height;
  int _flexWidth(num) {
    if (num <= 3) {
      return 94;
    } else if (4 <= num && num <= 5) {
      return 104;
    } else {
      return 122;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: _flexWidth(text.length),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            height: height,
            decoration: BoxDecoration(
              color: selected ? kBasicColor : Colors.white,
              boxShadow: [
                BoxShadow(
                    color: kBasicColor.withOpacity(0.3),
                    blurRadius: 3,
                    spreadRadius: 0,
                    offset: const Offset(
                      0,
                      1,
                    )),
              ],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    iconPath,
                    height: 18,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    text,
                    style: TextStyle(
                        fontFamily: 'Suit',
                        fontWeight:
                            selected ? FontWeight.w500 : FontWeight.w300,
                        fontSize: 13,
                        color: selected ? Colors.white : Colors.black),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RoundedAlcoholButton extends StatelessWidget {
  const RoundedAlcoholButton(
      {Key? key,
      required this.iconPath,
      required this.text,
      required this.onTap,
      required this.selected,
      required double this.height})
      : super(key: key);
  final iconPath;
  final text;
  final onTap;
  final selected;
  final height;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
          child: Container(
            height: height,
            decoration: BoxDecoration(
              color: selected ? kBasicColor : Colors.white,
              boxShadow: [
                BoxShadow(
                    color: kBasicColor.withOpacity(0.3),
                    blurRadius: 3,
                    spreadRadius: 0,
                    offset: const Offset(
                      0,
                      1,
                    )),
              ],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    iconPath,
                    height: 15,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    text,
                    style: TextStyle(
                        fontFamily: 'Suit',
                        fontWeight:
                            selected ? FontWeight.w500 : FontWeight.w300,
                        fontSize: 13,
                        color: selected ? Colors.white : Colors.black),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
