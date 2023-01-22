import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:music_player/providers/track.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:text_scroll/text_scroll.dart';

//Providers
import '../providers/tracks_provider.dart';

//Widgets
import '../widgets/circular_progress_widget.dart';

class MiniPlayer extends StatefulWidget {
  final int trackIndex;
  final String playType;
  final bool miniPlayerOn;
  final String initialTrack;
  final String options;

  MiniPlayer(this.trackIndex, this.playType, this.miniPlayerOn,
      this.initialTrack, this.options);
  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  var _isInit = true;
  var _next = false;
  var _userId;
  bool _isPressed = false;
  var _isLoading = false;
  var _index;
  var _listSize;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    //If the user touch a new music item on the app, it will be played
    if (_isInit) {
      _audioPlayer.setReleaseMode(ReleaseMode.stop);
      _index = widget.trackIndex;
      setAudio(widget.initialTrack);
    }

    _isInit = false;
  }

  @override
  void initState() {
    super.initState();

    //Get and set the userID
    final User? user = _auth.currentUser;
    _userId = user!.uid;

    //Next Song
    _audioPlayer.onPlayerComplete.listen((state) async {
      await Future.delayed(const Duration(seconds: 3)).then((_) {
        _index++;
        if (_index <= _listSize) {
          setState(() => _index = _index);
        }
        if (_index > _listSize) {
          setState(() => _index = 0);
        }
      });
      _next = true;
    });

    //Take the track duration
    _audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    //Change the track pisition
    _audioPlayer.onPositionChanged.listen((newPositon) {
      setState(() {
        position = newPositon;
      });
    });

    //Verify the song state
    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });
  }

  //Start the track by the LINK
  Future setAudio([String? musicUrl]) async {
    setState(() {
      _isLoading = true;
    });
    setState(() => _isPressed = false);

    //Verify on the Backend if the song is favorite or not
    Provider.of<TracksProvider>(context, listen: false)
        .loadTracks(_userId.toString())
        .then(
          (_) => {
            setState(() {
              _isLoading = false;
            })
          },
        );
    await _audioPlayer.play(UrlSource(musicUrl!));
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final trackFavorite = Provider.of<Track>(context, listen: false);
    final trackData = Provider.of<TracksProvider>(context, listen: false);

    //Identify if the track is Favorite, Normal or LastlyPlayed on the Backend
    final tracks = widget.playType == '1'
        ? trackData.tracks
        : widget.playType == '2'
            ? trackData.tracks
                .where((trackItem) => trackItem.isFavorite == true)
                .toList()
            : widget.playType == '3'
                ? trackData.tracks
                    .where((trackItem) => trackItem.lastPlayed == true)
                    .toList()
                : trackData.findedTracks;

    //Take the number of tracks on the Backend
    _listSize = tracks.length - 1;

    //Auto Next Song
    if (_next) setAudio(tracks[_index].trackUrl.toString());

    //Set next to false, to prevent Play/Pause bug
    setState(() => _next = false);

    return Scaffold(
      backgroundColor: widget.miniPlayerOn ? Colors.black87 : Colors.black87,
      body: Container(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: widget.miniPlayerOn
                  ? SafeArea(
                      child: Stack(
                        children: [
                          //Background Image
                          //-----------------------------------------------------------
                          Image.network(tracks[_index].coverUrl.toString()),
                          BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 500, sigmaY: 500),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.0)),
                            ),
                          ),
                          //-----------------------------------------------------------

                          //Reduce MiniPlayer buttom
                          //-----------------------------------------------------------
                          Column(
                            children: [
                              const SizedBox(height: 30),
                              Row(
                                children: const [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15),
                                    child: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              //-----------------------------------------------------------

                              const SizedBox(height: 30),
                              Stack(
                                children: [
                                  //Album Image
                                  //-----------------------------------------------------------
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: Image.network(
                                      tracks[_index].coverUrl.toString(),
                                      fit: BoxFit.cover,
                                      height: 350,
                                      width: 350,
                                    ),
                                  ),
                                  //-----------------------------------------------------------

                                  //Favorite buttom
                                  //-----------------------------------------------------------
                                  Positioned(
                                    top: 0,
                                    left: 290,
                                    child: _isLoading
                                        ? circularProgress(0)
                                        : Card(
                                            color: Colors.white24,
                                            child: IconButton(
                                              splashColor: Colors.red,
                                              onPressed: () {
                                                setState(() {
                                                  _isPressed = !_isPressed;
                                                });

                                                //Set or Remove the track as Favorite on the BackEnd
                                                trackFavorite
                                                    .toggleFavoriteStatus(
                                                  tracks[_index].id.toString(),
                                                  _userId.toString(),
                                                );
                                              },
                                              iconSize: 30,
                                              icon: Icon(
                                                Icons.favorite_outlined,
                                                color: tracks[_index]
                                                            .isFavorite &&
                                                        !_isPressed
                                                    ? Colors.redAccent
                                                    : tracks[_index]
                                                                .isFavorite &&
                                                            _isPressed
                                                        ? Colors.white
                                                        : !tracks[_index]
                                                                    .isFavorite &&
                                                                _isPressed
                                                            ? Colors.red
                                                            : Colors.white,
                                              ),
                                            ),
                                          ),
                                  ),
                                  //-----------------------------------------------------------
                                ],
                              ),
                              const SizedBox(height: 20),
                              //Title, Artist
                              //-----------------------------------------------------------
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 260,
                                    child: Center(
                                      child: TextScroll(
                                        tracks[_index].musicTitle.toString(),
                                        velocity: const Velocity(
                                            pixelsPerSecond: Offset(30, 0)),
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    tracks[_index].artistName.toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(color: Colors.white),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    tracks[_index].studioName.toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption!
                                        .copyWith(color: Colors.grey),
                                  ),
                                ],
                              ),
                              //-----------------------------------------------------------

                              //Progress bar
                              //-----------------------------------------------------------
                              SliderTheme(
                                data: const SliderThemeData(
                                  thumbColor: Colors.white,
                                  trackHeight: 1,
                                  activeTrackColor: Colors.white,
                                  thumbShape: RoundSliderThumbShape(
                                    enabledThumbRadius: 5,
                                  ),
                                ),
                                child: Slider(
                                  min: 0,
                                  max: duration.inSeconds.toDouble(),
                                  value: position.inSeconds.toDouble(),
                                  onChanged: (value) async {
                                    //Find and change the track position
                                    //-----------------------------------------------------------
                                    final position =
                                        Duration(seconds: value.toInt());
                                    await _audioPlayer.seek(position);

                                    await _audioPlayer.resume();
                                    //-----------------------------------------------------------
                                  },
                                ),
                              ),
                              //-----------------------------------------------------------

                              //Track time progress
                              //-----------------------------------------------------------
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 26),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      position.toString().substring(2, 7),
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      duration.toString().substring(2, 7),
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              //-----------------------------------------------------------

                              //Play, Next and Previous buttons
                              //-----------------------------------------------------------
                              _isLoading
                                  ? circularProgress(0)
                                  : Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                              Icons.skip_previous,
                                              color: Colors.white,
                                            ),
                                            iconSize: 40,
                                            onPressed: () async {
                                              //Logit to the previous song
                                              //-----------------------------------------------------------
                                              int length = tracks.length - 1;
                                              if (_index > 0) {
                                                setState(() {
                                                  _index--;
                                                  setAudio(tracks[_index]
                                                      .trackUrl
                                                      .toString());
                                                });
                                              } else {
                                                _index = length;
                                                setAudio(tracks[_index]
                                                    .trackUrl
                                                    .toString());
                                              }
                                              //-----------------------------------------------------------
                                            },
                                          ),
                                          const SizedBox(width: 26),
                                          CircleAvatar(
                                            backgroundColor: Colors.white10,
                                            radius: 35,
                                            child: IconButton(
                                              icon: Icon(
                                                _isPlaying
                                                    ? Icons.pause
                                                    : Icons.play_arrow,
                                                color: Colors.white,
                                              ),
                                              iconSize: 50,
                                              onPressed: () async {
                                                if (_isPlaying) {
                                                  await _audioPlayer.pause();
                                                } else {
                                                  await _audioPlayer.resume();
                                                }
                                              },
                                            ),
                                          ),
                                          const SizedBox(width: 26),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.skip_next,
                                              color: Colors.white,
                                            ),
                                            iconSize: 40,
                                            onPressed: () async {
                                              //Logit to the next song
                                              //-----------------------------------------------------------
                                              int length = tracks.length - 1;
                                              if (_index < length) {
                                                setState(() {
                                                  _index++;
                                                  setAudio(tracks[_index]
                                                      .trackUrl
                                                      .toString());
                                                });
                                                trackFavorite.toggleLastPlayed(
                                                    tracks[_index]
                                                        .id
                                                        .toString(),
                                                    _userId);
                                              } else {
                                                _index = 0;
                                                setAudio(tracks[_index]
                                                    .trackUrl
                                                    .toString());
                                              }
                                              //-----------------------------------------------------------
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                              //-----------------------------------------------------------
                            ],
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //Track image
                            //-----------------------------------------------------------
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(2.5),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(2),
                                    child: Image.network(
                                      tracks[_index].coverUrl.toString(),
                                      height: 55,
                                      width: 55,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                //-----------------------------------------------------------

                                const SizedBox(width: 10),
                                //Track and Artist title
                                //-----------------------------------------------------------
                                Container(
                                  width: 180,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        tracks[_index].musicTitle.toString(),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        softWrap: false,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(
                                                fontSize: 14,
                                                color: Colors.white),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        tracks[_index].artistName.toString(),
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
                            //-----------------------------------------------------------

                            //Play and Next buttons
                            //-----------------------------------------------------------
                            Container(
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      _isPlaying
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    onPressed: () async {
                                      if (_isPlaying) {
                                        await _audioPlayer.pause();
                                      } else {
                                        await _audioPlayer.resume();
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.skip_next,
                                        color: Colors.white, size: 30),
                                    onPressed: () async {
                                      //Logic to the next song
                                      //-----------------------------------------------------------
                                      int length = tracks.length - 1;
                                      if (_index < length) {
                                        setState(() {
                                          _index++;
                                          setAudio(tracks[_index]
                                              .trackUrl
                                              .toString());
                                        });
                                        trackFavorite.toggleLastPlayed(
                                            tracks[_index].id.toString(),
                                            _userId);
                                      } else {
                                        _index = 0;
                                        setAudio(
                                            tracks[_index].trackUrl.toString());
                                      }
                                      //-----------------------------------------------------------
                                    },
                                  ),
                                ],
                              ),
                            ),
                            //-----------------------------------------------------------
                          ],
                        ),

                        //Progress bar
                        //-----------------------------------------------------------
                        SliderTheme(
                          data: SliderThemeData(
                            overlayShape: SliderComponentShape.noOverlay,
                            trackHeight: 1,
                            activeTrackColor: Colors.white,
                            thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 0),
                          ),
                          child: Slider(
                            min: 0,
                            max: duration.inSeconds.toDouble(),
                            value: position.inSeconds.toDouble(),
                            onChanged: (value) async {
                              final position = Duration(seconds: value.toInt());
                              await _audioPlayer.seek(position);

                              await _audioPlayer.resume();
                            },
                          ),
                        ),
                        //-----------------------------------------------------------
                      ],
                    ),
            )
          ],
        ),
      ),
    );
  }
}
