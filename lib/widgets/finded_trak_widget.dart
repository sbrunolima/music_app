import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

//Providers
import '../providers/tracks_provider.dart';

//Screens
import '../screens/start_screen.dart';

class FindedTrackWidget extends StatefulWidget {
  @override
  State<FindedTrackWidget> createState() => _FindedTrackWidgetState();
}

class _FindedTrackWidgetState extends State<FindedTrackWidget> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var _userId;

  @override
  void initState() {
    super.initState();

    final User? user = _auth.currentUser;
    _userId = user!.uid;
  }

  @override
  Widget build(BuildContext context) {
    final trackData = Provider.of<TracksProvider>(context, listen: false);
    final tracks = trackData.findedTracks;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tracks.length,
      itemBuilder: (ctx, i) => GestureDetector(
        onTap: () {
          //Send the PageIndex, TrackIndex, MiniPlayer Args and Start TrackURL
          //-----------------------------------------------------------
          var finalArgs;
          if (i < 10) {
            finalArgs = '0000${i.toString()} 4';
          }
          if (i >= 10 && i < 100) {
            finalArgs = '000${i.toString()} 4';
          }
          if (i >= 100 && i < 1000) {
            finalArgs = '00${i.toString()} 4';
          }
          if (i >= 1000 && i < 10000) {
            finalArgs = '00${i.toString()} 4';
          }
          //-----------------------------------------------------------

          Navigator.of(context).pushReplacementNamed(StartScreen.routeName,
              arguments: finalArgs);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Container(
                height: 60,
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
                              child:
                                  Image.network(tracks[i].coverUrl.toString()),
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
                                    .copyWith(color: Colors.white),
                              ),
                              Text(
                                tracks[i].artistName.toString(),
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Icon(
                        Icons.play_arrow,
                        size: 26,
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
