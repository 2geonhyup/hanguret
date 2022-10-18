import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../providers/profile/profile_provider.dart';
import '../../widgets/profile_icon_box.dart';

class WelcomeDialog extends StatefulWidget {
  const WelcomeDialog({Key? key, required this.onMoreTap}) : super(key: key);
  final onMoreTap;

  @override
  State<WelcomeDialog> createState() => _WelcomeDialogState();
}

class _WelcomeDialogState extends State<WelcomeDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: Container(
          width: 300,
          height: 511,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const SizedBox(
                    height: 46,
                  ),
                  ProfileIconBox(content: "🍎"),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "반가워요!",
                    style: TextStyle(
                        color: kSecondaryTextColor,
                        fontFamily: 'Suit',
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    "밥친구를 맺으면 서로의 플레이스를 확인하고,",
                    style: TextStyle(
                        color: kSecondaryTextColor,
                        fontFamily: 'Suit',
                        fontSize: 10,
                        fontWeight: FontWeight.w400),
                  ),
                  const Text(
                    "친구의 식사 기록을 구경할 수 있습니다.",
                    style: TextStyle(
                        color: kSecondaryTextColor,
                        fontFamily: 'Suit',
                        fontSize: 10,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: 30,
                    width: 250,
                    child: Divider(
                      color: kBorderGreenColor.withOpacity(0.5),
                      thickness: 0.5,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      widget.onMoreTap();
                      // context.read<ProfileProvider>().setLogin();
                      // Navigator.pop(context);
                    },
                    child: Column(
                      children: const [
                        Text(
                          "친구 더 찾기",
                          style: TextStyle(
                              color: kSecondaryTextColor,
                              fontFamily: 'Suit',
                              fontSize: 10,
                              fontWeight: FontWeight.w500),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: kSecondaryTextColor,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  GestureDetector(
                    onTap: () {
                      context.read<ProfileProvider>().setLogin();
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 114,
                      height: 44,
                      decoration: BoxDecoration(
                          color: kBasicColor,
                          borderRadius: BorderRadius.circular(50)),
                      child: const Center(
                        child: Text(
                          "다음에 하기",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  )
                ],
              ),
            ],
          ),
        ));
  }
}
