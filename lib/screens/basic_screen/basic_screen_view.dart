import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hangeureut/constants.dart';
import 'package:hangeureut/screens/location_select_screen/location_select_page.dart';
import 'package:hangeureut/screens/main_screen/main_screen_page.dart';
import 'package:hangeureut/screens/profile_screen/profile_page.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import '../../widgets/floating_button.dart';
import '../../widgets/nav_custom_painter.dart';

List<Widget> buildScreens() {
  return [
    MainScreenPage(),
    Center(child: Text("2")),
    ProfilePage(),
    Center(child: Text("4")),
  ];
}

List<Color> navBarColor = [
  kBackgroundColor2,
  kBackgroundColor,
  kBackgroundColor,
  kBackgroundColor
];

List<PersistentBottomNavBarItem> navBarsItems() {
  return [
    PersistentBottomNavBarItem(
        icon: Icon(
          Icons.home_outlined,
          size: 27,
        ),
        title: ("Home"),
        activeColorPrimary: kBasicTextColor,
        inactiveColorPrimary: kBasicTextColor.withOpacity(0.3),
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
            initialRoute: MainScreenPage.routeName,
            routes: {
              LocationSelectPage.routeName: (context) => LocationSelectPage(),
            })),
    PersistentBottomNavBarItem(
      icon: Icon(
        Icons.photo_outlined,
        size: 26,
      ),
      title: ('Record'),
      activeColorPrimary: kBasicTextColor,
      inactiveColorPrimary: kBasicTextColor.withOpacity(0.3),
    ),
    PersistentBottomNavBarItem(
      icon: Icon(
        Icons.person_outlined,
        size: 27,
      ),
      title: ('Profile'),
      activeColorPrimary: kBasicTextColor,
      inactiveColorPrimary: kBasicTextColor.withOpacity(0.3),
    ),
    PersistentBottomNavBarItem(
      icon: Icon(
        Icons.notifications_outlined,
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

  Widget _buildItem(PersistentBottomNavBarItem item, bool isSelected) {
    return Container(
      alignment: Alignment.center,
      height: 83.0,
      child: IconTheme(
        data: IconThemeData(
            color: isSelected
                ? (item.activeColorSecondary == null
                    ? item.activeColorPrimary
                    : item.activeColorSecondary)
                : item.inactiveColorPrimary == null
                    ? item.activeColorPrimary
                    : item.inactiveColorPrimary),
        child: item.icon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                    onTap: () {
                      this.onItemSelected(index);
                    },
                    child: _buildItem(item, selectedIndex == index),
                  ),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}
