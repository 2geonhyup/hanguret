import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hangeureut/constants.dart';
import 'package:hangeureut/providers/contents/content_state.dart';
import 'package:hangeureut/providers/navbar/navbar_provider.dart';
import 'package:hangeureut/providers/restaurants/restaurants_provider.dart';
import 'package:hangeureut/providers/restaurants/restaurants_state.dart';
import 'package:hangeureut/providers/result/result_state.dart';
import 'package:hangeureut/restaurants.dart';
import 'package:hangeureut/screens/restaurant_detail_screen/restaurant_detail_page.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/custom_error.dart';
import '../../models/search_model.dart';
import '../../providers/contents/content_provider.dart';
import '../../providers/filter/filter_provider.dart';
import '../../providers/filter/filter_state.dart';
import '../../repositories/contents_repository.dart';
import '../../widgets/error_dialog.dart';
import 'hangerut_post.dart';

const double filterBarTopPadding = 35;
const double filterBarTop2Padding = 15;
const double changeOffsetDown = 360;
const double changeOffsetSearchingDown = 484;
const double changeOffsetUp = 320;
const double changeOffsetSearchingUp = 444;

const titleStyle = TextStyle(
    fontWeight: FontWeight.w400,
    fontFamily: 'Suit',
    fontSize: 30,
    color: Colors.white);

class MainScreenPage extends StatefulWidget {
  static const String routeName = '/main';
  const MainScreenPage({Key? key}) : super(key: key);

  @override
  State<MainScreenPage> createState() => MainScreenPageState();
}

class MainScreenPageState extends State<MainScreenPage> {
  ScrollController scrollController = ScrollController();
  PageController pageController = PageController(initialPage: 0);
  //ScrollController pageButtonScrollController = ScrollController();
  int pageIndex = 0;
  bool scrollEnd = false;
  bool sortType = false;
  bool searching = false;
  int mainFilterIndex = 0;
  int subFilterNum = -1;
  final ScrollController _pBtnController = ScrollController();

// This is what you're looking for!
  void _scrollDown(index) {
    if (index > 3) {
      _pBtnController.animateTo(
        _pBtnController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
      );
    } else {
      _pBtnController.animateTo(
        0,
        duration: Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  Future<void> _launchUrl(url) async {
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }

  Future<void> _getContents() async {
    await context.read<ContentProvider>().getContents();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getContents();
    });
    // TODO: implement initState
    scrollController.addListener(() {
      //429-(122-53)
      double offset1 = searching ? changeOffsetSearchingDown : changeOffsetDown;
      double offset2 = searching ? changeOffsetSearchingUp : changeOffsetUp;
      if (scrollController.offset > offset1) {
        if (scrollEnd == false) {
          //context.read<NavBarProvider>().changeNavBarShow();
          setState(() {
            scrollEnd = true;
          });
        }
      } else if (scrollController.offset < offset2) {
        if (scrollEnd == true) {
          //context.read<NavBarProvider>().changeNavBarShow();
          setState(() {
            scrollEnd = false;
          });
        }
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentState = context.watch<SearchFilterState>();
    final _contents = context.watch<ContentState>().contents ?? {};

    final mainFilter = currentState.filter.mainFilter;
    mainFilterIndex = mainFilter.index - 1;
    subFilterNum = currentState.filter.subFilter;

    bool selected = mainFilter != MainFilter.none;

    return WillPopScope(
      onWillPop: () async {
        if (searching) {
          setState(() {
            searching = false;
          });
        }
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: kBackgroundColor2,
        body: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          removeBottom: true,
          child: NestedScrollView(
            controller: selected ? scrollController : null,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return abbBarList(
                  selected, mainFilter, currentState.filter.subFilter);
            },
            body: selected
                ? MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: contentsView(mainFilter.index - 1),
                  )
                : HangerutPostWidget(
                    contents: _contents,
                  ),
          ),
        ),
      ),
    );
  }

  List<Widget> abbBarList(selected, mainFilter, subFilterText) {
    List<Widget> result = [
      SliverAppBar(
        bottom: null,
        backgroundColor: kBackgroundColor2,
        toolbarHeight: searching ? 524 : 429,
        elevation: 0,
        flexibleSpace: FlexibleSpaceBar(
          background: Column(
            children: [
              // 초록색 제목/검색 타일
              Container(
                height: searching ? 382 : 287,
                decoration: BoxDecoration(
                  color: kBasicColor,
                ),
                child: searching
                    ? Stack(
                        children: [
                          Positioned(
                            left: 34,
                            top: 54,
                            child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    searching = false;
                                  });
                                },
                                icon: SizedBox(
                                  height: 18,
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    color: Colors.white,
                                  ),
                                )),
                          ),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 220.0, left: 30, right: 23),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 28,
                                        decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  width: 1,
                                                  color: Colors.white)),
                                        ),
                                        child: TextFormField(
                                          onChanged: (val) async {
                                            // searchTerm = val;
                                            // relatedResults = await getRelated(val);
                                            // setState(() {});
                                          },
                                          style: TextStyle(
                                              fontFamily: 'Suit',
                                              fontWeight: FontWeight.w700,
                                              fontSize: 15,
                                              color: Colors.white),
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: "음식 또는 식당으로 검색해보세요.",
                                              hintStyle: TextStyle(
                                                  fontFamily: 'Suit',
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 15,
                                                  color: Colors.white
                                                      .withOpacity(0.6))),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 21.0),
                                      child: Image.asset(
                                        "images/icons/searchbig.png",
                                        width: 33,
                                        height: 33,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 81,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 27.0),
                                child: Divider(
                                  height: 0,
                                  thickness: 1,
                                  color: Colors.white,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 33.0, top: 60),
                                child: title,
                              ),
                            ],
                          ),
                          Positioned(
                              bottom: 35,
                              right: 23,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    searching = true;
                                  });
                                },
                                child: Image.asset(
                                  "images/icons/searchbig.png",
                                  width: 33,
                                  height: 33,
                                ),
                              ))
                        ],
                      ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 30.0, right: 30, top: 42, bottom: 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    mainFilterButton(context, MainFilter.meal, mainFilter),
                    mainFilterButton(context, MainFilter.alcohol, mainFilter),
                    mainFilterButton(context, MainFilter.coffee, mainFilter)
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    ];
    if (selected) {
      result.add(SliverAppBar(
        toolbarHeight:
            filterBarTopPadding + filterBarTop2Padding + 29 + 28 + 1 + 20,
        backgroundColor: kBackgroundColor2,
        floating: false,
        pinned: true,
        elevation: 0,
        flexibleSpace: FlexibleSpaceBar(
          background: PageButtonRow(),
        ),
      ));
    }
    return result;
  }

  Widget PageButtonRow() {
    List<Widget> pageButtons = [];
    pageButtons.add(SizedBox(
      width: 26,
    ));
    for (var i = 0; i < 7; i++) {
      pageButtons.add(pageButton(i));
    }
    pageButtons.add(SizedBox(
      width: 26,
    ));
    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  width: 0.5, color: kBorderGreenColor.withOpacity(0.5)))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            children: [
              SizedBox(
                height: filterBarTopPadding,
              ),
              AnimatedOpacity(
                opacity: scrollEnd ? 1 : 0,
                duration: Duration(milliseconds: 300),
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    setState(() {
                      sortType = !sortType;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 23),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(11),
                        border: Border.all(
                            color: kSecondaryTextColor.withOpacity(0.7))),
                    height: 29,
                    width: 70,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            sortType ? "거리순" : "인기순",
                            style: TextStyle(
                                height: 1.25,
                                fontWeight: FontWeight.w400,
                                color: kSecondaryTextColor,
                                fontFamily: 'Suit',
                                fontSize: 12),
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Image.asset(
                            "images/polygon1.png",
                            width: 11,
                            height: 11,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: filterBarTop2Padding,
              )
            ],
          ),
          Expanded(
            child: ListView(
              controller: _pBtnController,
              scrollDirection: Axis.horizontal,
              children: pageButtons,
            ),
          ),
        ],
      ),
    );
  }

  Widget pageButton(index) {
    bool selected = index == subFilterNum + 1;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => pageBtnOnTap(index),
      child: Container(
        decoration: BoxDecoration(
            border: selected
                ? Border(
                    bottom: BorderSide(width: 1, color: kSecondaryTextColor))
                : null),
        child: Padding(
          padding: EdgeInsets.only(left: 13, right: 13, top: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "${index == 0 ? "" : resFilterIcons[mainFilterIndex][index - 1]}${resFilterTextsSh[mainFilterIndex][index]}",
                style: TextStyle(
                  height: 1,
                  fontFamily: 'Suit',
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w400,
                  fontSize: 14,
                  color: selected
                      ? kSecondaryTextColor
                      : kSecondaryTextColor.withOpacity(0.6),
                ),
              ),
              SizedBox(
                height: 8 + 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  pageBtnOnTap(int page) {
    _scrollDown(page);

    setState(() {
      pageIndex = page;
    });
    if (scrollEnd) scrollController.jumpTo(430);

    context.read<SearchFilterProvider>().changeFilter(subFilter: page - 1);
  }

  Widget contentsView(mainFilterIndex) {
    return PageView(
      controller: pageController,
      children: [
        pageItem(0),
        pageItem(1),
        pageItem(2),
        pageItem(3),
        pageItem(4),
        pageItem(5),
        pageItem(6)
      ],
      onPageChanged: (index) {
        _scrollDown(index);
        setState(() {
          pageIndex = index;
        });
        if (scrollEnd) scrollController.jumpTo(430);

        context.read<SearchFilterProvider>().changeFilter(subFilter: index - 1);
      },
    );
  }

  Widget pageItem(int index) {
    final status = context.watch<RestaurantsState>().resStatus;
    if (status == ResStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(
          color: kBasicColor,
          strokeWidth: 2,
        ),
      );
    }
    final contents = context.watch<ResultState>().filteredResult;
    final resTileList = contents.map((e) => resTile(e)).toList();

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

        // scrollEnd
        //     ? Positioned.fill(
        //         bottom: 65,
        //         child: Align(
        //           alignment: Alignment.bottomCenter,
        //           child: GestureDetector(
        //             behavior: HitTestBehavior.translucent,
        //             onTap: () {
        //               scrollController.animateTo(0,
        //                   duration: Duration(milliseconds: 500),
        //                   curve: Curves.easeOutSine);
        //             },
        //             child: Container(
        //               width: 90,
        //               height: 44,
        //               decoration: BoxDecoration(
        //                 color: Colors.white,
        //                 borderRadius: BorderRadius.circular(30),
        //               ),
        //               child: Center(
        //                   child: Text(
        //                 "닫기",
        //                 style: TextStyle(
        //                     fontFamily: 'Suit',
        //                     fontWeight: FontWeight.w700,
        //                     fontSize: 15,
        //                     color: kSecondaryTextColor),
        //               )),
        //             ),
        //           ),
        //         ),
        //       )
        //     : SizedBox.shrink(),
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
                  child: Image.asset(
                    res["imgUrl"],
                    fit: BoxFit.cover,
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
                          "${res["distance"]}m",
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
              child: Text(resFilterTextsSh[mainFilterIndex][res["tag1"] + 1],
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
              child: Text(resFilterTextsSh[mainFilterIndex][res["tag2"] + 1],
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

  Widget title = Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("오늘", style: titleStyle),
      Row(
        children: [
          Text(
            "신촌",
            style: titleStyle.copyWith(fontWeight: FontWeight.w900),
          ),
          Text(
            "에서",
            style: titleStyle,
          ),
        ],
      ),
      Text(
        "뭐 먹지",
        style: titleStyle,
      ),
    ],
  );

  Widget mainFilterButton(
      BuildContext context, MainFilter filter, MainFilter curFilter) {
    return GestureDetector(
      onTap: () async {
        setState(() {
          searching = false;
        });
        if (curFilter == filter) {
          context
              .read<SearchFilterProvider>()
              .changeFilter(mainFilter: MainFilter.none);
          return;
        }
        context
            .read<SearchFilterProvider>()
            .changeFilter(mainFilter: filter, subFilter: -1);
      },
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
            color: mainButtonColor(context, filter, curFilter),
            borderRadius: BorderRadius.all(
              Radius.circular(25),
            ),
            boxShadow: [
              filter == curFilter
                  ? BoxShadow(color: Colors.transparent)
                  : BoxShadow(
                      blurStyle: BlurStyle.outer,
                      offset: Offset(0, 1),
                      blurRadius: 4,
                      color: Colors.black.withOpacity(0.05))
            ]),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
                top: 29,
                child: Text(
                  mainFilterIcons[filter.index - 1],
                  style: TextStyle(
                      fontSize: filter.index == 1
                          ? 23
                          : filter.index == 2
                              ? 24
                              : 26,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Suit',
                      height: 1),
                )),
            Positioned(
                top: 60,
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
}

Color mainButtonColor(
    BuildContext context, MainFilter filter, MainFilter curFilter) {
  if (curFilter == MainFilter.none) {
    return Colors.white;
  }
  return curFilter == filter ? Colors.white : Colors.white.withOpacity(0.5);
}
