import 'package:flutter/material.dart';
import 'package:hangeureut/constants.dart';
import 'package:hangeureut/providers/profile/profile_provider.dart';
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

//우선 온보딩 정보를 프로바이더를 통해 가져온다음, 그것을 업데이트하는 코드를 짜야함
//온보딩 정보가 null이거나 빈 map일 경우에는 새로등록
class OnBoarding2PageState extends State<OnBoarding2Page> {
  String spicyLevel = "0";
  Map favoriteFoods = {};
  Map hateFoods = {};
  Map onboarding = {};
  Map originFavorite = {};
  Map originHate = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    onboarding = context.read<ProfileState>().user.onboarding;
    print(onboarding);
    spicyLevel = onboarding["spicyLevel"] ?? "0";
    favoriteFoods = onboarding["favoriteFoods"] ?? {};
    hateFoods = onboarding["hateFoods"] ?? {};
    originFavorite = favoriteFoods;
    originHate = hateFoods;
  }

  @override
  Widget build(BuildContext context) {
    print(originFavorite["1"]);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: BasicBottomNavigationBar(
          option1: "취소",
          option2: "다음",
          nav1: OnBoarding1Page.routeName,
          nav2: OnBoarding3Page.routeName,
          withNav2: () {
            onboarding["favoriteFoods"] = favoriteFoods;
            onboarding["hateFoods"] = hateFoods;
            onboarding["spicyLevel"] = spicyLevel;
            onboarding["level"] = 2;
            context
                .read<ProfileProvider>()
                .setOnboarding(onboarding: onboarding);
          },
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  padding: const EdgeInsets.symmetric(horizontal: 21.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FoodInputField(
                        title: "좋아하는 음식",
                        hintText: "음식 이름",
                        initialVal:
                            originFavorite == {} ? null : originFavorite["1"],
                        onSubmit: (val) {
                          if (val != null) {
                            setState(() {
                              favoriteFoods["1"] = val;
                            });
                          }
                        },
                      ),
                      FoodInputField(
                        initialVal: originHate == {} ? null : originHate["1"],
                        title: "싫어하는 음식",
                        hintText: "음식 이름",
                        onSubmit: (val) {
                          if (val != null) {
                            setState(() {
                              hateFoods["1"] = val;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 65,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 33.0),
                  child: subTitleRow(
                      "images/icons/exclamation.png",
                      "매운맛 레벨",
                      spicyLevel == "0"
                          ? ""
                          : spicyLevelText[int.parse(spicyLevel) - 1]),
                ),
                SizedBox(
                  height: 18,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 33),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SpicyLevelButton(
                        image: "images/icons/spicy1.png",
                        text: "맵찔이",
                        onPressed: () {
                          setState(() {
                            if (spicyLevel == "1") {
                              spicyLevel = "0";
                              return;
                            }
                            spicyLevel = "1";
                            FocusScope.of(context).unfocus();
                          });
                        },
                        clicked: spicyLevel == "1",
                      ),
                      SpicyLevelButton(
                        image: "images/icons/spicy2.png",
                        text: "맵초딩",
                        onPressed: () {
                          setState(() {
                            if (spicyLevel == "2") {
                              spicyLevel = "0";
                              return;
                            }
                            spicyLevel = "2";
                            FocusScope.of(context).unfocus();
                          });
                        },
                        clicked: spicyLevel == "2",
                      ),
                      SpicyLevelButton(
                        image: "images/icons/spicy3.png",
                        text: "맵고수",
                        onPressed: () {
                          setState(() {
                            if (spicyLevel == "3") {
                              spicyLevel = "0";
                              return;
                            }
                            spicyLevel = "3";
                            FocusScope.of(context).unfocus();
                          });
                        },
                        clicked: spicyLevel == "3",
                      ),
                      SpicyLevelButton(
                        image: "images/icons/spicy4.png",
                        text: "맵신",
                        onPressed: () {
                          setState(() {
                            if (spicyLevel == "4") {
                              spicyLevel = "0";
                              return;
                            }
                            spicyLevel = "4";
                            FocusScope.of(context).unfocus();
                          });
                        },
                        clicked: spicyLevel == "4",
                      ),
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
