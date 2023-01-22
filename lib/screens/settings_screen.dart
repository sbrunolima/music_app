import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

//Widgets
import '../widgets/custom_sliver_appbar.dart';
import '../personaldata/about_the_author.dart';
import '../personaldata/about_the_songs.dart';
import '../widgets/exit_app_pop_dialog.dart';
import '../widgets/version_widget.dart';
import '../widgets/try_reconnect_widget.dart';

//Providers
import '../providers/tracks_provider.dart';
import '../languages/app_language.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = 'settings-screen';

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  var _userId;
  var _isInit = true;

  //Load the tracks
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

  @override
  Widget build(BuildContext context) {
    //Take the screen size to adjust on Tablet and Smartphone
    double deviceHeight = MediaQuery.of(context).size.height;
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
                            locale.language[0].about!.isNotEmpty
                                ? locale.language[0].about!
                                : 'About',
                          ),
                          SizedBox(height: deviceHeight > 816.0 ? 10 : 0),
                          GestureDetector(
                            onTap: () => showModalBottomSheet(
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (context) => DraggableScrollableSheet(
                                initialChildSize: 0.95,
                                builder: (_, conttroller) => Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(10.0),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        children: [
                                          IconButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            icon: const Icon(
                                              Icons.keyboard_arrow_down,
                                              color: Colors.white,
                                              size: 26,
                                            ),
                                          ),
                                        ],
                                      ),
                                      AboutAuthor(),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            child: ListTile(
                              title: Row(
                                children: [
                                  Icon(Icons.person, color: Colors.orange),
                                  SizedBox(width: 5),
                                  Text(
                                    locale.language[0].aboutAuthor!.isNotEmpty
                                        ? locale.language[0].aboutAuthor!
                                        : 'About the Author',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(
                                          color: Colors.white,
                                          fontSize:
                                              deviceHeight > 816.0 ? 22 : 16,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: deviceHeight > 816.0 ? 10 : 0),
                          GestureDetector(
                            onTap: () => showModalBottomSheet(
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (context) => DraggableScrollableSheet(
                                initialChildSize: 0.95,
                                builder: (_, conttroller) => Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(10),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        children: [
                                          IconButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            icon: const Icon(
                                              Icons.keyboard_arrow_down,
                                              color: Colors.white,
                                              size: 26,
                                            ),
                                          ),
                                        ],
                                      ),
                                      AboutSongs(),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            child: ListTile(
                              title: Row(
                                children: [
                                  Icon(Icons.policy_rounded,
                                      color: Colors.orange),
                                  SizedBox(width: 5),
                                  Text(
                                    locale.language[0].aboutSongs!.isNotEmpty
                                        ? locale.language[0].aboutSongs!
                                        : 'About Songs/Usage Policy',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(
                                          color: Colors.white,
                                          fontSize:
                                              deviceHeight > 816.0 ? 22 : 16,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: deviceHeight > 816.0 ? 10 : 0),
                          GestureDetector(
                            onTap: () async {
                              versionWidget(context);
                            },
                            child: ListTile(
                              title: Row(
                                children: [
                                  Icon(Icons.update, color: Colors.orange),
                                  SizedBox(width: 5),
                                  Text(
                                    locale.language[0].version!.isNotEmpty
                                        ? locale.language[0].version!
                                        : 'Version',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(
                                          color: Colors.white,
                                          fontSize:
                                              deviceHeight > 816.0 ? 22 : 16,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: deviceHeight > 816.0 ? 10 : 0),
                          GestureDetector(
                            onTap: () async {
                              popUpDialog(context);
                            },
                            child: ListTile(
                              title: Row(
                                children: [
                                  Icon(Icons.exit_to_app, color: Colors.red),
                                  SizedBox(width: 5),
                                  Text(
                                    locale.language[0].exit!.isNotEmpty
                                        ? locale.language[0].exit!
                                        : 'Exit',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(
                                          color: Colors.white,
                                          fontSize:
                                              deviceHeight > 816.0 ? 22 : 16,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
