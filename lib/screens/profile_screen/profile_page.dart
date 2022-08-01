import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hangeureut/constants.dart';
import 'package:hangeureut/providers/profile/profile_provider.dart';
import 'package:provider/provider.dart';

import '../../providers/profile/profile_state.dart';
import '../../widgets/profile_icon_box.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);
  static const String routeName = '/profile';

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

enum ModifyingField { none, favorite, hate, alcohol, spicy }

class _ProfilePageState extends State<ProfilePage> {
  bool nameModify = false;
  bool idModify = false;
  bool modifyClicked = false;
  bool tasteAddClicked = false;
  ModifyingField modifyingField = ModifyingField.none;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          padding: EdgeInsets.zero,
          children: [
            Stack(
              children: [
                Container(
                  height: 188,
                  color: kBasicColor,
                ),
                SizedBox(
                  height: 260,
                ),
                Positioned(
                  top: 53,
                  left: 40,
                  right: 40,
                  child: Container(
                      child: ProfileCard(
                          onNameClicked: () {
                            print(nameModify);
                            setState(() {
                              nameModify = !nameModify;
                            });
                          },
                          onIdClicked: () {
                            setState(() {
                              idModify = !idModify;
                            });
                          },
                          onModifyClicked: () {
                            setState(() {
                              modifyClicked = !modifyClicked;
                              modifyingField = ModifyingField.none;
                            });
                          },
                          nameModify: nameModify,
                          idModify: idModify,
                          modifyClicked: modifyClicked)),
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            ScoreBar(),
            SizedBox(
              height: 28,
            ),
            TasteProfile(
              modifyClicked: modifyClicked,
              tasteAddClicked: tasteAddClicked,
              tasteAdd: () {
                setState(() {
                  tasteAddClicked = !tasteAddClicked;
                });
                if (tasteAddClicked) {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return TasteAddModal();
                      }).then((val) {
                    setState(() {
                      tasteAddClicked = false;
                    });
                  });
                }
              },
              modifyingField: modifyingField,
              onModifyingFieldChange: (val) {
                setState(() {
                  modifyingField = val;
                });
              },
              alcoholAdd: () {
                setState(() {
                  modifyingField = ModifyingField.alcohol;
                });

                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return AlcoholAddModal();
                    }).then((val) {
                  setState(() {
                    modifyingField = ModifyingField.none;
                  });
                });
              },
            ),
          ],
        ));
  }
}

class ProfileCard extends StatelessWidget {
  ProfileCard(
      {Key? key,
      required this.onNameClicked,
      required this.onIdClicked,
      required this.onModifyClicked,
      required this.nameModify,
      required this.idModify,
      required this.modifyClicked})
      : super(key: key);
  Function onNameClicked;
  Function onIdClicked;
  Function onModifyClicked;
  bool nameModify;
  bool idModify;
  bool modifyClicked;

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileState>().user;
    print(nameModify);
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
                color: Color(0xff000000).withOpacity(0.08),
                blurRadius: 6,
                spreadRadius: 0,
                offset: Offset(
                  0,
                  4,
                )),
          ]),
      height: 203,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 24,
          ),
          ProfileIconBox(content: "🍎"),
          SizedBox(
            height: 10,
          ),
          nameModify
              ? TextFormField(
                  onFieldSubmitted: (val) {
                    onNameClicked();
                    context.read<ProfileProvider>().setName(name: val);
                  },
                  textAlign: TextAlign.center,
                  initialValue: profile.name,
                  showCursor: true,
                  autofocus: true,
                  cursorColor: kSecondaryTextColor.withOpacity(0.7),
                  cursorWidth: 0.5,
                  style: TextStyle(
                      color: kSecondaryTextColor.withOpacity(0.7),
                      fontFamily: 'Suit',
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                  decoration: InputDecoration.collapsed(hintText: "이름 입력"),
                )
              : GestureDetector(
                  onTap: () {
                    onNameClicked();
                  },
                  child: Text(
                    profile.name,
                    style: TextStyle(
                        color: kSecondaryTextColor,
                        fontFamily: 'Suit',
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                  ),
                ),
          SizedBox(
            height: 3,
          ),
          Text("@${profile.id}",
              style: TextStyle(
                  color: kBasicTextColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Suit')),
          SizedBox(
            height: 20,
          ),
          modifyClicked
              ? Center(
                  child: GestureDetector(
                    onTap: () {
                      onModifyClicked();
                    },
                    child: Container(
                      width: 220,
                      height: 28,
                      decoration: BoxDecoration(
                          color: Color(0xffE5E5E5),
                          borderRadius: BorderRadius.circular(6)),
                      child: Center(
                        child: Text(
                          "수정 완료",
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Suit',
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        onModifyClicked();
                      },
                      child: Container(
                        width: 154,
                        height: 28,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(6)),
                        child: Center(
                          child: Text(
                            "프로필 수정",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Suit',
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 55,
                        height: 28,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: kSecondaryTextColor, width: 0.5),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6)),
                        child: Center(
                          child: Text(
                            "공유",
                            style: TextStyle(
                                color: kSecondaryTextColor,
                                fontFamily: 'Suit',
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
          SizedBox(
            height: 24,
          ),
        ],
      ),
    );
  }
}

class ScoreBar extends StatelessWidget {
  const ScoreBar({Key? key}) : super(key: key);
//TODO: 진짜 데이터로 바꿔야 함!!!!!!!!!
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "남긴 기록 12 ",
          style: TextStyle(
              color: kBasicColor,
              fontFamily: 'Suit',
              fontSize: 12,
              fontWeight: FontWeight.w700),
        ),
        Text("|"),
        Text(
          " 받은 좋아요 164",
          style: TextStyle(
              color: kSecondaryTextColor,
              fontFamily: 'Suit',
              fontSize: 12,
              fontWeight: FontWeight.w400),
        )
      ],
    );
  }
}

class TasteProfile extends StatelessWidget {
  const TasteProfile({
    Key? key,
    required this.modifyClicked,
    required this.tasteAddClicked,
    required this.tasteAdd,
    required this.modifyingField,
    required this.onModifyingFieldChange,
    required this.alcoholAdd,
  }) : super(key: key);

  final bool modifyClicked;
  final bool tasteAddClicked;
  final Function tasteAdd;
  final ModifyingField modifyingField;
  final Function onModifyingFieldChange;
  final Function alcoholAdd;

  @override
  Widget build(BuildContext context) {
    final onboarding = context.watch<ProfileState>().user.onboarding;
    final tasteKeyword = onboarding["tasteKeyword"];
    final Map alcoholType = onboarding["alcoholType"];
    String? alcoholTypeString;
    final favoriteFood = onboarding["favoriteFoods"]["1"];
    final hateFood = onboarding["hateFoods"]["1"];
    String spicyLevel = onboarding["spicyLevel"];
    String spicyLevelText = "";

    if (spicyLevel == "1") {
      spicyLevelText = "맵찔이";
    } else if (spicyLevel == "2") {
      spicyLevelText = "맵초딩";
    } else if (spicyLevelText == "3") {
      spicyLevelText = "맵고수";
    } else {
      spicyLevelText = "맵신";
    }

    alcoholType.forEach((key, value) {
      if (value) {
        if (alcoholTypeString == null) {
          alcoholTypeString = "${alcoholTypeMap[key]}";
          return;
        }
        alcoholTypeString = "${alcoholTypeString}, ${alcoholTypeMap[key]}";
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Row(
            children: [
              Text(
                "입맛 프로필",
                style: TextStyle(
                    color: kSecondaryTextColor,
                    fontFamily: 'Suit',
                    fontWeight: FontWeight.w600,
                    fontSize: 15),
              ),
              SizedBox(
                width: 7,
              ),
              modifyClicked
                  ? GestureDetector(
                      onTap: () {
                        tasteAdd();
                      },
                      child: Image.asset(
                        "images/profile_subtract.png",
                        width: 18,
                        color:
                            tasteAddClicked ? kBasicColor : kSecondaryTextColor,
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Container(
          height: 44,
          child: Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: ListView(scrollDirection: Axis.horizontal, children: [
              for (var keyword in keyWordList)
                RoundedButton(
                    iconPath: "${tasteProfileIconPath}/${keyword[0]}.png",
                    text: keyword[1],
                    selected: tasteKeyword[keyword[0]])
            ]),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30.0),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  onModifyingFieldChange(ModifyingField.favorite);
                },
                child: SubtitleRow(
                    field: ModifyingField.favorite,
                    iconPath: "images/icons/emoji-happy.png",
                    text: favoriteFood,
                    modifyClicked: modifyClicked,
                    selected: ModifyingField.favorite == modifyingField,
                    onFieldSubmit: () {
                      onModifyingFieldChange(ModifyingField.none);
                    }),
              ),
              GestureDetector(
                  onTap: () {
                    onModifyingFieldChange(ModifyingField.hate);
                  },
                  child: SubtitleRow(
                      field: ModifyingField.hate,
                      iconPath: "images/icons/emoji-sad.png",
                      text: hateFood,
                      modifyClicked: modifyClicked,
                      selected: ModifyingField.hate == modifyingField,
                      onFieldSubmit: () {
                        onModifyingFieldChange(ModifyingField.none);
                      })),
              GestureDetector(
                onTap: () {
                  onModifyingFieldChange(ModifyingField.alcohol);
                  alcoholAdd();
                },
                child: SubtitleRow(
                    field: ModifyingField.alcohol,
                    iconPath: "images/icons/favorite.png",
                    text: alcoholTypeString,
                    modifyClicked: modifyClicked,
                    selected: ModifyingField.alcohol == modifyingField,
                    onFieldSubmit: () {
                      onModifyingFieldChange(ModifyingField.none);
                    },
                    isAlcoholType: true),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 18,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 70,
                child: spicyTitleRow("images/icons/spicy1.png", spicyLevelText,
                    modifyClicked, ModifyingField.spicy == modifyingField),
              ),
              Expanded(
                  child: SpicyLevelBar(
                      level: int.parse(spicyLevel),
                      modifyClicked: modifyClicked,
                      selected: ModifyingField.spicy == modifyingField,
                      onChanged: (val) {
                        onModifyingFieldChange(ModifyingField.spicy);
                        onboarding["spicyLevel"] = val.toString();
                        context
                            .read<ProfileProvider>()
                            .setOnboarding(onboarding: onboarding);
                      }))
            ],
          ),
        ),
      ],
    );
  }
}

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    Key? key,
    required this.iconPath,
    required this.text,
    required this.selected,
  }) : super(key: key);
  final iconPath;
  final text;
  final selected;
  @override
  Widget build(BuildContext context) {
    return selected
        ? GestureDetector(
            child: Padding(
              padding: EdgeInsets.all(4),
              child: Container(
                width: 91,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: kBasicColor.withOpacity(0.3),
                        blurRadius: 3,
                        spreadRadius: 0,
                        offset: Offset(
                          0,
                          1,
                        )),
                  ],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        iconPath,
                        height: 18,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        text,
                        style: TextStyle(
                            fontFamily: 'Suit',
                            fontWeight: FontWeight.w300,
                            fontSize: 12,
                            color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : SizedBox.shrink();
  }
}

Widget spicyTitleRow(iconPath, String? text, bool modifying, bool selected) {
  return text == null
      ? SizedBox.shrink()
      : Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Image.asset(
              iconPath,
              height: 20,
            ),
            SizedBox(
              width: 7,
            ),
            Text(
              text,
              style: modifying
                  ? TextStyle(
                      fontFamily: 'Suit',
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: selected
                          ? kBasicColor
                          : kSecondaryTextColor.withOpacity(0.5))
                  : TextStyle(
                      fontFamily: 'Suit',
                      fontWeight: FontWeight.w400,
                      fontSize: 12),
            ),
          ],
        );
}

class SubtitleRow extends StatelessWidget {
  SubtitleRow(
      {Key? key,
      required this.field,
      required this.iconPath,
      required this.text,
      required this.modifyClicked,
      required this.selected,
      required this.onFieldSubmit,
      this.isAlcoholType = false})
      : super(key: key);
  ModifyingField field;
  String iconPath;
  String? text;
  bool modifyClicked;
  bool selected;
  Function onFieldSubmit;
  bool isAlcoholType;

  @override
  Widget build(BuildContext context) {
    Map onboarding = context.read<ProfileState>().user.onboarding;
    return text == null
        ? SizedBox.shrink()
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                iconPath,
                height: 22,
                color: modifyClicked
                    ? selected
                        ? null
                        : kSecondaryTextColor
                    : null,
              ),
              SizedBox(
                width: 7,
              ),
              !isAlcoholType
                  ? SizedBox(
                      width: 75,
                      child: selected & modifyClicked
                          ? TextFormField(
                              onFieldSubmitted: (val) {
                                if (field == ModifyingField.favorite) {
                                  onboarding["favoriteFoods"]["1"] = val;
                                } else if (field == ModifyingField.hate) {
                                  onboarding["hateFoods"]["1"] = val;
                                }
                                context
                                    .read<ProfileProvider>()
                                    .setOnboarding(onboarding: onboarding);
                                onFieldSubmit();
                              },
                              textAlign: TextAlign.left,
                              initialValue: text,
                              showCursor: true,
                              autofocus: true,
                              cursorColor: kBasicColor,
                              cursorWidth: 1,
                              style: TextStyle(
                                  color: kBasicColor,
                                  fontFamily: 'Suit',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700),
                              decoration: InputDecoration.collapsed(
                                  hintText: "음식",
                                  hintStyle: TextStyle(
                                      color: kSecondaryTextColor
                                          .withOpacity(0.3))),
                            )
                          : Text(
                              text ?? "",
                              overflow: TextOverflow.ellipsis,
                              style: modifyClicked
                                  ? TextStyle(
                                      fontFamily: 'Suit',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                      color:
                                          kSecondaryTextColor.withOpacity(0.5))
                                  : TextStyle(
                                      fontFamily: 'Suit',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12),
                            ),
                    )
                  //주종의 경우 더 넓은 사이즈드 박스 적용, 모달창 적용
                  : SizedBox(
                      width: 90,
                      child: Text(
                        text ?? "",
                        overflow: TextOverflow.ellipsis,
                        style: modifyClicked
                            ? selected
                                ? TextStyle(
                                    fontFamily: 'Suit',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                    color: kBasicColor)
                                : TextStyle(
                                    fontFamily: 'Suit',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                    color: kSecondaryTextColor.withOpacity(0.5))
                            : TextStyle(
                                fontFamily: 'Suit',
                                fontWeight: FontWeight.w400,
                                fontSize: 12),
                      ),
                    ),
            ],
          );
  }
}

class SpicyLevelBar extends StatelessWidget {
  const SpicyLevelBar(
      {Key? key,
      required this.level,
      required this.modifyClicked,
      required this.selected,
      required this.onChanged})
      : super(key: key);

  final level;
  final modifyClicked;
  final selected;
  final onChanged;
  @override
  Widget build(BuildContext context) {
    print(level);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 2,
        ),
        Container(
          height: 17,
          decoration: BoxDecoration(
            color: modifyClicked
                ? kSecondaryTextColor.withOpacity(0.1)
                : kBasicColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(45),
          ),
          child: Stack(
            children: [
              LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                final width = constraints.maxWidth / 4 * level;
                return Row(
                  children: [
                    Container(
                      height: 17,
                      width: width,
                      decoration: BoxDecoration(
                        color: modifyClicked
                            ? selected
                                ? kBasicColor
                                : kSecondaryTextColor.withOpacity(0.4)
                            : kBasicColor,
                        borderRadius: BorderRadius.circular(45),
                      ),
                    ),
                  ],
                );
              }),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                    overlayShape: SliderComponentShape.noOverlay,
                    trackHeight: 0,
                    thumbShape: SliderComponentShape.noThumb),
                child: Slider(
                  value: level.toDouble(),
                  min: 0.0,
                  max: 4.0,
                  onChanged: modifyClicked
                      ? (val) {
                          final value = val.round();
                          final input = value == 0 ? 1 : value;
                          onChanged(input);
                        }
                      : null,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 7,
        ),
        Text(
          spicyLevelText[level - 1],
          style: TextStyle(
              color: modifyClicked
                  ? selected
                      ? kBasicColor
                      : kSecondaryTextColor.withOpacity(0.7)
                  : kBasicColor,
              fontFamily: 'Suit',
              fontWeight: FontWeight.w600,
              fontSize: 12),
        )
      ],
    );
  }
}

class TasteAddModal extends StatefulWidget {
  const TasteAddModal({Key? key}) : super(key: key);

  @override
  State<TasteAddModal> createState() => _TasteAddModalState();
}

class _TasteAddModalState extends State<TasteAddModal> {
  @override
  Widget build(BuildContext context) {
    final onboarding = context.watch<ProfileState>().user.onboarding;
    Map tasteKeyword = onboarding["tasteKeyword"] ??
        {
          keyWordList[0]: false,
          keyWordList[1]: false,
          keyWordList[2]: false,
          keyWordList[3]: false,
          keyWordList[4]: false,
          keyWordList[5]: false,
          keyWordList[6]: false,
          keyWordList[7]: false,
          keyWordList[8]: false,
        };
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 29),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 39,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                for (int i = 0; i < 3; i++)
                  ModifyRoundedButton(
                    iconPath:
                        "${tasteProfileIconPath}/${keyWordList[i][0]}.png",
                    text: keyWordList[i][1],
                    selected: tasteKeyword[keyWordList[i][0]],
                    onClicked: () {
                      setState(() {
                        tasteKeyword[keyWordList[i][0]] =
                            !tasteKeyword[keyWordList[i][0]];
                      });
                    },
                  )
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                for (int i = 3; i < 6; i++)
                  ModifyRoundedButton(
                    iconPath:
                        "${tasteProfileIconPath}/${keyWordList[i][0]}.png",
                    text: keyWordList[i][1],
                    selected: tasteKeyword[keyWordList[i][0]],
                    onClicked: () {
                      setState(() {
                        tasteKeyword[keyWordList[i][0]] =
                            !tasteKeyword[keyWordList[i][0]];
                      });
                    },
                  ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                for (int i = 6; i < 9; i++)
                  ModifyRoundedButton(
                    iconPath:
                        "${tasteProfileIconPath}/${keyWordList[i][0]}.png",
                    text: keyWordList[i][1],
                    selected: tasteKeyword[keyWordList[i][0]],
                    onClicked: () {
                      setState(() {
                        tasteKeyword[keyWordList[i][0]] =
                            !tasteKeyword[keyWordList[i][0]];
                      });
                    },
                  )
              ],
            ),
            SizedBox(
              height: 67,
            ),
            GestureDetector(
              onTap: () {
                onboarding["tasteKeyword"] = tasteKeyword;
                context
                    .read<ProfileProvider>()
                    .setOnboarding(onboarding: onboarding);
                Navigator.pop(context);
              },
              child: Container(
                width: 114,
                height: 44,
                child: Center(
                  child: Text(
                    "완료",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Suit",
                        fontWeight: FontWeight.w700,
                        fontSize: 15),
                  ),
                ),
                decoration: BoxDecoration(
                    color: kSecondaryTextColor,
                    borderRadius: BorderRadius.circular(30)),
              ),
            ),
            SizedBox(
              height: 50,
            )
          ]),
    );
  }
}

class ModifyRoundedButton extends StatelessWidget {
  const ModifyRoundedButton({
    Key? key,
    required this.iconPath,
    required this.text,
    required this.selected,
    required this.onClicked,
  }) : super(key: key);
  final iconPath;
  final text;
  final selected;
  final onClicked;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onClicked(),
        child: Padding(
          padding: EdgeInsets.all(4),
          child: Container(
            width: 104,
            height: 39,
            decoration: BoxDecoration(
              color: selected ? kBasicColor : Colors.white,
              boxShadow: selected
                  ? null
                  : [
                      BoxShadow(
                          color: kBasicColor.withOpacity(0.3),
                          blurRadius: 3,
                          spreadRadius: 0,
                          offset: Offset(
                            0,
                            1,
                          )),
                    ],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    iconPath,
                    height: 18,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    text,
                    style: selected
                        ? TextStyle(
                            fontFamily: 'Suit',
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                            color: Colors.white)
                        : TextStyle(
                            fontFamily: 'Suit',
                            fontWeight: FontWeight.w300,
                            fontSize: 13,
                            color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AlcoholAddModal extends StatefulWidget {
  const AlcoholAddModal({Key? key}) : super(key: key);

  @override
  State<AlcoholAddModal> createState() => _AlcoholAddModalState();
}

class _AlcoholAddModalState extends State<AlcoholAddModal> {
  @override
  Widget build(BuildContext context) {
    final onboarding = context.watch<ProfileState>().user.onboarding;
    Map alcoholType = onboarding["alcoholType"] ?? defaultAlcoholType;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 31),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 38,
          ),
          Row(
            children: [
              RoundedAlcoholButton(
                  height: 56,
                  iconPath: "${tasteProfileIconPath}/${alcoholTypeList[0]}.png",
                  text: "소주",
                  onTap: () {
                    setState(() {
                      alcoholType[alcoholTypeList[0]] =
                          !alcoholType[alcoholTypeList[0]];
                    });
                  },
                  selected: alcoholType[alcoholTypeList[0]]),
              RoundedAlcoholButton(
                  height: 56,
                  iconPath: "${tasteProfileIconPath}/${alcoholTypeList[1]}.png",
                  text: "맥주",
                  onTap: () {
                    setState(() {
                      alcoholType[alcoholTypeList[1]] =
                          !alcoholType[alcoholTypeList[1]];
                    });
                  },
                  selected: alcoholType[alcoholTypeList[1]]),
              RoundedAlcoholButton(
                  height: 56,
                  iconPath: "${tasteProfileIconPath}/${alcoholTypeList[2]}.png",
                  text: "양주",
                  onTap: () {
                    setState(() {
                      alcoholType[alcoholTypeList[2]] =
                          !alcoholType[alcoholTypeList[2]];
                    });
                  },
                  selected: alcoholType[alcoholTypeList[2]]),
            ],
          ),
          Row(
            children: [
              RoundedAlcoholButton(
                  height: 56,
                  iconPath: "${tasteProfileIconPath}/${alcoholTypeList[3]}.png",
                  text: "전통주",
                  onTap: () {
                    setState(() {
                      alcoholType[alcoholTypeList[3]] =
                          !alcoholType[alcoholTypeList[3]];
                    });
                  },
                  selected: alcoholType[alcoholTypeList[3]]),
              RoundedAlcoholButton(
                  height: 56,
                  iconPath: "${tasteProfileIconPath}/${alcoholTypeList[4]}.png",
                  text: "와인",
                  onTap: () {
                    setState(() {
                      alcoholType[alcoholTypeList[4]] =
                          !alcoholType[alcoholTypeList[4]];
                    });
                  },
                  selected: alcoholType[alcoholTypeList[4]]),
              RoundedAlcoholButton(
                  height: 56,
                  iconPath: "${tasteProfileIconPath}/${alcoholTypeList[5]}.png",
                  text: "칵테일",
                  onTap: () {
                    setState(() {
                      alcoholType[alcoholTypeList[5]] =
                          !alcoholType[alcoholTypeList[5]];
                    });
                  },
                  selected: alcoholType[alcoholTypeList[5]]),
            ],
          ),
          SizedBox(
            height: 55,
          ),
          GestureDetector(
            onTap: () {
              onboarding["alcoholType"] = alcoholType;
              context
                  .read<ProfileProvider>()
                  .setOnboarding(onboarding: onboarding);
              Navigator.pop(context);
            },
            child: Container(
              width: 114,
              height: 44,
              child: Center(
                child: Text(
                  "완료",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Suit",
                      fontWeight: FontWeight.w700,
                      fontSize: 15),
                ),
              ),
              decoration: BoxDecoration(
                  color: kSecondaryTextColor,
                  borderRadius: BorderRadius.circular(30)),
            ),
          ),
          SizedBox(
            height: 55,
          )
        ],
      ),
    );
  }
}

class RoundedAlcoholButton extends StatelessWidget {
  const RoundedAlcoholButton(
      {Key? key,
      required this.iconPath,
      required this.text,
      required this.onTap,
      required this.selected,
      required double this.height})
      : super(key: key);
  final iconPath;
  final text;
  final onTap;
  final selected;
  final height;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(4),
          child: Container(
            height: height,
            decoration: BoxDecoration(
              color: selected ? kBasicColor : Colors.white,
              boxShadow: [
                BoxShadow(
                    color: kBasicColor.withOpacity(0.3),
                    blurRadius: 3,
                    spreadRadius: 0,
                    offset: Offset(
                      0,
                      1,
                    )),
              ],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    iconPath,
                    height: 18,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    text,
                    style: TextStyle(
                        fontFamily: 'Suit',
                        fontWeight:
                            selected ? FontWeight.w500 : FontWeight.w300,
                        fontSize: 13,
                        color: selected ? Colors.white : Colors.black),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
