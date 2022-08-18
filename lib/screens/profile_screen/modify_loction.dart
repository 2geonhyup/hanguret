import 'package:flutter/material.dart';
import 'package:hangeureut/screens/basic_screen/basic_screen_page.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../models/custom_error.dart';
import '../../providers/profile/profile_provider.dart';
import '../../providers/profile/profile_state.dart';
import '../../widgets/bottom_navigation_bar.dart';
import '../../widgets/error_dialog.dart';
import '../../widgets/progress_bar.dart';

class ModifyLocation extends StatefulWidget {
  const ModifyLocation({Key? key}) : super(key: key);
  static String routeName = '/modify_location';

  @override
  State<ModifyLocation> createState() => _ModifyLocationState();
}

enum MainLocation { none, yonsei, ewha, sogang }

class _ModifyLocationState extends State<ModifyLocation> {
  Map onboarding = {};
  int? mainLocationIndex;
  late MainLocation mainLocation;

  Color _setColor(val) {
    if (mainLocation == MainLocation.none) {
      return kSecondaryTextColor;
    } else if (val == mainLocation) {
      return kBasicColor;
    } else {
      return kSecondaryTextColor.withOpacity(0.5);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    onboarding = context.read<ProfileState>().user.onboarding;
    mainLocationIndex = onboarding["mainLocation"];

    if (mainLocationIndex == 0 || mainLocationIndex == null) {
      mainLocation = MainLocation.none;
    } else if (mainLocationIndex == 1) {
      mainLocation = MainLocation.yonsei;
    } else if (mainLocationIndex == 2) {
      mainLocation = MainLocation.ewha;
    } else {
      mainLocation = MainLocation.sogang;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BasicBottomPopBar(
        option1: "취소",
        option2: "완료",
        withNav2: () async {
          onboarding["mainLocation"] = mainLocation.index;
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
            children: [
              SizedBox(
                height: 84,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 33.0),
                child: Text(
                  "관심 지역",
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
              SizedBox(
                height: 9.7,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 36,
                  ),
                  Text(
                    "여기에 ",
                    style: TextStyle(
                        fontFamily: 'Suit',
                        fontWeight: FontWeight.w800,
                        color: kSecondaryTextColor,
                        fontSize: 14),
                  ),
                  Text(
                    "특히 관심 있어요!",
                    style: TextStyle(
                        fontFamily: 'Suit',
                        fontWeight: FontWeight.w400,
                        color: kSecondaryTextColor,
                        fontSize: 14),
                  )
                ],
              ),
              Container(
                height: 500,
                child: Stack(
                  children: [
                    Positioned(
                        top: 42,
                        left: 31,
                        right: 31,
                        child: Image.asset(
                          "images/map.png",
                        )),
                    mainLocation != MainLocation.yonsei
                        ? SizedBox.shrink()
                        : Positioned(
                            top: 42,
                            left: -30,
                            child: Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                color: Color(0xffd9d9d9).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(100),
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 16,
                                      color: Colors.black.withOpacity(0.1),
                                      offset: Offset(0, 1),
                                      blurStyle: BlurStyle.outer)
                                ],
                              ),
                            ),
                          ),
                    Positioned(
                        top: 85,
                        left: 94,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              mainLocation = MainLocation.yonsei;
                            });
                          },
                          child: Column(
                            children: [
                              Image.asset(
                                "images/icons/onboarding_icon/gps_fixed_fill.png",
                                width: 30,
                                height: 30,
                                color: _setColor(MainLocation.yonsei),
                              ),
                              Text(
                                "연세대학교",
                                style: TextStyle(
                                    fontFamily: 'Suit',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: _setColor(MainLocation.yonsei)),
                              )
                            ],
                          ),
                        )),
                    mainLocation != MainLocation.ewha
                        ? SizedBox.shrink()
                        : Positioned(
                            top: 42,
                            left: 208,
                            child: Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                color: Color(0xffd9d9d9).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(100),
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 16,
                                      color: Colors.black.withOpacity(0.1),
                                      offset: Offset(0, 1),
                                      blurStyle: BlurStyle.outer)
                                ],
                              ),
                            ),
                          ),
                    Positioned(
                        top: 116,
                        left: 278,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              mainLocation = MainLocation.ewha;
                            });
                          },
                          child: Column(
                            children: [
                              Image.asset(
                                "images/icons/onboarding_icon/gps_fixed_fill.png",
                                width: 30,
                                height: 30,
                                color: _setColor(MainLocation.ewha),
                              ),
                              Text(
                                "이화여자대학교",
                                style: TextStyle(
                                    fontFamily: 'Suit',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: _setColor(MainLocation.ewha)),
                              )
                            ],
                          ),
                        )),
                    mainLocation != MainLocation.sogang
                        ? SizedBox.shrink()
                        : Positioned(
                            top: 200,
                            left: 107,
                            child: Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                color: Color(0xffd9d9d9).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(100),
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 16,
                                      color: Colors.black.withOpacity(0.1),
                                      offset: Offset(0, 1),
                                      blurStyle: BlurStyle.outer)
                                ],
                              ),
                            ),
                          ),
                    Positioned(
                        top: 275,
                        left: 192,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              mainLocation = MainLocation.sogang;
                            });
                          },
                          child: Column(
                            children: [
                              Image.asset(
                                  "images/icons/onboarding_icon/gps_fixed_fill.png",
                                  width: 30,
                                  height: 30,
                                  color: _setColor(MainLocation.sogang)),
                              Text(
                                "서강대학교",
                                style: TextStyle(
                                    fontFamily: 'Suit',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: _setColor(MainLocation.sogang)),
                              )
                            ],
                          ),
                        ))
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
