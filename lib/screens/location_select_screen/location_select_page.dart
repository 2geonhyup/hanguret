import 'package:flutter/material.dart';
import 'package:hangeureut/constants.dart';
import 'package:hangeureut/models/search_model.dart';
import 'package:hangeureut/providers/filter/filter_provider.dart';
import 'package:hangeureut/providers/filter/filter_state.dart';
import 'package:hangeureut/screens/main_screen/main_screen_page.dart';
import 'package:hangeureut/screens/serching_screen/searching_page.dart';
import 'package:provider/provider.dart';

class LocationSelectPage extends StatelessWidget {
  static const String routeName = "/location_select";
  const LocationSelectPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor2,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30, top: 60),
            child: GestureDetector(
              onTap: () =>
                  Navigator.popAndPushNamed(context, MainScreenPage.routeName),
              child: Icon(
                Icons.arrow_back_ios,
                color: kBasicTextColor.withOpacity(0.8),
              ),
            ),
          ),
          SizedBox(height: 50),
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
            height: 24,
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
                  LocationButton(
                    location: locationFilters[8],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 60,
          ),
          Center(
            child: GestureDetector(
              child: Container(
                width: 114,
                height: 44,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(50)),
                child: Center(
                  child: Text(
                    "바로 찾기",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LocationButton extends StatelessWidget {
  LocationButton({required this.location, Key? key}) : super(key: key);
  LocationFilter location;

  @override
  Widget build(BuildContext context) {
    Filter filter = context.watch<SearchFilterState>().filter;
    final bool selected = filter.locationFilter == location;
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: GestureDetector(
        //여기에서 필터 체인지 (location리스트로 되어 있는데 고쳐야함)
        onTap: () {
          Filter newFilter = Filter(
              mainFilter: filter.mainFilter,
              subFilterList: filter.subFilterList,
              locationFilter: location);

          context.read<SearchFilterProvider>().changeFilter(newFilter);
        },
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: Offset(0, 1))
            ],
            color: selected ? kBackgroundColor : Color(0xFFFAF8F5),
            border: selected
                ? Border.all(
                    color: kSecondaryTextColor.withOpacity(0.2), width: 0.5)
                : null,
            borderRadius: BorderRadius.all(
              Radius.circular(25),
            ),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  location.station,
                  style: TextStyle(
                      fontFamily: 'Suit',
                      fontWeight: FontWeight.w300,
                      fontSize: 10),
                ),
                Text(
                  location.name,
                  style: TextStyle(
                      fontFamily: 'Suit',
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: stationColor[location.station]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
