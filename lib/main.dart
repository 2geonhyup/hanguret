import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:hangeureut/providers/auth/auth_provider.dart';
import 'package:hangeureut/providers/auth/auth_state.dart';
import 'package:hangeureut/providers/contents/content_provider.dart';
import 'package:hangeureut/providers/contents/content_state.dart';
import 'package:hangeureut/providers/filter/filter_provider.dart';
import 'package:hangeureut/providers/filter/filter_state.dart';
import 'package:hangeureut/providers/friend/recommend_friend_provider.dart';
import 'package:hangeureut/providers/friend/recommend_friend_state.dart';
import 'package:hangeureut/providers/navbar/navbar_provider.dart';
import 'package:hangeureut/providers/navbar/navbar_state.dart';
import 'package:hangeureut/providers/news/news_provider.dart';
import 'package:hangeureut/providers/news/news_state.dart';
import 'package:hangeureut/providers/profile/profile_provider.dart';
import 'package:hangeureut/providers/profile/profile_state.dart';
import 'package:hangeureut/providers/restaurants/restaurants_provider.dart';
import 'package:hangeureut/providers/restaurants/restaurants_state.dart';
import 'package:hangeureut/providers/result/result_provider.dart';
import 'package:hangeureut/providers/result/result_state.dart';
import 'package:hangeureut/providers/signup/signup_provider.dart';
import 'package:hangeureut/providers/signup/signup_state.dart';
import 'package:hangeureut/repositories/auth_repository.dart';
import 'package:hangeureut/repositories/contents_repository.dart';
import 'package:hangeureut/repositories/friend_repository.dart';
import 'package:hangeureut/repositories/news_repository.dart';
import 'package:hangeureut/repositories/profile_repository.dart';
import 'package:hangeureut/repositories/restaurant_repository.dart';
import 'package:hangeureut/repositories/review_repository.dart';
import 'package:hangeureut/screens/basic_screen/basic_screen_page.dart';
import 'package:hangeureut/screens/friend_screen/friend_recommend_page.dart';
import 'package:hangeureut/screens/friend_screen/friends_page.dart';
import 'package:hangeureut/screens/main_screen/main_screen_page.dart';
import 'package:hangeureut/screens/on_boarding_screen/on_boarding1_page.dart';
import 'package:hangeureut/screens/on_boarding_screen/on_boarding2_page.dart';
import 'package:hangeureut/screens/on_boarding_screen/on_boarding3_page.dart';
import 'package:hangeureut/screens/profile_screen/modify_loction.dart';
import 'package:hangeureut/screens/result_screen/search_result.dart';
import 'package:hangeureut/screens/review_screen/review_page.dart';

import 'package:hangeureut/screens/splash_screen/splash_page.dart';
import 'package:kakao_flutter_sdk_auth/kakao_flutter_sdk_auth.dart';
import 'package:provider/provider.dart';

import 'constants.dart';
import 'firebase_options.dart';
import 'models/news_model.dart';
import 'screens/start_screen/start_page.dart';

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
        Provider<ReviewRepository>(
          create: (context) => ReviewRepository(
            firebaseFirestore: FirebaseFirestore.instance,
          ),
        ),
        Provider<RestaurantRepository>(
          create: (context) => RestaurantRepository(),
        ),
        Provider<NewsRepository>(
          create: (context) => NewsRepository(
            firebaseFirestore: FirebaseFirestore.instance,
          ),
        ),
        Provider<ContentsRepository>(
            create: (context) => ContentsRepository(
                firebaseFirestore: FirebaseFirestore.instance)),
        StreamProvider<fbAuth.User?>(
            create: (context) => context.read<AuthRepository>().user,
            initialData: null),
        StreamProvider<List<News>>(
            create: (context) => context.read<NewsRepository>().news,
            initialData: []),
        StateNotifierProvider<NewsProvider, NewsState>(
          create: (context) => NewsProvider(),
        ),
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
        StateNotifierProvider<RecommendFriendProvider, RecommendFriendState>(
          create: (context) => RecommendFriendProvider(),
        ),
        StateNotifierProvider<RestaurantsProvider, RestaurantsState>(
          create: (context) => RestaurantsProvider(),
        ),
        StateNotifierProvider<ResultProvider, ResultState>(
          create: (context) => ResultProvider(),
        ),
        StateNotifierProvider<NavBarProvider, NavBarState>(
          create: (context) => NavBarProvider(),
        ),
        StateNotifierProvider<ContentProvider, ContentState>(
          create: (context) => ContentProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: StartPage(),
        routes: {
          StartPage.routeName: (context) => StartPage(),
          OnBoarding1Page.routeName: (context) => OnBoarding1Page(),
          OnBoarding2Page.routeName: (context) => OnBoarding2Page(),
          OnBoarding3Page.routeName: (context) => OnBoarding3Page(),
          MainScreenPage.routeName: (context) => MainScreenPage(),
          SearchResult.routeName: (context) => SearchResult(),
          BasicScreenPage.routeName: (context) => BasicScreenPage(),
          SplashPage.routeName: (context) => SplashPage(),
          FriendRecommendPage.routeName: (context) => FriendRecommendPage(),
          FriendsPage.routeName: (context) => FriendsPage(),
          ModifyLocation.routeName: (context) => ModifyLocation(),
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
