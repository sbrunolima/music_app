import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Providers
import '../providers/tracks_provider.dart';
import '../languages/app_language.dart';

//Widget
import '../widgets/title_widget.dart';

//Screens
import '../screens/start_screen.dart';

class PlayAgainMenu extends StatefulWidget {
  @override
  State<PlayAgainMenu> createState() => _PlayAgainMenuState();
}

class _PlayAgainMenuState extends State<PlayAgainMenu> {
  @override
  Widget build(BuildContext cotext) {
    //Take locale of Tablet and Smartphone
    final locale = Provider.of<LanguageProvider>(context);
    final trackData = Provider.of<TracksProvider>(context, listen: false);
    final tracks = trackData.tracks
        .where((trackItem) => trackItem.lastPlayed == true)
        .toList();
    final tracksLength = tracks.length == null
        ? 0
        : tracks.length >= 26
            ? 26
            : tracks.length;

    return tracksLength > 5
        ? Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(255, 106, 0, 1),
                  Color.fromRGBO(238, 9, 121, 1),
                  Colors.black12,
                ],
              ),
            ),
            child: Column(
              children: [
                TitleWidget(
                  locale.language[0].listenAgain!.isNotEmpty
                      ? locale.language[0].listenAgain!
                      : 'Listen again',
                  10,
                ),
                const SizedBox(height: 10),
                Container(
                  height: tracksLength < 10 ? 110 : 220,
                  child: GridView.count(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    shrinkWrap: true,
                    crossAxisCount: tracksLength < 10 ? 1 : 2,
                    physics: const ClampingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    children: [
                      for (int i = 0; i < tracksLength; i++)
                        GestureDetector(
                          onTap: () {
                            //Send the PageIndex, TrackIndex, MiniPlayer Args and Start TrackURL
                            //-----------------------------------------------------------
                            var finalArgs;
                            if (i < 10) {
                              finalArgs =
                                  '0000${i.toString()} 3 ${tracks[i].trackUrl}';
                            }
                            if (i >= 10 && i < 100) {
                              finalArgs =
                                  '000${i.toString()} 3 ${tracks[i].trackUrl}';
                            }
                            if (i >= 100 && i < 1000) {
                              finalArgs =
                                  '00${i.toString()} 3 ${tracks[i].trackUrl}';
                            }
                            if (i >= 1000 && i < 10000) {
                              finalArgs =
                                  '00${i.toString()} 3 ${tracks[i].trackUrl}';
                            }
                            //-----------------------------------------------------------

                            Navigator.of(context).pushReplacementNamed(
                                StartScreen.routeName,
                                arguments: finalArgs);
                          },
                          child: Stack(
                            children: [
                              Column(
                                children: [
                                  Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Image.network(
                                        tracks[i].coverUrl.toString(),
                                        width: 80,
                                        height: 80,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Container(
                                    width: 90,
                                    child: Text(
                                      tracks[i].musicTitle.toString(),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                              const Positioned(
                                left: 50,
                                bottom: 20,
                                child: Card(
                                  color: Colors.black26,
                                  child: Icon(
                                    Icons.repeat_on_outlined,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          )
        : Container();
  }
}
