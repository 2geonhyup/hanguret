//TODO: 이미지 접근 관련 설정

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hangeureut/constants.dart';
import 'package:hangeureut/screens/basic_screen/basic_screen_page.dart';
import 'package:image_picker/image_picker.dart';

import '../../widgets/bottom_navigation_bar.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({Key? key}) : super(key: key);
  static const String routeName = "review";

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  bool searchCompleted = false;
  String title = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.only(left: 30),
          child: GestureDetector(
              onTap: () =>
                  Navigator.popAndPushNamed(context, BasicScreenPage.routeName),
              child: kBasicBackIcon),
        ),
      ),
      body: ListView(
        children: [
          searchCompleted
              ? TitleCard(
                  title: title,
                )
              : SearchRestaurantBar(
                  callback: (val) {
                    setState(() {
                      searchCompleted
                          ? searchCompleted = false
                          : searchCompleted = true;
                      val == null ? null : title = val;
                    });
                  },
                ),
          searchCompleted ? StampPicker() : SizedBox.shrink(),
          SizedBox(
            height: 30,
          ),
          searchCompleted ? TextReview() : SizedBox.shrink(),
        ],
      ),
    );
  }
}

class SearchRestaurantBar extends StatefulWidget {
  SearchRestaurantBar({Key? key, required this.callback}) : super(key: key);
  final void Function(String?) callback;

  @override
  State<SearchRestaurantBar> createState() => _SearchRestaurantBarState();
}

class _SearchRestaurantBarState extends State<SearchRestaurantBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 200.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          height: 50,
          decoration: BoxDecoration(
              border: Border.all(
                color: kSecondaryTextColor,
                width: 1,
              ),
              borderRadius: BorderRadius.all(Radius.circular(16.0))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextFormField(
                  onFieldSubmitted: widget.callback,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(0),
                    hintText: "가게 이름을 입력해주세요.",
                    hintStyle: TextStyle(
                        fontFamily: 'Suit',
                        fontWeight: FontWeight.w400,
                        color: kSecondaryTextColor.withOpacity(0.5),
                        fontSize: 14),
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                ),
              ),
              Icon(
                Icons.search,
                color: kBasicColor,
                size: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TitleCard extends StatelessWidget {
  TitleCard({Key? key, required this.title}) : super(key: key);
  String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 60),
        Image.asset("images/icons/rounded_rice.png"),
        SizedBox(
          height: 15,
        ),
        Text(
          title,
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "2022년 5월 2일",
          style: TextStyle(
              fontSize: 12, color: kBasicColor, fontWeight: FontWeight.bold),
        ),
        Text("오늘의 한그릇 기록", style: TextStyle(fontSize: 12, color: kBasicColor)),
        SizedBox(
          height: 80,
          child: Divider(
            color: kBorderGreenColor.withOpacity(0.5),
            height: 0.5,
          ),
        ),
      ],
    );
  }
}

class ImageInput extends StatefulWidget {
  const ImageInput({Key? key}) : super(key: key);

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  final ImagePicker _picker = ImagePicker();
  XFile? _pickedImg;

  Future<void> getImg() async {
    final img = await _picker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      setState(() {
        _pickedImg = img;
      });
    }
  }

  Widget imgButton() {
    return GestureDetector(
      onTap: () async {
        await getImg();
      },
      child: Container(
        //TODO: 플렉서블하게 고쳐야 한다
        width: 310,
        height: 310,
        child: Text("click!"),
      ),
    );
  }

  Widget ImgCard(img) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(19),
          image: DecorationImage(
              fit: BoxFit.cover, image: FileImage(File(_pickedImg!.path)))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _pickedImg == null ? imgButton() : ImgCard(_pickedImg);
  }
}

class StampPicker extends StatefulWidget {
  const StampPicker({Key? key}) : super(key: key);

  @override
  State<StampPicker> createState() => _StampPickerState();
}

class _StampPickerState extends State<StampPicker> {
  List<bool> clickedList = [false, false, false, false, false, false];
  Widget reviewStamp(String imagePath, String name, bool clicked) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: clicked ? kBasicColor : Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(22),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(top: 30, child: Image.asset(imagePath)),
          Positioned(
              top: 65,
              child: Text(
                name,
                style: TextStyle(
                    color: clicked ? Colors.white : kBasicTextColor,
                    fontSize: 12),
              )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "스탬프로 리뷰",
                style: TextStyle(
                    fontSize: 14,
                    color: kBasicTextColor,
                    fontWeight: FontWeight.w700),
              ),
              Text(
                "여러 개 선택할 수 있어요",
                style: TextStyle(
                    fontSize: 11,
                    color: kBasicTextColor,
                    fontWeight: FontWeight.w100),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    clickedList[0] = !clickedList[0];
                  });
                },
                child: reviewStamp(
                    "images/icons/vibegood.png", "분위기가 좋아", clickedList[0]),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    clickedList[1] = !clickedList[1];
                  });
                },
                child: reviewStamp(
                    "images/icons/tastegood.png", "여기 맛집이네", clickedList[1]),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    clickedList[2] = !clickedList[2];
                  });
                },
                child: reviewStamp(
                    "images/icons/pricegood.png", "가격이 좋아", clickedList[2]),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    clickedList[3] = !clickedList[3];
                  });
                },
                child: reviewStamp(
                    "images/icons/bad.png", "좀 실망이야", clickedList[3]),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    clickedList[4] = !clickedList[4];
                  });
                },
                child: reviewStamp(
                    "images/icons/cleangood.png", "내부가 깨끗해", clickedList[4]),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    clickedList[5] = !clickedList[5];
                  });
                },
                child: reviewStamp(
                    "images/icons/servicegood.png", "서비스 친절해", clickedList[5]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TextReview extends StatefulWidget {
  const TextReview({Key? key}) : super(key: key);

  @override
  State<TextReview> createState() => _TextReviewState();
}

class _TextReviewState extends State<TextReview> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "텍스트로 리뷰",
            style: TextStyle(
                fontSize: 14,
                color: kBasicTextColor,
                fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 40,
            child: TextFormField(
              textAlign: TextAlign.left,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 15, bottom: 15),
                border: InputBorder.none,
                hintText: "원하는 경우에 입력해주세요!",
                hintStyle: TextStyle(
                    color: kHintTextColor.withOpacity(0.6), fontSize: 12),
              ),
            ),
            decoration: BoxDecoration(
              color: kSecondaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ],
      ),
    );
  }
}
