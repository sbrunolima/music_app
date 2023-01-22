import 'package:flutter/material.dart';
import 'package:jumping_dot/jumping_dot.dart';

//Return this dummy widget while loading the song
class AwaitLoadTrack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Image.asset(
            'assets/no_image.png',
            height: height > 816.0 ? 700 : 350,
            width: height > 816.0 ? 700 : 350,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 40),
        const JumpingDots(
          color: Colors.white,
          radius: 5,
        ),
        const SizedBox(height: 36),
      ],
    );
  }
}
