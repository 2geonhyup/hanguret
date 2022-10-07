import 'package:flutter/material.dart';
import 'package:hangeureut/constants.dart';
import 'package:hangeureut/models/custom_error.dart';
import 'package:hangeureut/providers/profile/profile_provider.dart';
import 'package:hangeureut/widgets/error_dialog.dart';
import 'package:hangeureut/widgets/progress_bar.dart';
import 'package:provider/provider.dart';

import '../../providers/profile/profile_state.dart';
import '../../widgets/bottom_navigation_bar.dart';
import 'on_boarding1_page.dart';
import 'on_boarding2_view.dart';
import 'on_boarding3_page.dart';

class OnBoarding2Page extends StatefulWidget {
  const OnBoarding2Page({Key? key}) : super(key: key);
  static const String routeName = '/onboarding2';

  @override
  State<OnBoarding2Page> createState() => OnBoarding2PageState();
}

const keyWordList = [
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
class OnBoarding2PageState extends State<OnBoarding2Page> {
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
    print(tasteKeyword);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: BasicBottomNavigationBar(
          option1: "취소",
          option2: "다음",
          nav1: OnBoarding1Page.routeName,
          nav2: OnBoarding3Page.routeName,
          withNav2: () async {
            onboarding["alcoholType"] = alcoholType;
            onboarding["tasteKeyword"] = tasteKeyword;
            onboarding["level"] = 2;
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
                SizedBox(
                  height: 84,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 33.0),
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
                SizedBox(height: 10.5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 33.0),
                  child: subTitleRow(
                      "images/icons/favorite.png", "입맛 키워드", "*2개 이상"),
                ),
                SizedBox(
                  height: 14,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 29),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          RoundedButton(
                              height: 39,
                              iconPath:
                                  "${tasteProfileIconPath}/${keyWordList[0]}.png",
                              text: "애기입맛",
                              onTap: () {
                                setState(() {
                                  tasteKeyword[keyWordList[0]] =
                                      !tasteKeyword[keyWordList[0]];
                                });
                              },
                              selected: tasteKeyword[keyWordList[0]]),
                          RoundedButton(
                              height: 39,
                              iconPath:
                                  "${tasteProfileIconPath}/${keyWordList[1]}.png",
                              text: "할매입맛",
                              onTap: () {
                                setState(() {
                                  tasteKeyword[keyWordList[1]] =
                                      !tasteKeyword[keyWordList[1]];
                                });
                              },
                              selected: tasteKeyword[keyWordList[1]]),
                          RoundedButton(
                              height: 39,
                              iconPath:
                                  "${tasteProfileIconPath}/${keyWordList[2]}.png",
                              text: "아재입맛",
                              onTap: () {
                                setState(() {
                                  tasteKeyword[keyWordList[2]] =
                                      !tasteKeyword[keyWordList[2]];
                                });
                              },
                              selected: tasteKeyword[keyWordList[2]]),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          RoundedButton(
                              height: 39,
                              iconPath:
                                  "${tasteProfileIconPath}/${keyWordList[3]}.png",
                              text: "빵순이",
                              onTap: () {
                                setState(() {
                                  tasteKeyword[keyWordList[3]] =
                                      !tasteKeyword[keyWordList[3]];
                                });
                              },
                              selected: tasteKeyword[keyWordList[3]]),
                          RoundedButton(
                              height: 39,
                              iconPath:
                                  "${tasteProfileIconPath}/${keyWordList[4]}.png",
                              text: "밥순이",
                              onTap: () {
                                setState(() {
                                  tasteKeyword[keyWordList[4]] =
                                      !tasteKeyword[keyWordList[4]];
                                });
                              },
                              selected: tasteKeyword[keyWordList[4]]),
                          RoundedButton(
                              height: 39,
                              iconPath:
                                  "${tasteProfileIconPath}/${keyWordList[5]}.png",
                              text: "눈으로 먹어요",
                              onTap: () {
                                setState(() {
                                  tasteKeyword[keyWordList[5]] =
                                      !tasteKeyword[keyWordList[5]];
                                });
                              },
                              selected: tasteKeyword[keyWordList[5]]),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          RoundedButton(
                              height: 39,
                              iconPath:
                                  "${tasteProfileIconPath}/${keyWordList[6]}.png",
                              text: "날 것 좋아",
                              onTap: () {
                                setState(() {
                                  tasteKeyword[keyWordList[6]] =
                                      !tasteKeyword[keyWordList[6]];
                                });
                              },
                              selected: tasteKeyword[keyWordList[6]]),
                          RoundedButton(
                              height: 39,
                              iconPath:
                                  "${tasteProfileIconPath}/${keyWordList[7]}.png",
                              text: "고기 좋아",
                              onTap: () {
                                setState(() {
                                  tasteKeyword[keyWordList[7]] =
                                      !tasteKeyword[keyWordList[7]];
                                });
                              },
                              selected: tasteKeyword[keyWordList[7]]),
                          RoundedButton(
                              height: 39,
                              iconPath:
                                  "${tasteProfileIconPath}/${keyWordList[8]}.png",
                              text: "건강 챙겨",
                              onTap: () {
                                setState(() {
                                  tasteKeyword[keyWordList[8]] =
                                      !tasteKeyword[keyWordList[8]];
                                });
                              },
                              selected: tasteKeyword[keyWordList[8]]),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          RoundedButton(
                              height: 39,
                              iconPath:
                                  "${tasteProfileIconPath}/${keyWordList[9]}.png",
                              text: "맵찔이",
                              onTap: () {
                                setState(() {
                                  tasteKeyword[keyWordList[9]] =
                                      !tasteKeyword[keyWordList[9]];
                                });
                              },
                              selected: tasteKeyword[keyWordList[9]]),
                          RoundedButton(
                              height: 39,
                              iconPath:
                                  "${tasteProfileIconPath}/${keyWordList[10]}.png",
                              text: "맵고수",
                              onTap: () {
                                setState(() {
                                  tasteKeyword[keyWordList[10]] =
                                      !tasteKeyword[keyWordList[10]];
                                });
                              },
                              selected: tasteKeyword[keyWordList[10]]),
                          RoundedButton(
                              height: 39,
                              iconPath:
                                  "${tasteProfileIconPath}/${keyWordList[11]}.png",
                              text: "달달구리 좋아",
                              onTap: () {
                                setState(() {
                                  tasteKeyword[keyWordList[11]] =
                                      !tasteKeyword[keyWordList[11]];
                                });
                              },
                              selected: tasteKeyword[keyWordList[11]]),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 56,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 33.0),
                  child: subTitleRow(
                      "images/icons/favorite.png", "좋아하는 주종", "*1개 이상"),
                ),
                SizedBox(
                  height: 14,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 29),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          RoundedAlcoholButton(
                              height: 39,
                              iconPath:
                                  "${tasteProfileIconPath}/${alcoholTypeList[0]}.png",
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
                                  "${tasteProfileIconPath}/${alcoholTypeList[1]}.png",
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
                                  "${tasteProfileIconPath}/${alcoholTypeList[2]}.png",
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
                                  "${tasteProfileIconPath}/${alcoholTypeList[3]}.png",
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
                                  "${tasteProfileIconPath}/${alcoholTypeList[4]}.png",
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
                                  "${tasteProfileIconPath}/${alcoholTypeList[5]}.png",
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
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: ProgressBar(level: 2),
            ),
          ],
        ),
      ),
    );
  }
}
