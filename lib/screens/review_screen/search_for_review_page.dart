import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hangeureut/constants.dart';
import 'package:hangeureut/restaurants.dart';

class SearchForReviewPage extends StatefulWidget {
  const SearchForReviewPage({Key? key}) : super(key: key);
  static String routeName = "/search_for_review_page";

  @override
  State<SearchForReviewPage> createState() => _SearchForReviewPageState();
}

class _SearchForReviewPageState extends State<SearchForReviewPage> {
  String searchTerm = "";
  List relatedResults = [];

  Future<void> getRelated(val) async {
    if (val == "") return;
    relatedResults = [];
    for (var e in restaurantsDB) {
      final String name = e["name"]!.toString();
      if (name.contains(val)) {
        relatedResults.add(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            color: kBasicColor,
            child: Padding(
                padding: EdgeInsets.only(top: 220, left: 30, right: 23),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            height: 28,
                            decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1, color: Colors.white)),
                            ),
                            child: TextFormField(
                              onChanged: (val) async {
                                searchTerm = val;
                                await getRelated(val);
                                setState(() {});
                                print(relatedResults);
                              },
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "기록할 식당을 입력해주세요.",
                                  hintStyle: TextStyle(
                                      fontFamily: 'Suit',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15,
                                      color: Colors.white)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 21.0),
                          child: Image.asset(
                            "images/icons/searchbig.png",
                            width: 33,
                            height: 33,
                          ),
                        )
                      ],
                    ),
                    relatedResults == []
                        ? SizedBox(
                            height: 133,
                          )
                        : Container(
                            height: 258,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: relatedResults
                                    .map((e) => Text(e["name"]))
                                    .toList()),
                          ),
                  ],
                )),
          ),
          SizedBox(
            height: 43,
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 30.0,
            ),
            child: Text(
              "혹시 이곳을 기록하시나요?",
              style: TextStyle(
                  fontFamily: 'Suit',
                  color: kSecondaryTextColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}
