import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Providers
import '../providers/tracks_provider.dart';

class TitleWidget extends StatelessWidget {
  final String title;
  final double height;
  TitleWidget(this.title, this.height);

  @override
  Widget build(BuildContext context) {
    final trackData = Provider.of<TracksProvider>(context);
    final tracks = trackData.tracks
        .where((trackItem) => trackItem.isFavorite == true)
        .toList();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          SizedBox(
              height: tracks.length >= 0 || tracks.length <= 5 ? 10 : height),
          Row(
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headline1!.copyWith(
                      color: Colors.white,
                      fontSize: height > 816.0 ? 32 : 24,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
          const Divider(color: Colors.white),
        ],
      ),
    );
  }
}
