import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hangeureut/constants.dart';
import 'package:hangeureut/providers/navbar/navbar_state.dart';
import 'package:hangeureut/providers/news/news_provider.dart';
import 'package:hangeureut/providers/news/news_state.dart';
import 'package:hangeureut/providers/profile/profile_state.dart';
import 'package:hangeureut/repositories/news_repository.dart';
import 'package:hangeureut/screens/friend_screen/friend_recommend_page.dart';
import 'package:hangeureut/screens/main_screen/main_screen_page.dart';
import 'package:hangeureut/screens/profile_screen/profile_page.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../models/news_model.dart';
import '../../models/search_model.dart';
import '../../providers/filter/filter_provider.dart';
import '../../widgets/floating_button.dart';
import '../main_screen/main_screen_view.dart';
import 'basic_screen_view.dart';

class BasicScreenPage extends StatefulWidget {
  static const String routeName = '/basic';
  BasicScreenPage({Key? key, this.initialIndex = 0, this.reviewing, this.page})
      : super(key: key);
  final initialIndex;
  bool? reviewing;
  Widget? page;

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
    widget.reviewing != null ? reviewing = true : null;
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
    //bool navBarShow = context.watch<NavBarState>().show;
    //print(navBarShow);

    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      floatingActionButton: ReviewFloatingButton(
        onTap: () {
          pushNewScreen(
            context,
            screen: BasicScreenPage(
              initialIndex: 0,
              reviewing: true,
            ),
            withNavBar: true, // OPTIONAL VALUE. True by default.
          );
        },
        buttonColor: kSecondaryTextColor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      body: AnimatedPadding(
        curve: Curves.easeInCirc,
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.only(bottom: 30.0),
        child: PersistentTabView.custom(
          context,
          controller: _controller,
          itemCount: 4,
          bottomScreenMargin: 0,
          screens: buildScreens(reviewing, widget.page),
          confineInSafeArea: false,
          resizeToAvoidBottomInset: false,
          handleAndroidBackButtonPress: true,
          screenTransitionAnimation:
              ScreenTransitionAnimation(animateTabTransition: true),
          backgroundColor: reviewing ? Colors.white : Colors.transparent,
          hideNavigationBarWhenKeyboardShows: true,
          customWidget: CustomNavBarWidget(
            // Your custom widget goes here
            items: navBarsItems(),
            selectedIndex: _controller.index,
            onItemSelected: (index) {
              if (_controller.index == index) {
                pushNewScreen(
                  context,
                  pageTransitionAnimation: PageTransitionAnimation.fade,
                  screen: BasicScreenPage(
                    initialIndex: index,
                  ),
                  withNavBar: true, // OPTIONAL VALUE. True by default.
                );
              }
              if (_controller.index == 3) {
                context.read<NewsProvider>().watchNews();
              }
              setState(() {
                _controller.index =
                    index; // NOTE: THIS IS CRITICAL!! Don't miss it!
              });
              if (_controller.index == 0) {
                setState(() {
                  reviewing = false;
                });
              }
            },
          ),
        ),
      ),
    );
  }
}
