import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Providers
import '../providers/tracks_provider.dart';

//Widgets
import '../widgets/empty_data_widget.dart';

//Screens
import '../screens/start_screen.dart';

class PlayAgainWidget extends StatefulWidget {
  @override
  State<PlayAgainWidget> createState() => _PlayAgainWidgetState();
}

class _PlayAgainWidgetState extends State<PlayAgainWidget> {
  @override
  Widget build(BuildContext context) {
    //Take the screen size to adjust on Tablet and Smartphone
    double deviceHeight = MediaQuery.of(context).size.height;
    final trackData = Provider.of<TracksProvider>(context, listen: false);
    final tracks = trackData.tracks
        .where((trackItem) => trackItem.lastPlayed == true)
        .toList();

    return tracks.length <= 0
        ? EmptyDataWidget()
        : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: tracks.length,
            itemBuilder: (ctx, i) => GestureDetector(
              onTap: () {
                //Send the PageIndex, TrackIndex, MiniPlayer Args and Start TrackURL
                //-----------------------------------------------------------
                var finalArgs;
                if (i < 10) {
                  finalArgs = '0000${i.toString()} 3';
                }
                if (i >= 10 && i < 100) {
                  finalArgs = '000${i.toString()} 3';
                }
                if (i >= 100 && i < 1000) {
                  finalArgs = '00${i.toString()} 3';
                }
                if (i >= 1000 && i < 10000) {
                  finalArgs = '00${i.toString()} 3';
                }
                //-----------------------------------------------------------

                Navigator.of(context).pushReplacementNamed(
                    StartScreen.routeName,
                    arguments: finalArgs);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    Container(
                      height: deviceHeight > 816.0 ? 80 : 60,
                      color: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: Image.network(
                                        tracks[i].coverUrl.toString()),
                                  ),
                                  Positioned(
                                    left: deviceHeight > 816.0 ? 54 : 44,
                                    bottom: 3,
                                    child: Icon(
                                      Icons.repeat_on_outlined,
                                      color: Colors.white,
                                      size: deviceHeight > 816.0 ? 24 : 14,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 10),
                              Container(
                                width: 220,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      tracks[i].musicTitle.toString(),
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                            color: Colors.white,
                                            fontSize:
                                                deviceHeight > 816.0 ? 18 : 14,
                                          ),
                                    ),
                                    Text(
                                      tracks[i].artistName.toString(),
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption!
                                          .copyWith(
                                            color: Colors.grey,
                                            fontSize:
                                                deviceHeight > 816.0 ? 18 : 14,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Icon(
                              Icons.play_arrow,
                              size: deviceHeight > 816.0 ? 35 : 26,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(color: Colors.white54),
                  ],
                ),
              ),
            ),
          );
  }
}
