import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hangeureut/constants.dart';
import 'package:hangeureut/providers/restaurants/restaurants_state.dart';
import 'package:hangeureut/providers/result/result_state.dart';
import 'package:hangeureut/restaurants.dart';
import 'package:hangeureut/screens/result_screen/search_result.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../models/custom_error.dart';
import '../../models/search_model.dart';
import '../../providers/contents/content_provider.dart';
import '../../providers/filter/filter_provider.dart';
import '../../providers/filter/filter_state.dart';
import '../../widgets/error_dialog.dart';
import '../../widgets/res_tile.dart';
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
  TextEditingController textEditingController = TextEditingController();
  int pageIndex = 0;
  bool scrollEnd = false;
  bool sortType = false;
  bool searching = false;
  int mainFilterIndex = 0;
  int subFilterNum = -1;
  Map distanceMap = {};
  final ScrollController _pBtnController = ScrollController();
  Map _contents = {};

// This is what you're looking for!
  void _scrollDown(index) {
    if (index > 3) {
      _pBtnController.animateTo(
        _pBtnController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
      );
    } else {
      _pBtnController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  Future<void> _getContents() async {
    _contents = await context.read<ContentProvider>().getContents();
    setState(() {});
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
                  : HangerutPostWidget(contents: _contents),
            ),
          ),
        ));
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
                decoration: const BoxDecoration(
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
                                icon: const SizedBox(
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
                                        decoration: const BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  width: 1,
                                                  color: Colors.white)),
                                        ),
                                        child: TextFormField(
                                          controller: textEditingController,
                                          style: const TextStyle(
                                              fontFamily: 'Suit',
                                              fontWeight: FontWeight.w500,
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
                                          onEditingComplete: () {
                                            if (textEditingController.text ==
                                                "") {
                                              errorDialog(
                                                  context,
                                                  const CustomError(
                                                      code: "알림",
                                                      message:
                                                          "검색어는 하나 이상 입력해주세요"));
                                              return;
                                            }
                                            pushNewScreen(context,
                                                screen: SearchResult(
                                                  searchTerm:
                                                      textEditingController
                                                          .text,
                                                ));
                                          },
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 21.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          if (textEditingController.text ==
                                              "") {
                                            errorDialog(
                                                context,
                                                const CustomError(
                                                    code: "알림",
                                                    message:
                                                        "검색어는 하나 이상 입력해주세요"));
                                            return;
                                          }
                                          pushNewScreen(context,
                                              screen: SearchResult(
                                                searchTerm:
                                                    textEditingController.text,
                                              ));
                                        },
                                        child: Image.asset(
                                          "images/icons/searchbig.png",
                                          width: 33,
                                          height: 33,
                                        ),
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
                              const SizedBox(
                                height: 81,
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 27.0),
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
        toolbarHeight: filterBarTopPadding + filterBarTop2Padding + 28 + 1 + 20,
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
    pageButtons.add(const SizedBox(
      width: 26,
    ));
    for (var i = 0; i < 7; i++) {
      pageButtons.add(pageButton(i));
    }
    pageButtons.add(const SizedBox(
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
              const SizedBox(
                height: filterBarTopPadding,
              ),
              const SizedBox(
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
                ? const Border(
                    bottom: BorderSide(width: 1, color: kSecondaryTextColor))
                : null),
        child: Padding(
          padding: const EdgeInsets.only(left: 13, right: 13, top: 20),
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
              const SizedBox(
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

    return Stack(
      children: [
        GridView.count(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.only(top: 29.5, bottom: 60),
            crossAxisCount: 2,
            childAspectRatio: 0.709,
            crossAxisSpacing: 10,
            children: List.generate(
                contents.length,
                (index) => ResTile(
                      res: contents[index],
                      mainFilterIndex: mainFilterIndex,
                    ))),
      ],
    );
  }

  Container loadingContainer() {
    return Container(
      color: Colors.grey,
    );
  }

  Widget title = Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text("오늘", style: titleStyle),
      Row(
        children: [
          Text(
            "신촌",
            style: titleStyle.copyWith(fontWeight: FontWeight.w900),
          ),
          const Text(
            "에서",
            style: titleStyle,
          ),
        ],
      ),
      const Text(
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
            borderRadius: const BorderRadius.all(
              Radius.circular(25),
            ),
            boxShadow: [
              filter == curFilter
                  ? const BoxShadow(color: Colors.transparent)
                  : BoxShadow(
                      blurStyle: BlurStyle.outer,
                      offset: const Offset(0, 1),
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
