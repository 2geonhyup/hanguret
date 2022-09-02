import 'package:flutter/material.dart';
import 'package:hangeureut/constants.dart';

List items = [
  {
    "imgPath": "images/dummies/image 10.png",
    "name": "프로마치",
    "location": "지금 내 위치에서 20m",
    "bookmarked": false
  },
  {
    "imgPath": "images/dummies/image 11.png",
    "name": "밀플랜비 고려대점",
    "location": "지금 내 위치에서 300m",
    "bookmarked": false
  },
  {
    "imgPath": "images/dummies/image 16.png",
    "name": "그릭데이 고려대점",
    "location": "지금 내 위치에서 20m",
    "bookmarked": false
  },
  {
    "imgPath": "images/dummies/image 17.png",
    "name": "고른햇살",
    "location": "지금 내 위치에서 300m",
    "bookmarked": false
  },
  {
    "imgPath": "images/dummies/image 14.png",
    "name": "땡스오트",
    "location": "지금 내 위치에서 20m",
    "bookmarked": false
  },
  {
    "imgPath": "images/dummies/image 15.png",
    "name": "호호식당",
    "location": "지금 내 위치에서 20m",
    "bookmarked": false
  },
];

class SearchResult extends StatefulWidget {
  const SearchResult({Key? key}) : super(key: key);
  static const String routeName = "/search_result";

  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: ListView(
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            children: [itemCard(items[0]), itemCard(items[1])],
          ),
          Row(
            children: [itemCard(items[2]), itemCard(items[3])],
          ),
          Row(
            children: [itemCard(items[4]), itemCard(items[5])],
          ),
        ],
      ),
    );
  }
}

Widget itemCard(Map item) {
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        children: [
          Container(
            child: Image.asset(item["imgPath"]),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                  width: double.infinity,
                ),
                Text(
                  item["name"],
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text(
                  item["location"],
                  style: TextStyle(color: kBasicTextColor, fontSize: 11),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                    width: 60,
                    height: 25,
                    decoration: BoxDecoration(
                        color: Color(0xfffcfaf6),
                        border: Border.all(color: kBasicTextColor, width: 0.3),
                        borderRadius: BorderRadius.circular(19)),
                    child: Center(
                      child: Text(
                        "길찾기",
                        style: TextStyle(color: kBasicTextColor, fontSize: 13),
                      ),
                    )),
              ],
            ),
          )
        ],
      ),
    ),
  );
}

Widget appBarCard(String name, bool clicked) {
  return Container(
    width: 100,
    height: 40,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color: clicked ? kBasicColor : Colors.white),
    child: Center(
      child: Text(
        name,
        style: TextStyle(
            fontSize: 13,
            fontWeight: clicked ? FontWeight.w700 : FontWeight.w300,
            color: clicked ? Colors.white : kHintTextColor),
      ),
    ),
  );
}

// appBar: PreferredSize(
// preferredSize: Size.fromHeight(50),
// child: Padding(
// padding: const EdgeInsets.only(top: 10.0, bottom: 10),
// child: ListView(
// scrollDirection: Axis.horizontal,
// children: [
// appBarCard("매운게 땡겨", false),
// appBarCard("값싸게 먹을래", true),
// appBarCard("분위기 챙길래", false),
// appBarCard("가볍게 먹을래", false),
// appBarCard("혼밥할거야", false),
// appBarCard("배에 기름칠", false),
// ],
// ),
// ),
// ),
