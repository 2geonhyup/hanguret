import 'package:flutter/material.dart';
import 'package:hangeureut/models/friend.dart';

import '../../constants.dart';
import '../../widgets/profile_icon_box.dart';

class FriendRequestDialog extends StatelessWidget {
  FriendRequestDialog({Key? key, required this.friend}) : super(key: key);

  MealFriend friend;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Container(
        width: 300,
        height: 456,
        child: Column(
          children: [
            SizedBox(
              height: 46,
            ),
            ProfileIconBox(content: profileIcons[friend.icon]),
            SizedBox(
              height: 10,
            ),
            Text(
              friend.name,
              style: TextStyle(
                  fontFamily: 'Suit',
                  color: kSecondaryTextColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 20),
            ),
            SizedBox(
              height: 3,
            ),
            Text(
              "@${friend.id}",
              style: TextStyle(
                  fontFamily: 'Suit',
                  color: kSecondaryTextColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 11),
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              "✉️친구 요정 메시지를 선택하세요",
              style: TextStyle(
                  fontFamily: 'Suit',
                  color: Color(0xff3f3d3a),
                  fontWeight: FontWeight.w600,
                  fontSize: 11),
            ),
            SizedBox(
              height: 13,
            ),
            GestureDetector(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(3.5),
                child: Container(
                  width: 223,
                  height: 34,
                  decoration: BoxDecoration(
                      color: kSecondaryTextColor,
                      borderRadius: BorderRadius.circular(13)),
                  child: Center(
                    child: Text(
                      "🍚 우리 밥 한끼 해요!",
                      style: TextStyle(
                          fontFamily: 'Suit',
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(3.5),
                child: Container(
                  width: 223,
                  height: 34,
                  decoration: BoxDecoration(
                      color: kSecondaryTextColor,
                      borderRadius: BorderRadius.circular(13)),
                  child: Center(
                    child: Text(
                      "🍰 커피 한 잔 할래요 ♪",
                      style: TextStyle(
                          fontFamily: 'Suit',
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(3.5),
                child: Container(
                  width: 223,
                  height: 34,
                  decoration: BoxDecoration(
                      color: kSecondaryTextColor,
                      borderRadius: BorderRadius.circular(13)),
                  child: Center(
                    child: Text(
                      "🍺 맥주 마시러 가자구",
                      style: TextStyle(
                          fontFamily: 'Suit',
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 52,
            ),
            Text(
              "밥친구를 맺으면 서로의 플래이스를 확인하고,",
              style: TextStyle(
                  fontFamily: 'Suit',
                  fontWeight: FontWeight.w400,
                  fontSize: 10,
                  color: Color(0xff696865)),
            ),
            Text(
              "친구의 식사 기록을 구경할 수 있습니다.",
              style: TextStyle(
                  fontFamily: 'Suit',
                  fontWeight: FontWeight.w400,
                  fontSize: 10,
                  color: Color(0xff696865)),
            )
          ],
        ),
      ),
    );
  }
}
