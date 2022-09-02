import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hangeureut/constants.dart';
import 'package:hangeureut/providers/profile/profile_state.dart';
import 'package:hangeureut/screens/friend_screen/friend_recommend_page.dart';
import 'package:hangeureut/screens/main_screen/main_screen_page.dart';
import 'package:hangeureut/screens/profile_screen/profile_page.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../models/search_model.dart';
import '../../providers/filter/filter_provider.dart';
import '../../widgets/floating_button.dart';
import '../main_screen/main_screen_view.dart';
import 'basic_screen_view.dart';

class BasicScreenPage extends StatefulWidget {
  static const String routeName = '/basic';
  BasicScreenPage({Key? key, this.initialIndex = 0}) : super(key: key);
  final initialIndex;

  @override
  State<BasicScreenPage> createState() => _BasicScreenPageState();
}

class _BasicScreenPageState extends State<BasicScreenPage> {
  late PersistentTabController _controller;
  bool reviewing = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    _controller = PersistentTabController(initialIndex: widget.initialIndex);
    if (context.read<ProfileState>().user.first) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
            context: context,
            builder: (context) {
              return WelcomeDialog(
                onMoreTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Scaffold(body: FriendRecommendPage())));
                },
              );
            });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: ReviewFloatingButton(
        onTap: () {
          setState(() {
            _controller.index = 0;
            reviewing = true;
          });
        },
        buttonColor: kSecondaryTextColor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      body: Padding(
        padding: const EdgeInsets.only(bottom: 30.0),
        child: PersistentTabView.custom(
          context,
          routeAndNavigatorSettings:
              CutsomWidgetRouteAndNavigatorSettings(routes: {
            ProfilePage.routeName: (context) => ProfilePage(),
            MainScreenPage.routeName: (context) => MainScreenPage(),
          }),
          controller: _controller,
          itemCount: 4,
          screens: buildScreens(reviewing),
          confineInSafeArea: false,
          handleAndroidBackButtonPress: true,
          backgroundColor:
              reviewing ? Colors.white : navBackgroundColor[_controller.index],
          hideNavigationBarWhenKeyboardShows: true,
          customWidget: CustomNavBarWidget(
            // Your custom widget goes here
            items: navBarsItems(),
            selectedIndex: _controller.index,
            onItemSelected: (index) {
              if (index == 0) {
                context
                    .read<SearchFilterProvider>()
                    .changeFilter(Filter(mainFilter: MainFilter.none));
              }
              if (_controller.index == index) {
                pushNewScreen(
                  context,
                  screen: BasicScreenPage(
                    initialIndex: index,
                  ),
                  withNavBar: true, // OPTIONAL VALUE. True by default.
                );
              }
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
