import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

//Widgets
import '../widgets/custom_sliver_appbar.dart';
import '../widgets/play_again_widget.dart';
import '../widgets/try_reconnect_widget.dart';

//Providers
import '../providers/tracks_provider.dart';
import '../languages/app_language.dart';

class PlayAgainScreen extends StatefulWidget {
  @override
  State<PlayAgainScreen> createState() => _PlayAgainScreenState();
}

class _PlayAgainScreenState extends State<PlayAgainScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  var _userId;
  var _isInit = true;

  //Load the tracks
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final User? user = auth.currentUser;
    _userId = user!.uid;
    if (_isInit) {
      Provider.of<TracksProvider>(context, listen: false)
          .loadTracks(_userId.toString())
          .then(
        (_) {
          setState(() {});
        },
      );
    }

    _isInit = false;
  }

  void loadData() async {
    await Future.delayed(const Duration(minutes: 1)).then(
      (_) => Provider.of<TracksProvider>(context, listen: false)
          .loadTracks(_userId.toString())
          .then(
        (_) {
          setState(() {
            print('Consultado LastPlayed!');
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //Load the data from Backend every 60 seconds
    loadData();
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
                      child: Column(
                        children: [
                          CustomSliverAppBar(
                              locale.language[0].listenAgain!.isNotEmpty
                                  ? locale.language[0].listenAgain!
                                  : 'Listen again'),
                          const SizedBox(height: 10),
                          PlayAgainWidget(),
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
}
