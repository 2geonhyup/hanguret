import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hangeureut/constants.dart';
import 'package:hangeureut/providers/news/news_provider.dart';
import 'package:hangeureut/providers/profile/profile_state.dart';
import 'package:hangeureut/screens/on_boarding_screen/on_boarding1_page.dart';
import 'package:hangeureut/screens/on_boarding_screen/on_boarding2_page.dart';
import 'package:hangeureut/screens/on_boarding_screen/on_boarding3_page.dart';
import 'package:hangeureut/screens/review_screen/search_for_review_page.dart';
import 'package:hangeureut/screens/splash_screen/splash_page.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../widgets/floating_button.dart';
import '../start_screen/start_page.dart';
import 'basic_screen_view.dart';

class BasicScreenPage extends StatefulWidget {
  static const String routeName = '/basic';
  BasicScreenPage(
      {Key? key, this.initialIndex = 0, this.resId, this.backOption = true})
      : super(key: key);
  final initialIndex;
  String? resId;
  bool backOption;

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
  }

  @override
  Widget build(BuildContext context) {
    ProfileStatus status = context.watch<ProfileState>().profileStatus;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (status == ProfileStatus.initial) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const StartPage()));
      }
    });

    return Stack(
      children: [
        Scaffold(
          extendBody: true,
          resizeToAvoidBottomInset: false,
          body: Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: PersistentTabView.custom(
              context,
              routeAndNavigatorSettings: CutsomWidgetRouteAndNavigatorSettings(
                routes: <String, WidgetBuilder>{
                  BasicScreenPage.routeName: (context) => BasicScreenPage(),
                  StartPage.routeName: (context) => const StartPage(),
                  SplashPage.routeName: (context) => const SplashPage(),
                  OnBoarding1Page.routeName: (context) => OnBoarding1Page(),
                  OnBoarding2Page.routeName: (context) =>
                      const OnBoarding2Page(),
                  OnBoarding3Page.routeName: (context) =>
                      const OnBoarding3Page(),
                  SearchForReviewPage.routeName: (context) =>
                      const SearchForReviewPage()
                },
              ),
              controller: _controller,
              itemCount: 5,
              bottomScreenMargin: 0,
              screens: buildScreens(),
              confineInSafeArea: false,
              resizeToAvoidBottomInset: false,
              handleAndroidBackButtonPress: widget.backOption,
              screenTransitionAnimation:
                  const ScreenTransitionAnimation(animateTabTransition: true),
              backgroundColor: Colors.transparent,
              hideNavigationBarWhenKeyboardShows: true,
              customWidget: CustomNavBarWidget(
                // Your custom widget goes here
                items: navBarsItems(),
                selectedIndex: _controller.index,
                onItemSelected: (index) {
                  if (_controller.index == index) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                BasicScreenPage(initialIndex: index)));
                  }
                  if (_controller.index == 3) {
                    context.read<NewsProvider>().watchNews();
                  }
                  setState(() {
                    _controller.index =
                        index; // NOTE: THIS IS CRITICAL!! Don't miss it!
                  });
                },
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 42,
          right: MediaQuery.of(context).size.width * 0.135 - 28,
          child: ReviewFloatingButton(
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BasicScreenPage(initialIndex: 4)));
            },
            buttonColor: kSecondaryTextColor,
          ),
        ),
      ],
    );
  }
}
