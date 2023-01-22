import 'package:flutter/material.dart';

class CustomSliverAppBar extends StatefulWidget {
  final String title;

  CustomSliverAppBar(this.title);

  @override
  State<CustomSliverAppBar> createState() => _CustomSliverAppBarState();
}

class _CustomSliverAppBarState extends State<CustomSliverAppBar> {
  @override
  Widget build(BuildContext context) {
    //Take the screen size to adjust on Tablet and Smartphone
    double deviceHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Container(
                child: Row(
                  children: [
                    Image.asset('assets/cd.png',
                        scale: deviceHeight > 816.0 ? 11 : 14),
                    const SizedBox(width: 6),
                    Text(
                      widget.title,
                      style: Theme.of(context).textTheme.headline1!.copyWith(
                            color: Colors.white,
                            fontSize: deviceHeight > 816.0 ? 32 : 24,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
