//TODO: 이미지 접근 관련 설정

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hangeureut/constants.dart';
import 'package:hangeureut/restaurants.dart';
import 'package:hangeureut/screens/basic_screen/basic_screen_page.dart';
import 'package:hangeureut/screens/restaurant_detail_screen/restaurant_detail_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:image_crop/image_crop.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import '../../widgets/bottom_navigation_bar.dart';
import '../../widgets/res_title.dart';

class ReviewPage extends StatefulWidget {
  ReviewPage({Key? key, required this.res, required this.score})
      : super(key: key);
  static const String routeName = "review";

  final res;
  int score;

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  int category = 0;
  int option = -1;
  bool scrollable = true;

  @override
  Widget build(BuildContext context) {
    List optionIconList = resFilterIcons[widget.res["category${category + 1}"]];
    List optionTextList = resFilterTexts[widget.res["category${category + 1}"]];
    print(optionTextList);
    List _items = [
      ResTitle(
          category: widget.res["category1"],
          icon: widget.res["tag1"],
          name: widget.res["name"],
          detail:
              "${resScoreIcons[widget.score - 1][0]} ${resScoreIcons[widget.score - 1][1]} (다시 선택)"),
      SizedBox(
        height: 18,
      ),
      widget.res["category2"] == null
          ? Center(
              child: CategoryTile(
                title: categoryTexts[widget.res["category1"]],
                selected: true,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CategoryTile(
                  title: categoryTexts[widget.res["category1"]],
                  selected: category == 0,
                  onTap: () {
                    setState(() {
                      category = 0;
                    });
                  },
                ),
                SizedBox(
                  width: 22,
                ),
                CategoryTile(
                  title: categoryTexts[widget.res["category2"]],
                  selected: category == 1,
                  onTap: () {
                    setState(() {
                      category = 1;
                    });
                  },
                )
              ],
            ),
      SizedBox(
        height: 34,
      ),
      ImageBox(onDrag: (val) {
        setState(() {
          scrollable = false;
        });
        print(scrollable);
      }, onDragEnd: (val) {
        setState(() {
          scrollable = true;
        });
      }),
      SizedBox(
        height: 15,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FilterTile(
            icon: optionIconList[0],
            text: optionTextList[0],
            selected: option == 0,
            onTap: () {
              setState(() {
                option = 0;
              });
            },
          ),
          FilterTile(
            icon: optionIconList[1],
            text: optionTextList[1],
            selected: option == 1,
            onTap: () {
              setState(() {
                option = 1;
              });
            },
          ),
          FilterTile(
            icon: optionIconList[2],
            text: optionTextList[2],
            selected: option == 2,
            onTap: () {
              setState(() {
                option = 2;
              });
            },
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FilterTile(
            icon: optionIconList[3],
            text: optionTextList[3],
            selected: option == 3,
            onTap: () {
              setState(() {
                option = 3;
              });
            },
          ),
          FilterTile(
            icon: optionIconList[4],
            text: optionTextList[4],
            selected: option == 4,
            onTap: () {
              setState(() {
                option = 4;
              });
            },
          ),
          FilterTile(
            icon: optionIconList[5],
            text: optionTextList[5],
            selected: option == 5,
            onTap: () {
              setState(() {
                option = 5;
              });
            },
          ),
        ],
      ),
      SizedBox(
        height: 50,
      ),
    ];
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 34.0, top: 54),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: kBasicTextColor.withOpacity(0.8),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Expanded(
            child: ListView.separated(
                physics: scrollable
                    ? ScrollPhysics()
                    : NeverScrollableScrollPhysics(),
                separatorBuilder: (_, __) => SizedBox.shrink(),
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: _items.length,
                itemBuilder: (context, int index) {
                  return _items[index];
                }),
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: OptionCard(
                    optionText: "취소",
                    optionColor: kThirdColor,
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    pushNewScreen(context,
                        screen: RestaurantDetailPage(
                            res: widget.res, option: false));
                  },
                  child: OptionCard(
                    optionText: "완료",
                    optionColor: Color(0xffc7c7c0),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  const CategoryTile(
      {Key? key, required this.title, required this.selected, this.onTap})
      : super(key: key);

  final title;
  final selected;
  final onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            "images/category_tile.png",
            width: 47,
            color: selected ? kSecondaryTextColor : Color(0xffC7C7C0),
          ),
          Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontFamily: 'Suit',
                fontSize: 12),
          )
        ],
      ),
    );
  }
}

class ImageBox extends StatefulWidget {
  const ImageBox({Key? key, required this.onDrag, required this.onDragEnd})
      : super(key: key);
  final onDrag;
  final onDragEnd;

  @override
  State<ImageBox> createState() => _ImageBoxState();
}

class _ImageBoxState extends State<ImageBox> {
  final cropKey = GlobalKey<CropState>();

  File? _file;
  File? _sample;
  File? _lastCropped;

  @override
  void dispose() {
    super.dispose();
    _file?.delete();
    _sample?.delete();
    _lastCropped?.delete();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 33.0),
      child: Container(
          clipBehavior: Clip.hardEdge,
          width: 324,
          height: _sample == null ? 196 : 324,
          decoration: BoxDecoration(
              color: Color(0xffececec),
              borderRadius: BorderRadius.circular(19)),
          child: _sample == null ? _buildOpeningImage() : _buildCropImage()),
    );
  }

  Widget _buildOpeningImage() {
    return Center(child: _buildOpenImage());
  }

  Widget _buildOpenImage() {
    return TextButton(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "images/download.png",
            width: 24,
            height: 24,
          ),
          Text(
            '사진 추가',
            style: TextStyle(
                fontWeight: FontWeight.w800,
                color: kSecondaryTextColor,
                fontFamily: 'Suit',
                fontSize: 15),
          ),
        ],
      ),
      onPressed: () => _openImage(),
    );
  }

  Future<void> _openImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    final file = File(pickedFile!.path);
    final sample = await ImageCrop.sampleImage(
        file: file, preferredWidth: 324, preferredHeight: 324);

    _sample?.delete();
    _file?.delete();
    setState(() {
      _sample = sample;
      _file = file;
    });
  }

  Widget _buildCropImage() {
    return GestureDetector(
      onTap: () => _openImage(),
      child: Transform.scale(
        scale: 1.03,
        child: Crop.file(
          _sample!,
          key: cropKey,
        ),
      ),
    );
  }
}

class FilterTile extends StatelessWidget {
  const FilterTile(
      {Key? key,
      required this.icon,
      required this.text,
      required this.selected,
      required this.onTap})
      : super(key: key);
  final icon;
  final text;
  final selected;
  final onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(3.25),
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
              boxShadow: selected
                  ? [
                      BoxShadow(
                          blurStyle: BlurStyle.outer,
                          offset: Offset(0, 1),
                          blurRadius: 3,
                          color: Colors.black.withOpacity(0.15))
                    ]
                  : null,
              borderRadius: BorderRadius.circular(22),
              color:
                  selected ? Color(0xffd9d9d9).withOpacity(0.2) : Colors.white),
          child: Column(
            children: [
              SizedBox(
                height: 25.71,
              ),
              Text(
                icon,
                style: TextStyle(fontSize: 24, height: 1),
              ),
              SizedBox(
                height: 19.92,
              ),
              Text(
                text,
                style: TextStyle(
                    fontSize: 12,
                    height: 1,
                    fontFamily: 'Suit',
                    fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
                    color: kSecondaryTextColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
