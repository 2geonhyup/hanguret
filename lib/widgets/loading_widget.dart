import 'package:flutter/material.dart';

import '../constants.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
            child: Image.asset(
          "images/fork.png",
          width: 30,
          color: kBasicColor.withOpacity(0.8),
        )),
        Center(
          child: SizedBox(
              width: 70,
              height: 70,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: kBasicColor.withOpacity(0.8),
              )),
        ),
      ],
    );
  }
}
