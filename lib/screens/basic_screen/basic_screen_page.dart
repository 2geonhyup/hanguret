import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hangeureut/constants.dart';
import 'package:hangeureut/screens/location_select_screen/location_select_page.dart';
import 'package:hangeureut/screens/main_screen/main_screen_page.dart';
import 'package:hangeureut/screens/profile_screen/profile_page.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../providers/profile/profile_provider.dart';
import '../../widgets/floating_button.dart';
import '../../widgets/nav_custom_painter.dart';
import '../main_screen/main_screen_view.dart';
import 'basic_screen_view.dart';

class BasicScreenPage extends StatefulWidget {
  static const String routeName = '/basic';
  BasicScreenPage({Key? key}) : super(key: key);

  @override
  State<BasicScreenPage> createState() => _BasicScreenPageState();
}

class _BasicScreenPageState extends State<BasicScreenPage> {
  late PersistentTabController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    _controller = PersistentTabController(initialIndex: 0);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      showDialog(
          context: context,
          builder: (context) {
            return WelcomeDialog(
              onMoreTap: () {
                _controller.index = 2;
                setState(() {});
              },
            );
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:
          ReviewFloatingButton(buttonColor: kSecondaryTextColor),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      body: Padding(
        padding: const EdgeInsets.only(bottom: 30.0),
        child: PersistentTabView.custom(
          context,
          controller: _controller,
          itemCount: 4,
          screens: buildScreens(),
          confineInSafeArea: false,
          handleAndroidBackButtonPress: true,
          backgroundColor: navBarColor[_controller.index],
          customWidget: CustomNavBarWidget(
            // Your custom widget goes here
            items: navBarsItems(),
            selectedIndex: _controller.index,
            onItemSelected: (index) {
              setState(() {
                _controller.index =
                    index; // NOTE: THIS IS CRITICAL!! Don't miss it!
              });
            },
          ),
        ),
      ),
    );
  }
}
