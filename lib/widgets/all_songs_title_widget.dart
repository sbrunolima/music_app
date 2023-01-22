import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Widgets
import '../widgets/title_widget.dart';

//Providers
import '../providers/tracks_provider.dart';
import '../languages/app_language.dart';

class AllSongsTitleWidget extends StatefulWidget {
  @override
  State<AllSongsTitleWidget> createState() => _AllSongsTitleWidgetState();
}

class _AllSongsTitleWidgetState extends State<AllSongsTitleWidget> {
  @override
  Widget build(BuildContext context) {
    //Take locale of Tablet and Smartphone
    final locale = Provider.of<LanguageProvider>(context);
    final trackData = Provider.of<TracksProvider>(context, listen: false);
    final tracks = trackData.tracks
        .where((trackItem) => trackItem.lastPlayed == true)
        .toList();
    return Column(
      children: [
        SizedBox(height: (tracks.length <= 5) ? 0 : 20),
        Container(
          decoration: (tracks.length <= 5)
              ? const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromRGBO(255, 106, 0, 1),
                      Colors.black12,
                    ],
                  ),
                )
              : const BoxDecoration(),
          child: TitleWidget(
            locale.language[0].allSongs!.isNotEmpty
                ? locale.language[0].allSongs!
                : 'All songs',
            30,
          ),
        ),
      ],
    );
  }
}
