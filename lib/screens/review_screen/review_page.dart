//TODO: 이미지 접근 관련 설정

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:hangeureut/constants.dart';
import 'package:hangeureut/models/custom_error.dart';
import 'package:hangeureut/providers/profile/profile_state.dart';
import 'package:hangeureut/restaurants.dart';
import 'package:hangeureut/screens/basic_screen/basic_screen_page.dart';
import 'package:hangeureut/screens/restaurant_detail_screen/restaurant_detail_page.dart';
import 'package:hangeureut/widgets/error_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_crop/image_crop.dart';
import 'package:path_provider/path_provider.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';
import '../../repositories/review_repository.dart';
import '../../widgets/bottom_navigation_bar.dart';
import '../../widgets/custom_round_rect_slider_thumb_shape.dart';
import '../../widgets/res_title.dart';

class ReviewPage extends StatefulWidget {
  ReviewPage({
    Key? key,
    required this.res,
    required this.score,
    this.reviewId,
  }) : super(key: key);
  static const String routeName = "review";

  final res;
  int score;
  String? reviewId;

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  bool scoring = false;
  late int score;
  late double scrollScore;
  int category = 0;
  int option = -1;
  bool scrollable = true;

  final cropKey = GlobalKey<CropState>();

  File? _file;
  File? _sample;
  File? _lastCropped;

  @override
  void initState() {
    // TODO: implement initState
    score = widget.score;
    scrollScore = 5 - score.toDouble();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _file?.delete();
    _sample?.delete();
    _lastCropped?.delete();
  }

  Widget ImageBox({required onDrag, required onDragEnd}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 33.0),
      child: Container(
          clipBehavior: Clip.hardEdge,
          width: 324,
          height: _sample == null ? 196 : 324,
          decoration: BoxDecoration(
              color: Color(0xffececec),
              borderRadius: BorderRadius.circular(19)),
          child: _sample == null ? _buildOpenImage() : _buildCropImage()),
    );
  }

  Widget _buildOpenImage() {
    return Center(
      child: TextButton(
        style: ButtonStyle(
            overlayColor: MaterialStateProperty.all(Colors.transparent)),
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
      ),
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

  Future<void> _cropImage() async {
    final scale = cropKey.currentState!.scale;
    final area = cropKey.currentState?.area;

    if (area == null) {
      // cannot crop, widget is not setup
      return;
    }

    // scale up to use maximum possible number of pixels
    // this will sample image in higher resolution to make cropped image larger
    final sample = await ImageCrop.sampleImage(
      file: _file!,
      preferredSize: (2000 / scale).round(),
    );

    final file = await ImageCrop.cropImage(
      file: sample,
      area: area,
    );

    sample.delete();

    _lastCropped?.delete();
    _lastCropped = file;

    debugPrint('$file');
  }

  @override
  Widget build(BuildContext context) {
    List optionIconList = resFilterIcons[widget.res["category${category + 1}"]];
    List optionTextList = resFilterTexts[widget.res["category${category + 1}"]];
    print(optionTextList);
    List _items = [
      GestureDetector(
        onTap: () {
          setState(() {
            scoring = true;
          });
        },
        child: Padding(
          padding: EdgeInsets.only(top: 19),
          child: ResTitle(
              category: widget.res["category1"],
              icon: widget.res["tag1"],
              name: widget.res["name"],
              detail: scoring
                  ? null
                  : "${resScoreIcons[score - 1][0]} ${resScoreIcons[score - 1][1]} (다시 선택)"),
        ),
      ),
      SizedBox(
        height: 18,
      ),
      scoring
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 39.0),
              child: _ScoringBox(
                  onCompleted: () {
                    setState(() {
                      scoring = false;
                    });
                  },
                  score: score,
                  scrollScore: scrollScore,
                  onScrollEnd: (val) {
                    setState(() {
                      scrollScore = val.round().toDouble();
                      score = (5 - val.round()).toInt();
                    });
                  },
                  onScroll: (val) {
                    setState(() {
                      scrollScore = val;
                    });
                  }),
            )
          : SizedBox.shrink(),
      !scoring
          ? widget.res["category2"] == null
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
                )
          : SizedBox.shrink(),
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
                    if (_sample == null) {
                      errorDialog(context, CustomError(message: "사진을 선택해주세요!"));
                      return;
                    }
                    await _cropImage();
                    User user = context.read<ProfileState>().user;
                    await context.read<ReviewRepository>().reviewComplete(
                        userId: user.id,
                        userName: user.name,
                        resId: widget.res["id"],
                        score: widget.score,
                        imgFile: _lastCropped!,
                        icon: option,
                        date: DateTime.now());
                    pushNewScreen(context,
                        screen: BasicScreenPage(
                          initialIndex: 0,
                          page: RestaurantDetailPage(
                            resId: widget.res["id"],
                            option: false,
                          ),
                        ),
                        withNavBar: true);
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

class _ScoringBox extends StatelessWidget {
  const _ScoringBox({
    Key? key,
    required this.onCompleted,
    required this.score,
    required this.scrollScore,
    required this.onScroll,
    required this.onScrollEnd,
  }) : super(key: key);
  final onCompleted;
  final int score;
  final double scrollScore;
  final onScroll;
  final onScrollEnd;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 261,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 4),
                blurRadius: 17,
                color: Colors.black.withOpacity(0.08))
          ]),
      child: Column(
        children: [
          SizedBox(
            height: 31,
          ),
          Text(
            resScoreIcons[score - 1][0],
            style: TextStyle(
                height: 1,
                fontFamily: 'Suit',
                fontWeight: FontWeight.w800,
                fontSize: 45),
          ),
          SizedBox(
            height: 9,
          ),
          Text(
            resScoreIcons[score - 1][1],
            style: TextStyle(
                height: 1,
                fontFamily: 'Suit',
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: kSecondaryTextColor),
          ),
          SizedBox(
            height: 29,
          ),
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 34.0, right: 34, top: 5),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Color(0xffd9d9d9).withOpacity(0.5),
                  ),
                  height: 6,
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                    overlayShape: SliderComponentShape.noOverlay,
                    trackHeight: 0,
                    thumbColor: kBasicColor,
                    thumbShape: CustomRoundSliderThumbShape(
                      enabledThumbRadius: 8,
                      elevation: 0,
                    )),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: Slider(
                      value: scrollScore,
                      min: 0.0,
                      max: 4.0,
                      onChangeEnd: (val) {
                        onScrollEnd(val);
                      },
                      onChanged: (val) {
                        onScroll(val);
                      }),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 13,
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 48),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("5", style: ScoreTextStyle(5, score)),
                  Text("4", style: ScoreTextStyle(4, score)),
                  Text("3", style: ScoreTextStyle(3, score)),
                  Text("2", style: ScoreTextStyle(2, score)),
                  Text("1", style: ScoreTextStyle(1, score))
                ],
              )),
          SizedBox(
            height: 29,
          ),
          GestureDetector(
            onTap: onCompleted,
            child: Container(
              width: 92,
              height: 44,
              child: Center(
                  child: Text(
                "완료",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Suit',
                    color: kSecondaryTextColor,
                    fontSize: 15),
              )),
              decoration: BoxDecoration(
                  color: Color(0xffececec),
                  borderRadius: BorderRadius.circular(15)),
            ),
          ),
        ],
      ),
    );
  }
}

TextStyle ScoreTextStyle(num, score) {
  return num == score
      ? TextStyle(
          height: 1,
          fontWeight: FontWeight.w900,
          fontFamily: 'Suit',
          color: kBasicColor,
          fontSize: 14)
      : TextStyle(
          height: 1,
          fontWeight: FontWeight.w600,
          fontFamily: 'Suit',
          color: kSecondaryTextColor.withOpacity(0.7),
          fontSize: 14);
}
