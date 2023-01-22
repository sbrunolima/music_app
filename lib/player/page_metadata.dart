import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:provider/provider.dart';

//Providers
import '../providers/tracks_provider.dart';
import '../providers/track.dart';

//Widgets
import '../player/reduce_icon.dart';
import '../widgets/circular_progress_widget.dart';

//BiggerPlayer data
class PageMetadata extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String artist;
  final String studio;
  final int trackIndex;
  final String userId;
  bool isPressed;
  bool isLoading;

  PageMetadata({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.artist,
    required this.studio,
    required this.trackIndex,
    required this.userId,
    required this.isPressed,
    required this.isLoading,
  });

  @override
  State<PageMetadata> createState() => _PageMetadataState();
}

class _PageMetadataState extends State<PageMetadata> {
  @override
  Widget build(BuildContext context) {
    //Take the screen size to adjust on Tablet and Smartphone
    double deviceHeight = MediaQuery.of(context).size.height;
    final trackFavorite = Provider.of<Track>(context, listen: false);
    final trackData = Provider.of<TracksProvider>(context, listen: false);
    final tracks = trackData.tracks;
    return Column(
      children: [
        Stack(
          children: [
            Image.network(tracks[widget.trackIndex].coverUrl.toString()),
            BackdropFilter(
              filter: ImageFilter.blur(
                  sigmaX: deviceHeight > 816.0 ? 400 : 150,
                  sigmaY: deviceHeight > 816.0 ? 400 : 150),
              child: Container(
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.0)),
              ),
            ),
            Column(
              children: [
                ReduceIcon(),
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              offset: Offset(2, 4),
                              blurRadius: 4,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: CachedNetworkImage(
                            imageUrl: widget.imageUrl,
                            height: deviceHeight > 816.0 ? 750 : 350,
                            width: deviceHeight > 816.0 ? 830 : 350,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: deviceHeight > 816.0 ? 80 : 60),

            Container(
              width: deviceHeight > 816.0 ? 400 : 220,
              child: Center(
                child: TextScroll(
                  widget.title,
                  velocity: const Velocity(pixelsPerSecond: Offset(30, 0)),
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: Colors.white,
                        fontSize: deviceHeight > 816.0 ? 28 : 22,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(width: 10),
            //Favorite BUTTOM
            //---------------------------------------------------------
            Container(
              child: widget.isLoading
                  ? circularProgress(deviceHeight)
                  : IconButton(
                      splashColor: Colors.red,
                      onPressed: () {
                        setState(() {
                          widget.isPressed = !widget.isPressed;
                        });

                        //Set or Remove the track as Favorite on the Back-end
                        trackFavorite.toggleFavoriteStatus(
                          tracks[widget.trackIndex + 1].id.toString(),
                          widget.userId.toString(),
                        );
                      },
                      iconSize: deviceHeight > 816.0 ? 50 : 30,
                      color: tracks[widget.trackIndex].isFavorite &&
                              !widget.isPressed
                          ? Colors.redAccent
                          : tracks[widget.trackIndex].isFavorite &&
                                  widget.isPressed
                              ? Colors.white54
                              : !tracks[widget.trackIndex].isFavorite &&
                                      widget.isPressed
                                  ? Colors.red
                                  : Colors.white54,
                      icon: const Icon(
                        Icons.favorite_outlined,
                      ),
                    ),
            ),
            //End Favorite BUTTOM
            //---------------------------------------------------------
          ],
        ),
        Text(
          widget.artist,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                color: Colors.white,
                fontSize: deviceHeight > 816.0 ? 18 : 14,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          widget.studio,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                color: Colors.grey,
                fontSize: deviceHeight > 816.0 ? 18 : 14,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
