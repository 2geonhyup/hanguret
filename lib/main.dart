import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hangeureut/providers/auth/auth_provider.dart';
import 'package:hangeureut/providers/auth/auth_state.dart';
import 'package:hangeureut/providers/filter/filter_provider.dart';
import 'package:hangeureut/providers/filter/filter_state.dart';
import 'package:hangeureut/providers/menu/menu_provider.dart';
import 'package:hangeureut/providers/menu/menu_state.dart';
import 'package:hangeureut/providers/profile/profile_provider.dart';
import 'package:hangeureut/providers/profile/profile_state.dart';
import 'package:hangeureut/providers/signup/signup_provider.dart';
import 'package:hangeureut/providers/signup/signup_state.dart';
import 'package:hangeureut/repositories/auth_repository.dart';
import 'package:hangeureut/repositories/friend_repository.dart';
import 'package:hangeureut/repositories/profile_repository.dart';
import 'package:hangeureut/screens/basic_screen/basic_screen_page.dart';
import 'package:hangeureut/screens/location_select_screen/location_select_page.dart';
import 'package:hangeureut/screens/main_screen/main_screen_page.dart';
import 'package:hangeureut/screens/on_boarding_screen/on_boarding1_page.dart';
import 'package:hangeureut/screens/on_boarding_screen/on_boarding2_page.dart';
import 'package:hangeureut/screens/on_boarding_screen/on_boarding3_page.dart';
import 'package:hangeureut/screens/result_screen/search_result.dart';
import 'package:hangeureut/screens/review_screen/review_page.dart';
import 'package:hangeureut/screens/serching_screen/searching_page.dart';
import 'package:hangeureut/screens/splash_screen/splash_page.dart';
import 'package:provider/provider.dart';
import 'constants.dart';
import 'screens/start_screen/start_page.dart';
import 'package:kakao_flutter_sdk_auth/kakao_flutter_sdk_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:flutter_state_notifier/flutter_state_notifier.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  KakaoSdk.init(nativeAppKey: '14abcd5634ab50141040de728a81c496');
  runApp(Hangeureut());
}

class Hangeureut extends StatelessWidget {
  const Hangeureut({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthRepository>(
          create: (context) => AuthRepository(
              firebaseFirestore: FirebaseFirestore.instance,
              firebaseAuth: fbAuth.FirebaseAuth.instance),
        ),
        Provider<ProfileRepository>(
          create: (context) => ProfileRepository(
            firebaseFirestore: FirebaseFirestore.instance,
          ),
        ),
        Provider<FriendRepository>(
          create: (context) => FriendRepository(
            firebaseFirestore: FirebaseFirestore.instance,
          ),
        ),
        StreamProvider<fbAuth.User?>(
            create: (context) => context.read<AuthRepository>().user,
            initialData: null),
        StateNotifierProvider<AuthProvider, AuthState>(
          create: (context) => AuthProvider(),
        ),
        StateNotifierProvider<SignupProvider, SignupState>(
          create: (context) => SignupProvider(),
        ),
        StateNotifierProvider<ProfileProvider, ProfileState>(
          create: (context) => ProfileProvider(),
        ),
        StateNotifierProvider<SearchFilterProvider, SearchFilterState>(
          create: (context) => SearchFilterProvider(),
        ),
        StateNotifierProvider<MenuProvider, MenuState>(
            create: (context) => MenuProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: StartPage(),
        routes: {
          OnBoarding1Page.routeName: (context) => OnBoarding1Page(),
          OnBoarding2Page.routeName: (context) => OnBoarding2Page(),
          OnBoarding3Page.routeName: (context) => OnBoarding3Page(),
          MainScreenPage.routeName: (context) => MainScreenPage(),
          SearchingPage.routeName: (context) => SearchingPage(),
          ReviewPage.routeName: (context) => ReviewPage(),
          SearchResult.routeName: (context) => SearchResult(),
          BasicScreenPage.routeName: (context) => BasicScreenPage(),
          SplashPage.routeName: (context) => SplashPage(),
          LocationSelectPage.routeName: (context) => LocationSelectPage()
        },
        theme: ThemeData(
            textTheme: TextTheme(
              bodyText1: TextStyle(fontFamily: 'Suit'),
              bodyText2: TextStyle(fontFamily: 'Suit'),
            ),
            scaffoldBackgroundColor: kBackgroundColor,
            accentColor: kHintTextColor),
      ),
    );
  }
}
