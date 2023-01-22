import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

//Providers
import '../providers/tracks_provider.dart';
import '../providers/track.dart';

//SCREENS
import '../screens/start_screen.dart';

class AlbumsWidget extends StatefulWidget {
  @override
  State<AlbumsWidget> createState() => _AlbumsWidgetState();
}

class _AlbumsWidgetState extends State<AlbumsWidget> {
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
    //Take the screen size to adjust on Tablet and Smartphone
    double deviceHeight = MediaQuery.of(context).size.height;
    final lastPlayed = Provider.of<Track>(context, listen: false);
    final trackData = Provider.of<TracksProvider>(context, listen: false);
    final tracks = trackData.tracks;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: tracks.length,
        itemBuilder: (ctx, i) => GestureDetector(
          onTap: () {
            //Set the track as LastPlayed on the BackEnd
            lastPlayed.toggleLastPlayed(tracks[i].id.toString(), _userId);

            //Send the PageIndex, TrackIndex, MiniPlayer Args and Start TrackURL
            //-----------------------------------------------------------
            var finalArgs;
            if (i < 10) {
              finalArgs = '0000${i.toString()} 1';
            }
            if (i >= 10 && i < 100) {
              finalArgs = '000${i.toString()} 1';
            }
            if (i >= 100 && i < 1000) {
              finalArgs = '00${i.toString()} 1';
            }
            if (i >= 1000 && i < 10000) {
              finalArgs = '00${i.toString()} 1';
            }
            //-----------------------------------------------------------

            Navigator.of(context).pushReplacementNamed(StartScreen.routeName,
                arguments: finalArgs);
          },
          child: Card(
            color: Colors.white10,
            child: Column(
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(4),
                      ),
                      child: Image.network(
                        tracks[i].coverUrl.toString(),
                        height: deviceHeight > 816.0 ? 150 : 110,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Image.asset(
                            'assets/loading_image.png',
                            height: deviceHeight > 816.0 ? 150 : 110,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.fill,
                          );
                        },
                      ),
                    ),
                    if (tracks[i].isFavorite)
                      Positioned(
                        left: 0,
                        right: deviceHeight > 816.0 ? 95 : 75,
                        top: deviceHeight > 816.0 ? 5 : 8,
                        bottom: 100,
                        child: Icon(
                          Icons.favorite_outlined,
                          color: Colors.red,
                          size: deviceHeight > 816.0 ? 35 : 24,
                        ),
                      ),
                    Positioned(
                      left: deviceHeight > 816.0 ? 40 : 25,
                      bottom: deviceHeight > 816.0 ? 40 : 25,
                      child: Image.asset(
                        'assets/play.png',
                        scale: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    tracks[i].musicTitle.toString(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontSize: deviceHeight > 816.0 ? 16 : 12,
                          color: Colors.white,
                        ),
                  ),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    'by: ${tracks[i].artistName.toString()}',
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.caption!.copyWith(
                          color: Colors.grey,
                          fontSize: deviceHeight > 816.0 ? 14 : 12,
                        ),
                  ),
                )
              ],
            ),
          ),
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: deviceHeight > 816.0 ? 5 : 3,
          mainAxisExtent: deviceHeight > 816.0 ? 220 : 165,
        ),
      ),
    );
  }
}
