import 'package:flutter/material.dart';
import 'package:hangeureut/screens/start_screen/start_view_model.dart';

import '../../constants.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  bool _top = false;
  bool progress = false;
  bool _visible = false;
  bool _detail = false;
  bool _kakao = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(const Duration(milliseconds: 600), () {
      setState(() {
        _top = true;
      });
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        _visible = true;
      });
    });

    Future.delayed(const Duration(milliseconds: 1100), () {
      setState(() {
        _detail = true;
      });
    });

    Future.delayed(const Duration(milliseconds: 1300), () {
      setState(() {
        _kakao = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // final authState = context.watch<AuthState>();
    // if (authState.authStatus == AuthStatus.authenticated) {
    //   Future.delayed(const Duration(milliseconds: 1500), () {
    //     //TODO: 이부분 전환 부자연스러운 것 고치기
    //     Navigator.popAndPushNamed(context, SplashPage.routeName);
    //   });
    // }
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              bottom: MediaQuery.of(context).size.height / 2.3,
              left: 0,
              right: 0,
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 800),
                opacity: _top ? 0 : 1,
                child: Column(children: [
                  Image.asset(
                    "images/main_icon.png",
                    width: 118,
                  ),
                ]),
              ),
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height / 2.4,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  AnimatedOpacity(
                    opacity: 1,
                    duration: Duration(milliseconds: 1000),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AnimatedSize(
                          duration: Duration(milliseconds: 300),
                          child: SizedBox(
                            height: _detail ? 40 : 10,
                            child: _detail
                                ? AnimatedAlign(
                                    duration: Duration(milliseconds: 1500),
                                    alignment: _detail
                                        ? Alignment.bottomCenter
                                        : Alignment.topCenter,
                                    child: Text(
                                      "오늘 당신을 위한",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: kBasicColor,
                                          fontFamily: "Cafe24"),
                                    ),
                                  )
                                : SizedBox.shrink(),
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Center(
                          child: AnimatedOpacity(
                            opacity: _visible ? 1.0 : 0.0,
                            duration: Duration(milliseconds: 500),
                            child: Text(
                              "한그릇",
                              style: kTitleStyle,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 60,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 80.0,
              left: 0,
              right: 0,
              child: AnimatedOpacity(
                opacity: _kakao ? 1 : 0,
                duration: Duration(milliseconds: 500),
                child: Center(child: KakaoLoginButton(
                  onTap: () {
                    setState(() {
                      progress = true;
                    });
                  },
                )),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class KakaoLoginButton extends StatelessWidget {
  KakaoLoginButton({
    Key? key,
    required Function this.onTap,
  }) : super(key: key);

  final onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170.0,
      child: GestureDetector(
          child: Image.asset('images/kakao_login_large_narrow.png'),
          onTap: () async {
            await loginButtonPressed(context);
            onTap();
          }),
    );
  }
}
