import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hangeureut/constants.dart';
import 'package:hangeureut/providers/news/news_state.dart';
import 'package:hangeureut/screens/main_screen/main_screen_page.dart';
import 'package:hangeureut/screens/news_screen/news_page.dart';
import 'package:hangeureut/screens/notice_screen/notice_page.dart';
import 'package:hangeureut/screens/profile_screen/profile_page.dart';
import 'package:hangeureut/screens/restaurant_detail_screen/restaurant_detail_page.dart';
import 'package:hangeureut/screens/review_screen/search_for_review_page.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../widgets/nav_custom_painter.dart';

List<Widget> buildScreens(reviewing, page) {
  return [
    reviewing ? SearchForReviewPage() : page ?? MainScreenPage(),
    NewsPage(),
    ProfilePage(),
    NoticePage(),
  ];
}

List<Widget> initialScreens = [
  MainScreenPage(),
  Center(child: Text("2")),
  ProfilePage(),
  Center(child: Text("4")),
];

List<Color> navBackgroundColor = [
  kBackgroundColor2,
  kBackgroundColor,
  kBackgroundColor,
  kBackgroundColor
];
//26 28 26 27
List<PersistentBottomNavBarItem> navBarsItems() {
  return [
    PersistentBottomNavBarItem(
      icon: ImageIcon(
        AssetImage(
          "images/icons/home.png",
        ),
        size: 26,
      ),
      title: ("Home"),
      activeColorPrimary: kBasicTextColor,
      inactiveColorPrimary: kBasicTextColor.withOpacity(0.3),
    ),
    PersistentBottomNavBarItem(
      icon: ImageIcon(
        AssetImage(
          "images/icons/chat.png",
        ),
        size: 28,
      ),
      title: ('Record'),
      activeColorPrimary: kBasicTextColor,
      inactiveColorPrimary: kBasicTextColor.withOpacity(0.3),
    ),
    PersistentBottomNavBarItem(
      icon: ImageIcon(
        AssetImage(
          "images/icons/user.png",
        ),
        size: 26,
      ),
      title: ('Profile'),
      activeColorPrimary: kBasicTextColor,
      inactiveColorPrimary: kBasicTextColor.withOpacity(0.3),
    ),
    PersistentBottomNavBarItem(
      icon: ImageIcon(
        AssetImage(
          "images/icons/bell.png",
        ),
        size: 27,
      ),
      title: ('notifications'),
      activeColorPrimary: kBasicTextColor,
      inactiveColorPrimary: kBasicTextColor.withOpacity(0.3),
    ),
  ];
}

class CustomNavBarWidget extends StatelessWidget {
  final int selectedIndex;
  final List<PersistentBottomNavBarItem>
      items; // NOTE: You CAN declare your own model here instead of `PersistentBottomNavBarItem`.
  final ValueChanged<int> onItemSelected;

  CustomNavBarWidget(
      {required this.selectedIndex,
      required this.items,
      required this.onItemSelected,
      Key? key})
      : super(key: key);

  Widget _buildItem(
      PersistentBottomNavBarItem item, bool isSelected, bool watched) {
    return Container(
        alignment: Alignment.center,
        child: item.title == 'notifications' && !isSelected && !watched
            ? Image.asset(
                "images/icons/bell_notice.png",
                width: 27,
                height: 27,
              )
            : IconTheme(
                data: IconThemeData(
                    color: isSelected
                        ? (item.activeColorSecondary == null
                            ? item.activeColorPrimary
                            : item.activeColorSecondary)
                        : item.inactiveColorPrimary == null
                            ? item.activeColorPrimary
                            : item.inactiveColorPrimary),
                child: item.icon,
              ));
  }

  @override
  Widget build(BuildContext context) {
    bool watched = context.watch<NewsState>().watched;
    return CustomPaint(
      painter: NavCustomPainter(
          0.74, 4, Colors.white, Directionality.of(context), false),
      child: Row(
        children: [
          SizedBox(
            width: 15,
          ),
          Container(
            width: 280,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: items.map((item) {
                int index = items.indexOf(item);
                return Flexible(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      this.onItemSelected(index);
                    },
                    child: _buildItem(item, selectedIndex == index, watched),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
