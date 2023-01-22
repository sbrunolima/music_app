import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:rxdart/rxdart.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

//Providers
import '../providers/tracks_provider.dart';
import '../providers/track.dart';

//Player
import '../player/position_data.dart';
import '../player/miniplayer_metadata.dart';
import '../player/page_metadata.dart';
import '../player/reduce_icon.dart';
import '../player/await_load_track.dart';

//Widgets
import '../widgets/circular_progress_widget.dart';

//Player widget
class Player extends StatefulWidget {
  final int trackIndex;
  final String playType;
  final bool miniPlayerOn;

  Player(this.trackIndex, this.playType, this.miniPlayerOn);

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late AudioPlayer _audioPlayer;
  late ConcatenatingAudioSource _playlist;
  bool _isPressed = false;
  bool _isLoading = false;
  bool _isInit = true;
  bool _repeatSong = false;
  bool _shuffleSong = false;
  var _index;
  var _userId;

  @override
  void dispose() async {
    super.dispose();

    _audioPlayer.dispose();
  }

  //Verify on the Backend if the song is favorite or not
  void setFavorite() {
    setState(() {
      _isLoading = true;
      _isPressed = false;
    });

    Provider.of<TracksProvider>(context, listen: false)
        .loadTracks(_userId.toString())
        .then(
          (_) => {
            setState(() {
              _isLoading = false;
            })
          },
        );
  }

  //Load all the track according the PLAYTYPE
  void loadSongs() async {
    final trackData = Provider.of<TracksProvider>(context, listen: false);
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

    //Add all tracks to playlist
    _playlist.addAll(
      tracks
          .map(
            (song) => ConcatenatingAudioSource(
              children: [
                AudioSource.uri(
                  Uri.parse(song.trackUrl.toString()),
                  tag: MediaItem(
                    id: song.id.toString(),
                    title: song.musicTitle.toString(),
                    artist: song.artistName.toString(),
                    artUri: Uri.parse(song.coverUrl.toString()),
                    displayTitle: song.studioName.toString(),
                  ),
                ),
              ],
            ),
          )
          .toList(),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    //Initiate the song with the favorite status
    if (_isInit) {
      _index = widget.trackIndex;
      setFavorite();
      loadSongs();
      setAudio();
    }

    _isInit = false;
  }

  @override
  void initState() {
    super.initState();

    _playlist = ConcatenatingAudioSource(children: []);
    _audioPlayer = AudioPlayer();

    //Load the user ID to set on Back-end the data with the user ID
    final User? user = _auth.currentUser;
    _userId = user!.uid;
  }

  //Track position
  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        _audioPlayer.positionStream,
        _audioPlayer.bufferedPositionStream,
        _audioPlayer.durationStream,
        (position, bufferedPosition, duration) => PositionData(
          position,
          bufferedPosition,
          duration ?? Duration.zero,
        ),
      );

  //Responsible to play the track according the Index and PlayType
  Future<void> setAudio() async {
    //Used a Future to solve a bug on just_audio Package
    Future.delayed(const Duration(seconds: 1)).then((value) async {
      await _audioPlayer.setLoopMode(LoopMode.all);

      await _audioPlayer.setAudioSource(
        _playlist,
        initialIndex: widget.trackIndex,
      );
      await _audioPlayer.play();
    });
  }

  @override
  Widget build(BuildContext context) {
    //Take the screen size to adjust on Tablet and Smartphone
    double deviceHeight = MediaQuery.of(context).size.height;
    final lastPlayed = Provider.of<Track>(context, listen: false);
    final trackData = Provider.of<TracksProvider>(context, listen: false);

    //Load the Track according the PlayType
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

    return Scaffold(
      backgroundColor: widget.miniPlayerOn ? Colors.black87 : Colors.black87,
      body: Container(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: widget.miniPlayerOn
                  ? SafeArea(
                      //Full Screen PLAYER WIDGET
                      //---------------------------------------------------------
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          StreamBuilder<SequenceState?>(
                            stream: _audioPlayer.sequenceStateStream,
                            builder: ((context, snapshot) {
                              final state = snapshot.data;

                              if (state?.sequence.isEmpty ?? true) {
                                return Column(
                                  children: [
                                    //Load dummy Widget while loading the track
                                    ReduceIcon(),
                                    AwaitLoadTrack(),
                                  ],
                                );
                              }

                              final metadata =
                                  state!.currentSource!.tag as MediaItem;
                              return Column(
                                children: [
                                  //Image, Title, Artist DATA
                                  Stack(
                                    children: [
                                      PageMetadata(
                                        imageUrl: metadata.artUri.toString(),
                                        title: metadata.title,
                                        artist: metadata.artist ?? '',
                                        studio: metadata.displayTitle ?? '',
                                        trackIndex: _index,
                                        userId: _userId,
                                        isPressed: _isPressed,
                                        isLoading: _isLoading,
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            }),
                          ),
                          const SizedBox(height: 8),
                          //Progress bar
                          //---------------------------------------------------------
                          StreamBuilder<PositionData>(
                              stream: _positionDataStream,
                              builder: (context, snapshot) {
                                final positionData = snapshot.data;

                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          deviceHeight > 816.0 ? 40 : 26),
                                  child: ProgressBar(
                                    barHeight: 3,
                                    thumbRadius: 4,
                                    baseBarColor: Colors.black26,
                                    bufferedBarColor: Colors.grey[600],
                                    progressBarColor: Colors.white,
                                    thumbColor: Colors.white,
                                    timeLabelTextStyle: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    progress:
                                        positionData?.position ?? Duration.zero,
                                    buffered: positionData?.bufferedPosition ??
                                        Duration.zero,
                                    total:
                                        positionData?.duration ?? Duration.zero,
                                    onSeek: _audioPlayer.seek,
                                  ),
                                );
                              }),
                          //Progress Bar
                          //---------------------------------------------------------
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //Shuffle buttom
                              //---------------------------------------------------------
                              IconButton(
                                onPressed: _repeatSong
                                    ? null
                                    : () async {
                                        setState(() {
                                          _shuffleSong = !_shuffleSong;
                                        });

                                        //Set or Unset Shuffle mode
                                        _shuffleSong
                                            ? await _audioPlayer
                                                .setShuffleModeEnabled(
                                                    !_audioPlayer
                                                        .shuffleModeEnabled)
                                            : await _audioPlayer.shuffle();
                                      },
                                iconSize: deviceHeight > 816.0 ? 35 : 24,
                                color:
                                    _shuffleSong ? Colors.orange : Colors.white,
                                icon: const Icon(
                                  Icons.shuffle_rounded,
                                ),
                              ),
                              //End Shuffle buttom
                              //---------------------------------------------------------
                              const SizedBox(width: 20),
                              //Previous Buttom
                              //---------------------------------------------------------
                              IconButton(
                                onPressed: _repeatSong
                                    ? null
                                    : () {
                                        setState(() {
                                          _repeatSong = false;
                                          _isPressed = false;
                                        });
                                        _audioPlayer.seekToPrevious();
                                        int length = tracks.length - 1;
                                        _index = _audioPlayer
                                                .sequenceState!.currentIndex -
                                            1;

                                        if (_index < 0) {
                                          _index = length;
                                        }
                                        //Set the track as LastPlayed on the BackEnd
                                        lastPlayed.toggleLastPlayed(
                                            tracks[_index].id.toString(),
                                            _userId);

                                        //Aways load on Back-end to verify if the track is FAVORITE
                                        setFavorite();
                                      },
                                iconSize: deviceHeight > 816.0 ? 50 : 40,
                                color: Colors.white,
                                icon: const Icon(
                                  Icons.skip_previous,
                                ),
                              ),
                              //End Previous Buttom
                              //---------------------------------------------------------
                              const SizedBox(width: 20),
                              //Play BUTTOM
                              //---------------------------------------------------------
                              StreamBuilder<PlayerState>(
                                stream: _audioPlayer.playerStateStream,
                                builder: (context, snapshot) {
                                  final playerState = snapshot.data;
                                  final processingState =
                                      playerState?.processingState;
                                  final playing = playerState?.playing;
                                  if (!(playing ?? false)) {
                                    return CircleAvatar(
                                      backgroundColor: Colors.white10,
                                      radius: deviceHeight > 816.0 ? 40 : 30,
                                      child: IconButton(
                                        onPressed: _audioPlayer.play,
                                        iconSize:
                                            deviceHeight > 816.0 ? 50 : 40,
                                        color: Colors.white,
                                        icon: const Icon(Icons.play_arrow),
                                      ),
                                    );
                                  } else if (processingState !=
                                      ProcessingState.completed) {
                                    return CircleAvatar(
                                      backgroundColor: Colors.white10,
                                      radius: deviceHeight > 816.0 ? 40 : 30,
                                      child: IconButton(
                                        onPressed: _audioPlayer.pause,
                                        iconSize:
                                            deviceHeight > 816.0 ? 50 : 40,
                                        color: Colors.white,
                                        icon: const Icon(Icons.pause),
                                      ),
                                    );
                                  }

                                  return CircleAvatar(
                                    backgroundColor: Colors.white10,
                                    radius: deviceHeight > 816.0 ? 40 : 30,
                                    child: Icon(
                                      Icons.play_arrow,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                  );
                                },
                              ),
                              //End Play Buttom
                              //---------------------------------------------------------
                              const SizedBox(width: 20),
                              //Next BUTTOM
                              //---------------------------------------------------------
                              IconButton(
                                onPressed: _repeatSong
                                    ? null
                                    : () {
                                        setState(() {
                                          _repeatSong = false;
                                          _isPressed = false;
                                        });
                                        _audioPlayer.seekToNext();
                                        int length = tracks.length - 1;

                                        _index = _audioPlayer
                                                .sequenceState!.currentIndex +
                                            1;

                                        if (_index > length) {
                                          _index = 0;
                                        }
                                        //Set the track as LastPlayed on the BackEnd
                                        lastPlayed.toggleLastPlayed(
                                            tracks[_index].id.toString(),
                                            _userId);

                                        //Aways load on Back-end to verify if the track is FAVORITE
                                        setFavorite();
                                      },
                                iconSize: deviceHeight > 816.0 ? 50 : 40,
                                color: Colors.white,
                                icon: const Icon(
                                  Icons.skip_next,
                                ),
                              ),
                              //End Next BUTTOM
                              //---------------------------------------------------------
                              const SizedBox(width: 20),
                              //Repeat BUTTOM
                              //---------------------------------------------------------
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    _repeatSong = !_repeatSong;
                                  });

                                  //Set or Unset repeat mode
                                  _audioPlayer.setLoopMode(_repeatSong
                                      ? LoopMode.one
                                      : LoopMode.off);
                                },
                                iconSize: deviceHeight > 816.0 ? 35 : 24,
                                color:
                                    _repeatSong ? Colors.orange : Colors.white,
                                icon: const Icon(
                                  Icons.repeat,
                                ),
                              ),
                              //End Reapeat Buttom
                              //---------------------------------------------------------
                            ],
                          ),
                        ],
                      ),
                      //End Full Screen PLAYER WIDGET
                      //---------------------------------------------------------
                    )
                  : Column(
                      //MiniPlayer WIDGET
                      //-----------------------------------------------------------
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            StreamBuilder<SequenceState?>(
                              stream: _audioPlayer.sequenceStateStream,
                              builder: ((context, snapshot) {
                                final state = snapshot.data;
                                if (state?.sequence.isEmpty ?? true) {
                                  return const SizedBox();
                                }

                                final metadata =
                                    state!.currentSource!.tag as MediaItem;
                                return Column(
                                  children: [
                                    //Image, Title, Artist DATA
                                    MiniplaterMetadata(
                                      imageUrl: metadata.artUri.toString(),
                                      title: metadata.title,
                                      artist: metadata.artist ?? '',
                                      studio: metadata.displayTitle ?? '',
                                    ),
                                  ],
                                );
                              }),
                            ),
                            //Play and Next BUTTOM
                            //---------------------------------------------------------
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  StreamBuilder<PlayerState>(
                                    stream: _audioPlayer.playerStateStream,
                                    builder: (context, snapshot) {
                                      final playerState = snapshot.data;
                                      final processingState =
                                          playerState?.processingState;
                                      final playing = playerState?.playing;
                                      if (!(playing ?? false)) {
                                        //Play BUTTOM
                                        //---------------------------------------------------------
                                        return IconButton(
                                          onPressed: _audioPlayer.play,
                                          iconSize:
                                              deviceHeight > 816.0 ? 50 : 30,
                                          color: Colors.white,
                                          icon: const Icon(Icons.play_arrow),
                                        );
                                      } else if (processingState !=
                                          ProcessingState.completed) {
                                        return IconButton(
                                          onPressed: _audioPlayer.pause,
                                          iconSize:
                                              deviceHeight > 816.0 ? 50 : 30,
                                          color: Colors.white,
                                          icon: const Icon(Icons.pause),
                                        );
                                      }

                                      return const Icon(
                                        Icons.play_arrow_rounded,
                                        size: 50,
                                        color: Colors.white,
                                      );
                                      //End Play BUTTOM
                                      //---------------------------------------------------------
                                    },
                                  ),
                                  //Next BUTTOM
                                  //---------------------------------------------------------
                                  IconButton(
                                    onPressed: () {
                                      _audioPlayer.seekToNext();
                                      int length = tracks.length - 1;

                                      _index = _audioPlayer
                                              .sequenceState!.currentIndex +
                                          1;

                                      if (_index > length) {
                                        _index = 0;
                                      }
                                      //Set the track as LastPlayed on the BackEnd
                                      lastPlayed.toggleLastPlayed(
                                          tracks[_index].id.toString(),
                                          _userId);

                                      //Aways load on Back-end to verify if the track is FAVORITE
                                      setFavorite();
                                    },
                                    iconSize: deviceHeight > 816.0 ? 50 : 30,
                                    color: Colors.white,
                                    icon: const Icon(
                                      Icons.skip_next,
                                    ),
                                  ),
                                  //End Next BUTTOM
                                  //---------------------------------------------------------
                                ],
                              ),
                            ),
                          ],
                        ),
                        //End Play and Next BUTTOM
                        //---------------------------------------------------------
                      ],
                      //End MiniPlayer WIDGET
                      //-----------------------------------------------------------
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
