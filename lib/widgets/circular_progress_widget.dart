import 'package:flutter/material.dart';
import 'package:jumping_dot/jumping_dot.dart';

Widget circularProgress(double deviceHeight) {
  return Container(
    height: deviceHeight > 816.0 ? 65 : 48,
    child: Padding(
      padding: EdgeInsets.all(deviceHeight > 816.0 ? 18 : 9),
      child: JumpingDots(
        color: Colors.purpleAccent,
        radius: 5,
      ),
    ),
  );
}
