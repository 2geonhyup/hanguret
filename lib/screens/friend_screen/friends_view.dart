// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import '../../constants.dart';
import '../../widgets/profile_icon_box.dart';
import '../profile_screen/profile_page.dart';

class MyProfileCard extends StatelessWidget {
  MyProfileCard({required this.icon, required this.name, required this.id});
  final icon;
  // ignore: prefer_typing_uninitialized_variables
  final name;
  final id;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: kBasicColor,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
                color: const Color(0xff000000).withOpacity(0.08),
                blurRadius: 6,
                spreadRadius: 0,
                offset: const Offset(
                  0,
                  4,
                )),
          ]),
      height: 203,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 24,
          ),
          ProfileIconBox(content: profileIcons[icon]),
          const SizedBox(
            height: 10,
          ),
          Text(
            name,
            style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Suit',
                fontSize: 20,
                fontWeight: FontWeight.w700),
          ),
          const SizedBox(
            height: 3,
          ),
          Text("@$id",
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Suit')),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                pushNewScreenWithRouteSettings(
                  context,
                  screen: const ProfilePage(),
                  settings: const RouteSettings(name: ProfilePage.routeName),
                  withNavBar: true,
                );
              },
              child: Container(
                width: 220,
                height: 28,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6)),
                child: const Center(
                  child: Text(
                    "내 프로필 보기",
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Suit',
                        fontSize: 12,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 24,
          ),
        ],
      ),
    );
  }
}
