import 'package:flutter/material.dart';
import 'package:hangeureut/constants.dart';
import 'package:hangeureut/models/search_model.dart';
import 'package:hangeureut/providers/menu/menu_provider.dart';
import 'package:hangeureut/screens/location_select_screen/location_select_page.dart';
import 'package:provider/provider.dart';

import '../../providers/filter/filter_provider.dart';
import '../../providers/menu/menu_state.dart';
import '../../widgets/floating_button.dart';
import '../main_screen/main_screen_page.dart';
import '../profile_screen/profile_page.dart';

class BasicScreenPage extends StatefulWidget {
  static const String routeName = '/basic';
  BasicScreenPage({Key? key}) : super(key: key);

  @override
  State<BasicScreenPage> createState() => _BasicScreenPageState();
}

class _BasicScreenPageState extends State<BasicScreenPage> {
  int _pageIndex = 0;

  late PageController _pageController;
  List<Widget> tabPages = [
    MainScreenPage(),
    Container(
      width: 20,
      height: 20,
      color: Colors.white,
      child: Center(
        child: Text("second"),
      ),
    ),
    ProfilePage(),
    Container(
      width: 20,
      height: 20,
      color: Colors.white,
      child: Center(
        child: Text("4"),
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: _pageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _pageIndex = context.watch<MenuState>().index;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: Padding(
            padding: const EdgeInsets.only(top: 38.0),
            child: ReviewFloatingButton(buttonColor: Colors.black)),
        backgroundColor: kBasicColor,
        bottomNavigationBar: Container(
          padding: const EdgeInsets.only(
            left: 10,
            right: 100,
          ),
          color: Colors.white,
          child: MainBottomNavigationBar(
              index: _pageIndex,
              onTap: onTabTapped,
              items: bottomNavigatorBarItems),
        ),
        body: PageView(
          children: tabPages,
          onPageChanged: onPageChanged,
          controller: _pageController,
        ));
  }

  void onPageChanged(int page) {
    context.read<MenuProvider>().changeMenu(page);
  }

  void onTabTapped(int index) {
    if (_pageIndex == 0 && index == 0) {
      context
          .read<SearchFilterProvider>()
          .changeFilter(Filter(mainFilter: MainFilter.none));
    }
    this._pageController.jumpToPage(index);
  }
}

class MainBottomNavigationBar extends StatelessWidget {
  MainBottomNavigationBar(
      {Key? key, required this.index, required this.onTap, required this.items})
      : super(key: key);
  int index;
  void Function(int)? onTap;
  List<BottomNavigationBarItem> items;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: index,
      onTap: onTap,
      backgroundColor: Colors.white,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedIconTheme: IconThemeData(size: 28, color: kBasicTextColor),
      unselectedIconTheme:
          IconThemeData(size: 28, color: kBasicTextColor.withOpacity(0.3)),
      items: bottomNavigatorBarItems,
    );
  }
}
