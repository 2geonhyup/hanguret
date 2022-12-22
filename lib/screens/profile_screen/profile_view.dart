import 'package:flutter/material.dart';
import 'package:hangeureut/constants.dart';
import 'package:hangeureut/providers/profile/profile_provider.dart';
import 'package:hangeureut/providers/signup/signup_provider.dart';
import 'package:hangeureut/screens/profile_screen/modify_taste.dart';
import 'package:hangeureut/widgets/click_dialog.dart';
import 'package:hangeureut/widgets/error_dialog.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../models/custom_error.dart';
import '../../providers/profile/profile_state.dart';
import '../../widgets/profile_icon_box.dart';
import '../friend_screen/friend_recommend_page.dart';
import 'others_profile_page.dart';

enum ModifyingField { none, favorite, hate, alcohol, spicy }

class ProfileCard extends StatelessWidget {
  const ProfileCard(
      {Key? key,
      required this.onNameClicked,
      required this.onIdClicked,
      required this.onModifyClicked,
      required this.nameModify,
      required this.idModify,
      required this.modifyClicked,
      required this.watchFollow})
      : super(key: key);
  final Function onNameClicked;
  final Function onIdClicked;
  final Function onModifyClicked;
  final bool nameModify;
  final bool idModify;
  final bool modifyClicked;
  final bool watchFollow;

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileState>().user;
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
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
          GestureDetector(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    barrierColor: Colors.black.withOpacity(0.3),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20))),
                    builder: (BuildContext context) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Expanded(
                              child: GridView.count(
                                crossAxisCount: 4,
                                children: List.generate(
                                    78,
                                    (index) => TextButton(
                                          style: ButtonStyle(
                                            overlayColor:
                                                MaterialStateColor.resolveWith(
                                                    (states) => Colors.black
                                                        .withOpacity(0.05)),
                                          ),
                                          onPressed: () {
                                            context
                                                .read<ProfileProvider>()
                                                .setIcon(icon: index);
                                          },
                                          child: Center(
                                              child: Text(
                                            profileIcons[index],
                                            style:
                                                const TextStyle(fontSize: 40),
                                          )),
                                        )),
                              ),
                            ),
                            const SizedBox(
                              height: 50,
                            )
                          ],
                        ),
                      );
                    });
              },
              child: ProfileIconBox(content: profileIcons[profile.icon])),
          const SizedBox(
            height: 12,
          ),
          nameModify
              ? TextFormField(
                  onFieldSubmitted: (val) {
                    onNameClicked();
                    context.read<ProfileProvider>().setName(name: val);
                  },
                  keyboardType: TextInputType.name,
                  textAlign: TextAlign.center,
                  initialValue: profile.name,
                  showCursor: true,
                  cursorColor: kSecondaryTextColor.withOpacity(0.7),
                  cursorWidth: 0.5,
                  style: TextStyle(
                      color: kSecondaryTextColor.withOpacity(0.7),
                      fontFamily: 'Suit',
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                  decoration:
                      const InputDecoration.collapsed(hintText: "이름 입력"),
                )
              : GestureDetector(
                  onTap: () {
                    onNameClicked();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        profile.name,
                        style: const TextStyle(
                            color: kBasicColor,
                            fontFamily: 'Suit',
                            fontSize: 20,
                            fontWeight: FontWeight.w700),
                      ),
                      const Text(
                        "의 식탁",
                        style: TextStyle(
                            color: kSecondaryTextColor,
                            fontFamily: 'Suit',
                            fontSize: 20,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
          const SizedBox(
            height: 3,
          ),
          idModify
              ? TextFormField(
                  onFieldSubmitted: (val) {
                    onIdClicked();
                    context.read<ProfileProvider>().setCId(cID: val);
                  },
                  textAlign: TextAlign.center,
                  initialValue: profile.cId,
                  showCursor: true,
                  autofocus: true,
                  cursorColor: kSecondaryTextColor.withOpacity(0.7),
                  cursorWidth: 0.5,
                  style: TextStyle(
                      color: kBasicTextColor.withOpacity(0.7),
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Suit'),
                  decoration:
                      const InputDecoration.collapsed(hintText: "아이디 입력"),
                )
              : GestureDetector(
                  onTap: () {
                    onIdClicked();
                  },
                  child: Text("@${profile.cId}",
                      style: const TextStyle(
                          color: kBasicTextColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Suit')),
                ),
          const SizedBox(
            height: 20,
          ),
          modifyClicked
              ? Row(
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
                            color: const Color(0xffE5E5E5),
                            borderRadius: BorderRadius.circular(6)),
                        child: const Center(
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
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () async {
                        clickCancelDialog(
                            context: context,
                            title: "경고",
                            content: "정말로 탈퇴하시겠어요?",
                            clicked: () async {
                              try {
                                await context.read<ProfileProvider>().delUser();
                                context.read<SignupProvider>().signOutComp();
                                return false;
                              } on CustomError catch (e) {
                                errorDialog(context, e);
                                return false;
                              }
                            });
                      },
                      child: Container(
                        width: 55,
                        height: 28,
                        decoration: BoxDecoration(
                            color: const Color(0xff929292),
                            borderRadius: BorderRadius.circular(6)),
                        child: const Center(
                          child: Text(
                            "탈퇴",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Suit',
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    watchFollow
                        ? GestureDetector(
                            onTap: () {
                              pushNewScreen(
                                context,
                                screen: const FriendRecommendPage(),
                                withNavBar: false,
                              );
                            },
                            child: Container(
                              width: 154,
                              height: 28,
                              decoration: BoxDecoration(
                                  color: kBasicColor.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(6)),
                              child: const Center(
                                child: Text(
                                  "찜하기 추천",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Suit',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              onModifyClicked();
                            },
                            child: Container(
                              width: 180,
                              height: 28,
                              decoration: BoxDecoration(
                                  color: const Color(0xffe5e5e5),
                                  borderRadius: BorderRadius.circular(6)),
                              child: const Center(
                                child: Text(
                                  "프로필 수정",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Suit',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
          const SizedBox(
            height: 24,
          ),
        ],
      ),
    );
  }
}

class ScoreBar extends StatelessWidget {
  const ScoreBar(
      {Key? key,
      required this.onTap,
      required this.tapped,
      required this.followerCnt,
      required this.followingCnt})
      : super(key: key);
  final onTap;
  final bool tapped;
  final int followerCnt;
  final int followingCnt;
//TODO: 진짜 데이터로 바꿔야 함!!!!!!!!!
  @override
  Widget build(BuildContext context) {
    return tapped
        ? Center(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => onTap(null),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  "돌아가기",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Suit',
                      fontSize: 13,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => onTap(false),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    "나를 찜한 $followerCnt   |",
                    style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Suit',
                        fontSize: 13,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => onTap(true),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    "   내가 찜한 $followingCnt",
                    style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Suit',
                        fontSize: 13,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              )
            ],
          );
  }
}

class TasteProfile extends StatefulWidget {
  TasteProfile({
    Key? key,
    required this.modifyClicked,
    required this.modifyingField,
    required this.onModifyingFieldChange,
    required this.alcoholAdd,
    required this.onboarding,
  }) : super(key: key);

  final bool modifyClicked;
  final ModifyingField modifyingField;
  final Function onModifyingFieldChange;
  final Function alcoholAdd;
  Map onboarding;

  @override
  State<TasteProfile> createState() => _TasteProfileState();
}

class _TasteProfileState extends State<TasteProfile> {
  @override
  Widget build(BuildContext context) {
    Map tasteKeyword = widget.onboarding["tasteKeyword"];
    Map alcoholType = widget.onboarding["alcoholType"];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 44,
          child: Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: ListView(scrollDirection: Axis.horizontal, children: [
              widget.modifyClicked
                  ? GestureDetector(
                      onTap: () {
                        pushNewScreen(
                          context,
                          screen: const ModifyTaste(),
                          withNavBar: false,
                        ).then((value) => setState(() {}));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Container(
                          width: 48,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: kBasicColor.withOpacity(0.3),
                                  blurRadius: 6,
                                  spreadRadius: 0,
                                  offset: const Offset(
                                    0,
                                    1,
                                  )),
                            ],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: kSecondaryTextColor.withOpacity(0.2)),
                          ),
                          child: const Center(
                              child: Text(
                            "+",
                            style: TextStyle(
                                fontFamily: 'Suit',
                                fontWeight: FontWeight.w400,
                                fontSize: 17,
                                color: Color(0xff9e9f92)),
                          )),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
              for (var keyword in keyWordList2)
                RoundedButton(
                    iconPath: "$tasteProfileIconPath/${keyword[0]}.png",
                    text: keyword[1],
                    selected: tasteKeyword[keyword[0]],
                    modifying: widget.modifyClicked),
              for (var alcohol in alcoholTypeList2)
                RoundedButton(
                    iconPath: "$tasteProfileIconPath/${alcohol[0]}.png",
                    text: alcohol[1],
                    selected: alcoholType[alcohol[0]],
                    modifying: widget.modifyClicked)
            ]),
          ),
        ),
      ],
    );
  }
}

class RoundedButton extends StatelessWidget {
  const RoundedButton(
      {Key? key,
      required this.iconPath,
      required this.text,
      required this.selected,
      required this.modifying})
      : super(key: key);
  final String iconPath;
  final String text;
  final bool selected;
  final bool modifying;
  @override
  Widget build(BuildContext context) {
    return selected
        ? GestureDetector(
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Container(
                height: 36,
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: kBasicColor.withOpacity(0.3),
                          blurRadius: 3,
                          spreadRadius: 0,
                          offset: const Offset(
                            0,
                            1,
                          )),
                    ],
                    borderRadius: BorderRadius.circular(12),
                    border: modifying
                        ? Border.all(
                            color: kSecondaryTextColor.withOpacity(0.2),
                            width: 0.5)
                        : null),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        iconPath,
                        height: 18,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        text,
                        style: const TextStyle(
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
        : const SizedBox.shrink();
  }
}

class FriendModal extends StatefulWidget {
  const FriendModal(
      {Key? key,
      required this.option,
      required this.friendSearching,
      required this.searchedTap})
      : super(key: key);
  final bool option;
  final Function searchedTap;
  final bool friendSearching;

  @override
  State<FriendModal> createState() => _FriendModalState();
}

class _FriendModalState extends State<FriendModal> {
  final FocusNode _focus = FocusNode();
  List searchUserList = [];
  TextEditingController _textEditingController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _focus.addListener(() => _onFocusChange(_focus.hasFocus));
  }

  @override
  void dispose() {
    super.dispose();
    _focus.removeListener(() => _onFocusChange(_focus.hasFocus));
    _focus.dispose();
  }

  void _onFocusChange(bool hasFocus) {
    widget.searchedTap(hasFocus);
    return;
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.friendSearching) {
      _textEditingController.clear();
    }
    final following = context.watch<ProfileState>().user.followings;
    final follower = context.watch<ProfileState>().user.followers;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 29),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(
                  color: kSecondaryTextColor,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(25)),
            child: Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 15),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _textEditingController,
                      focusNode: _focus,
                      onChanged: (val) async {
                        try {
                          searchUserList = await context
                              .read<ProfileProvider>()
                              .searchUser(value: val);
                          setState(() {});
                        } on CustomError catch (e) {
                          errorDialog(context, e);
                        }
                      },
                      cursorColor: kBasicColor,
                      cursorWidth: 1,
                      // onFieldSubmitted: (val) {
                      //   _focus.requestFocus();
                      // },
                      // onEditingComplete: () {
                      //   _focus.requestFocus();
                      // },
                      decoration: InputDecoration(
                          hintText: '친구 이름',
                          hintStyle: TextStyle(
                              fontFamily: 'Suit',
                              fontWeight: FontWeight.w300,
                              fontSize: 14,
                              color: kSecondaryTextColor.withOpacity(0.4)),
                          border: InputBorder.none),
                      style: const TextStyle(
                          fontFamily: 'Suit',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: kSecondaryTextColor),
                    ),
                  ),
                  const Icon(
                    Icons.search,
                    color: kBasicColor,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        //TODO: 검색창에 focus되어 있다면, 검색 결과가 떠야함(배열 순서: 서로 찜->내가 찜->상대가 찜-> 상관없는 사람)
        for (var user in widget.friendSearching
            ? searchUserList
            : widget.option
                ? following
                : follower)
          Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: FriendRow(
              icon: user["icon"],
              name: user["name"],
              id: user["id"],
              cId: user["cId"],
            ),
          ),
        SizedBox(
          height: 600,
        )
      ],
    );
  }
}

class FriendRow extends StatelessWidget {
  const FriendRow(
      {Key? key,
      required this.icon,
      required this.name,
      required this.id,
      required this.cId})
      : super(key: key);
  final int icon;
  final String name;
  final String id;
  final String cId;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        pushNewScreen(context,
            screen: OthersProfilePage(
              userId: id,
            ),
            withNavBar: true);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(
            width: 33,
          ),
          FriendIconBox(content: profileIcons[icon]),
          const SizedBox(
            width: 12,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                    color: kSecondaryTextColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Suit'),
              ),
              const SizedBox(
                height: 3,
              ),
              Text(
                "@$cId",
                style: const TextStyle(
                    color: kSecondaryTextColor,
                    fontFamily: 'Suit',
                    fontWeight: FontWeight.w400,
                    fontSize: 11),
              )
            ],
          )
        ],
      ),
    );
  }
}

class FriendIconBox extends StatelessWidget {
  const FriendIconBox({Key? key, required this.content}) : super(key: key);
  final String content;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: Text(
        content,
        style: const TextStyle(fontSize: 27),
      )),
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xffe5e5e5).withOpacity(0.5),
        borderRadius: BorderRadius.circular(50),
      ),
    );
  }
}
