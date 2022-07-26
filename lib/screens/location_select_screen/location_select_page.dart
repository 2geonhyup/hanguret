import 'package:flutter/material.dart';
import 'package:hangeureut/constants.dart';
import 'package:hangeureut/models/search_model.dart';
import 'package:hangeureut/providers/filter/filter_provider.dart';
import 'package:hangeureut/providers/filter/filter_state.dart';
import 'package:provider/provider.dart';

class LocationSelectPage extends StatelessWidget {
  static const String routeName = "/location_select";
  const LocationSelectPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor2,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30, top: 30),
              child: Icon(
                Icons.arrow_back_ios,
                color: kBasicTextColor.withOpacity(0.8),
              ),
            ),
            SizedBox(height: 54),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    "images/location-marker.png",
                    color: Color(0xff3c3e24),
                    width: 18,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "지금 내 위치",
                    style: TextStyle(
                        fontFamily: 'Suit',
                        fontWeight: FontWeight.w700,
                        fontSize: 14),
                  ),
                  Text(
                    "로 찾기",
                    style: TextStyle(
                      fontFamily: 'Suit',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 26,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 23.0),
              child: Divider(
                thickness: 0.5,
                color: kHintTextColor.withOpacity(0.5),
              ),
            ),
            SizedBox(
              height: 32.5,
            ),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "학교",
                    style: TextStyle(
                        fontFamily: 'Suit',
                        fontWeight: FontWeight.w700,
                        fontSize: 14),
                  ),
                  Text(
                    "로 찾기",
                    style: TextStyle(
                      fontFamily: 'Suit',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 24,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LocationButton(
                      location: locationFilters[0],
                    ),
                    LocationButton(
                      location: locationFilters[1],
                    ),
                    LocationButton(
                      location: locationFilters[2],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LocationButton(
                      location: locationFilters[3],
                    ),
                    LocationButton(
                      location: locationFilters[4],
                    ),
                    LocationButton(
                      location: locationFilters[5],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LocationButton(
                      location: locationFilters[6],
                    ),
                    LocationButton(
                      location: locationFilters[7],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: SizedBox(
                        width: 100,
                        height: 100,
                      ),
                    )
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class LocationButton extends StatelessWidget {
  LocationButton({required this.location, Key? key}) : super(key: key);
  LocationFilter location;

  @override
  Widget build(BuildContext context) {
    List filters = context.watch<SearchFilterProvider>().locationFilters;
    final bool selected = filters.contains(location);
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: kBackgroundColor,
          border: Border.all(
              color: kSecondaryTextColor.withOpacity(0.2), width: 0.5),
          borderRadius: BorderRadius.all(
            Radius.circular(25),
          ),
        ),
        child: Column(
          children: [Text(location.name), Text(location.station)],
        ),
      ),
    );
  }
}
