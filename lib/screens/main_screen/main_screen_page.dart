import 'package:flutter/material.dart';
import 'package:hangeureut/constants.dart';
import 'package:hangeureut/providers/profile/profile_provider.dart';
import 'package:hangeureut/repositories/friend_repository.dart';
import 'package:hangeureut/screens/serching_screen/searching_page.dart';
import 'package:hangeureut/widgets/profile_icon_box.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import '../../models/search_model.dart';
import '../../providers/filter/filter_provider.dart';
import '../../providers/filter/filter_state.dart';
import '../location_select_screen/location_select_page.dart';
import 'main_screen_view.dart';

class MainScreenPage extends StatefulWidget {
  static const String routeName = '/main';
  const MainScreenPage({Key? key}) : super(key: key);

  @override
  State<MainScreenPage> createState() => MainScreenPageState();
}

class MainScreenPageState extends State<MainScreenPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentState = context.watch<SearchFilterState>();
    final mainFilter = currentState.filter.mainFilter;
    bool selected = mainFilter != MainFilter.none;
    List? subOptions;
    if (selected) {
      subOptions = filterMap[mainFilter].keys.toList();
    }

    return Scaffold(
        backgroundColor: kBackgroundColor2,
        body: ListView(
            padding: EdgeInsets.zero,
            physics: NeverScrollableScrollPhysics(),
            children: [
              Container(
                color: !selected ? kBasicColor : kBackgroundColor2,
                child: Column(
                  children: [
                    !selected
                        ? Padding(
                            padding:
                                EdgeInsets.only(top: 60, left: 40, right: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "한그릇",
                                  style: TextStyle(
                                      fontFamily: "Cafe24",
                                      color: Colors.white,
                                      fontSize: 30),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        "저장",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 10),
                                      ),
                                      Icon(
                                        Icons.bookmark,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ))
                        : Padding(
                            padding: const EdgeInsets.only(
                                top: 63, left: 30, right: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    context
                                        .read<SearchFilterProvider>()
                                        .changeFilter(Filter(
                                            mainFilter: MainFilter.none));
                                  },
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    color: kBasicTextColor.withOpacity(0.8),
                                  ),
                                )
                              ],
                            ),
                          ),
                    AnimatedSize(
                      duration: Duration(milliseconds: 200),
                      child: Container(
                        height: !selected ? 300 : 0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(
                              height: 135,
                            ),
                            Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30.0),
                                child: Container(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              await context
                                                  .read<FriendRepository>()
                                                  .getKaKaoFriends();
                                            },
                                            child: Text(
                                              "메뉴 이름으로 찾기",
                                              style: TextStyle(
                                                  color: kHintTextColor
                                                      .withOpacity(0.6),
                                                  fontSize: 14),
                                            ),
                                          ),
                                          Image.asset(
                                            "images/icons/search.png",
                                            width: 20,
                                            height: 20,
                                          ),
                                        ],
                                      ),
                                    ),
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(50)),
                                    )))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  color: kBackgroundColor2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 33.0),
                    child: Column(children: [
                      SizedBox(
                        height: 50,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          mainFilterButton(
                              context, MainFilter.meal, mainFilter),
                          mainFilterButton(
                              context, MainFilter.alcohol, mainFilter),
                          mainFilterButton(
                              context, MainFilter.coffee, mainFilter)
                        ],
                      ),
                      selected
                          ? SizedBox(
                              height: 50,
                              child: Divider(
                                color: Color(0xff8B867D),
                              ),
                            )
                          : SizedBox.shrink(),
                      selected
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SubFilterButton(
                                      mainFilter: mainFilter,
                                      subFilter: subOptions![1],
                                    ),
                                    SubFilterButton(
                                      mainFilter: mainFilter,
                                      subFilter: subOptions[2],
                                    ),
                                    SubFilterButton(
                                      mainFilter: mainFilter,
                                      subFilter: subOptions[3],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SubFilterButton(
                                      mainFilter: mainFilter,
                                      subFilter: subOptions[4],
                                    ),
                                    SubFilterButton(
                                      mainFilter: mainFilter,
                                      subFilter: subOptions[5],
                                    ),
                                    SubFilterButton(
                                      mainFilter: mainFilter,
                                      subFilter: subOptions[6],
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : SizedBox.shrink(),
                      SizedBox(
                        height: 120,
                      ),
                      selected
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        pushNewScreenWithRouteSettings(
                                          context,
                                          settings: RouteSettings(
                                              name:
                                                  LocationSelectPage.routeName),
                                          screen: LocationSelectPage(),
                                          withNavBar: true,
                                          pageTransitionAnimation:
                                              PageTransitionAnimation.cupertino,
                                        );
                                      },
                                      child: Text(
                                        "위치 선택하기 >",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: kSecondaryTextColor),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 13,
                                ),
                                GestureDetector(
                                  child: Container(
                                    width: 114,
                                    height: 44,
                                    decoration: BoxDecoration(
                                        color: kBasicColor,
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: Center(
                                      child: Text(
                                        "바로 찾기",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : SizedBox.shrink(),
                    ]),
                  )),
            ]));
  }
}

class SubFilterButton extends StatefulWidget {
  const SubFilterButton({
    Key? key,
    required this.mainFilter,
    required this.subFilter,
  }) : super(key: key);
  final mainFilter;
  final subFilter;

  @override
  State<SubFilterButton> createState() => _SubFilterButtonState();
}

class _SubFilterButtonState extends State<SubFilterButton> {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<SearchFilterState>();
    List subFilters = state.filter.subFilterList;
    bool selected = subFilters.contains(widget.subFilter);

    return GestureDetector(
      onTap: () {
        setState(() {
          context.read<SearchFilterProvider>().addSubFilter(widget.subFilter);
        });
      },
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: subButtonColor(context, widget.subFilter),
          border: selected
              ? Border.all(
                  color: kSecondaryTextColor.withOpacity(0.2), width: 0.5)
              : null,
          borderRadius: BorderRadius.all(
            Radius.circular(25),
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 30,
              child: Image.asset(
                  filterMap[widget.mainFilter][widget.subFilter][0]),
              width: 25,
              height: 25,
            ),
            Positioned(
                top: 65,
                child: Text(
                  filterMap[widget.mainFilter][widget.subFilter][1],
                  style: TextStyle(
                      fontFamily: 'Suit',
                      fontSize: 12,
                      fontWeight:
                          selected ? FontWeight.bold : FontWeight.normal),
                )),
          ],
        ),
      ),
    );
  }
}

Color subButtonColor(BuildContext context, subFilter) {
  final state = context.watch<SearchFilterState>();
  List subFilters = state.filter.subFilterList;

  return subFilters.contains(subFilter) ? Colors.white : kBackgroundColor2;
}

Widget mainFilterButton(
    BuildContext context, MainFilter filter, MainFilter curFilter) {
  return GestureDetector(
    onTap: () {
      if (curFilter == filter) {
        context
            .read<SearchFilterProvider>()
            .changeFilter(Filter(mainFilter: MainFilter.none));
        return;
      }
      context
          .read<SearchFilterProvider>()
          .changeFilter(Filter(mainFilter: filter));
    },
    child: Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        border:
            Border.all(color: kSecondaryTextColor.withOpacity(0.2), width: 0.5),
        color: mainButtonColor(context, filter, curFilter),
        borderRadius: BorderRadius.all(
          Radius.circular(25),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
              top: 30,
              child: Image.asset(
                filterMap[filter][filter][0],
                width: 25,
                height: 25,
              )),
          Positioned(
              top: 65,
              child: Text(
                filterMap[filter][filter][1],
                style: TextStyle(
                    fontFamily: 'Suit',
                    fontSize: 12,
                    fontWeight: curFilter == filter
                        ? FontWeight.bold
                        : FontWeight.normal),
              )),
        ],
      ),
    ),
  );
}

Color mainButtonColor(
    BuildContext context, MainFilter filter, MainFilter curFilter) {
  if (curFilter == MainFilter.none) {
    return Colors.white;
  }
  return curFilter == filter ? Colors.white : Colors.white.withOpacity(0.3);
}
