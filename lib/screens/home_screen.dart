import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:firebase_auth/firebase_auth.dart';

//Widgets
import '../widgets/play_again_menu.dart';
import '../widgets/custom_sliver_appbar.dart';
import '../widgets/album_widget.dart';
import '../widgets/all_songs_title_widget.dart';
import '../widgets/try_reconnect_widget.dart';

//Providers
import '../providers/tracks_provider.dart';
import '../languages/app_language.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home-screen';
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  var _userId;
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final User? user = auth.currentUser;
      _userId = user!.uid;
      setState(() {
        _isLoading = true;
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
    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    final trackData = Provider.of<TracksProvider>(context, listen: false);
    final locale = Provider.of<LanguageProvider>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: trackData.tracks.isEmpty
          ? TryReconnect()
          : SafeArea(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: _isLoading
                          ? loading(context, locale)
                          : Column(
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                                    color: Color.fromRGBO(255, 106, 0, 1),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          CustomSliverAppBar('Musics'),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                PlayAgainMenu(),
                                AllSongsTitleWidget(),
                                AlbumsWidget(),
                                const SizedBox(height: 70),
                              ],
                            ),
                    ),
                  )
                ],
              ),
            ),
    );
  }

  Widget loading(BuildContext context, var locale) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: MediaQuery.of(context).size.height - 500),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              locale.language[0].loading!.isNotEmpty
                  ? locale.language[0].loading!
                  : 'Loading',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            SizedBox(width: 4),
            JumpingDots(
              color: Colors.white,
              radius: 4,
            ),
          ],
        ),
      ],
    );
  }
}
