import 'package:flutter/material.dart';

//Icon widget
class ReduceIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Take the screen size to adjust on Tablet and Smartphone
    double deviceHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        const SizedBox(height: 26),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.white,
                size: deviceHeight > 816.0 ? 50 : 30,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
