import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

//Widgets
import '../widgets/custom_sliver_appbar.dart';
import '../widgets/favorite_widget.dart';
import '../widgets/try_reconnect_widget.dart';

//Providers
import '../providers/tracks_provider.dart';
import '../languages/app_language.dart';

class ExploreScreen extends StatefulWidget {
  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  var _userId;
  var _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final User? user = auth.currentUser;
      _userId = user!.uid;

      Provider.of<TracksProvider>(context, listen: false)
          .loadTracks(_userId.toString())
          .then(
            (_) => {setState(() {})},
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
          setState(() {});
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
                              locale.language[0].favorites!.isNotEmpty
                                  ? locale.language[0].favorites!
                                  : 'Favorites'),
                          const SizedBox(height: 10),
                          FavoriteWidget(),
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
