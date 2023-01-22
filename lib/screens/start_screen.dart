import 'package:flutter/material.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

//Screens
import '../screens/home_screen.dart';
import '../screens/favorite_screen.dart';
import '../screens/settings_screen.dart';
import 'play_again_screen.dart';

//Player
import '../player/player.dart';

//Providers
import '../providers/tracks_provider.dart';
import '../languages/app_language.dart';

class StartScreen extends StatefulWidget {
  static const routeName = '/start-screen';
  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final _miniPlayerController = MiniplayerController();
  double _playerMinheight = 60.0;
  int _pageIndex = 0;
  bool _changePage = false;
  var _trackIndex;
  var _playType;
  var _miniPlayerOn = false;
  var _isInit = true;
  var _userId;

  final _screens = [
    HomeScreen(),
    ExploreScreen(),
    PlayAgainScreen(),
    SettingsScreen(),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    //Receive the track data to play
    if (_isInit) {
      final pageID = ModalRoute.of(context)!.settings.arguments;
      String arg = pageID.toString();
      if (pageID != null && arg.length > 3) {
        _pageIndex = int.parse(arg[0].toString());
        _trackIndex = arg.substring(1, 5);
        _playType = arg.substring(6, 7).trim();
      }
    }

    _isInit = false;
  }

  //Responsible for refreshing the UI
  Future<void> _refreshSongs(BuildContext context) async {
    final User? user = auth.currentUser;
    _userId = user!.uid;

    Provider.of<TracksProvider>(context, listen: false)
        .loadTracks(_userId.toString());
  }

  @override
  Widget build(BuildContext context) {
    //Take locale of Tablet and Smartphone
    final locale = Provider.of<LanguageProvider>(context);
    //Take the screen size to adjust on Tablet and Smartphone
    double deviceHeight = MediaQuery.of(context).size.height;
    double iconSize = deviceHeight > 816.0 ? 35 : 24;

    return Scaffold(
      backgroundColor: Colors.grey,
      body: RefreshIndicator(
        onRefresh: () => _refreshSongs(context),
        child: Stack(
          children: _screens
              .asMap()
              .map((i, screen) => MapEntry(
                    i,
                    Offstage(
                      offstage: _pageIndex != i,
                      child: screen,
                    ),
                  ))
              .values
              .toList()
            ..add(
              Offstage(
                offstage: _trackIndex == null,
                //Miniplayer
                child: Miniplayer(
                  controller: _miniPlayerController,
                  curve: Curves.fastOutSlowIn,
                  minHeight: deviceHeight > 816.0 ? 80 : _playerMinheight,
                  maxHeight: MediaQuery.of(context).size.height,
                  valueNotifier:
                      ValueNotifier(MediaQuery.of(context).size.height),
                  builder: ((height, percentage) {
                    if (_changePage) {
                      _miniPlayerController.animateToHeight(
                        duration: const Duration(milliseconds: 200),
                        state: PanelState.MIN,
                      );
                    }
                    if (_trackIndex == null) {
                      return const SizedBox.shrink();
                    }
                    if (height > _playerMinheight) {
                      _miniPlayerOn = true;
                    }
                    if (height <= _playerMinheight + 50.0) {
                      _miniPlayerOn = false;
                    }

                    _changePage = false;

                    //Returns the Player Widget
                    return Player(
                        int.parse(_trackIndex), _playType, _miniPlayerOn);
                  }),
                ),
              ),
            ),
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NavigationBarTheme(
            data: NavigationBarThemeData(
              elevation: 0,
              indicatorColor: Colors.transparent,
              labelTextStyle: MaterialStateProperty.all(
                Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Colors.white,
                      fontSize: deviceHeight > 816.0 ? 20 : 10,
                    ),
              ),
            ),
            child: NavigationBar(
              elevation: 0,
              height: deviceHeight > 816.0 ? 80 : 60,
              backgroundColor: Colors.black87,
              selectedIndex: _pageIndex,
              onDestinationSelected: (i) => setState(() {
                _pageIndex = i;
                _changePage = true;
              }),
              destinations: [
                NavigationDestination(
                    selectedIcon: Icon(
                      Icons.home,
                      color: Colors.white,
                      size: iconSize,
                    ),
                    icon: Icon(
                      Icons.home_outlined,
                      color: Colors.white,
                      size: iconSize,
                    ),
                    label: locale.language[0].home!.isNotEmpty
                        ? locale.language[0].home!
                        : 'Home'),
                NavigationDestination(
                    selectedIcon: Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: iconSize,
                    ),
                    icon: Icon(
                      Icons.favorite_outline_outlined,
                      color: Colors.white,
                      size: iconSize,
                    ),
                    label: locale.language[0].favorites!.isNotEmpty
                        ? locale.language[0].favorites!
                        : 'Favorites'),
                NavigationDestination(
                    selectedIcon: Icon(
                      Icons.repeat_on_rounded,
                      color: Colors.white,
                      size: iconSize,
                    ),
                    icon: Icon(
                      Icons.repeat,
                      color: Colors.white,
                      size: iconSize,
                    ),
                    label: locale.language[0].listenAgain!.isNotEmpty
                        ? locale.language[0].listenAgain!
                        : 'Listen again'),
                NavigationDestination(
                    selectedIcon: Icon(
                      Icons.menu_open,
                      color: Colors.white,
                      size: iconSize,
                    ),
                    icon: Icon(
                      Icons.menu,
                      color: Colors.white,
                      size: iconSize,
                    ),
                    label: locale.language[0].about!.isNotEmpty
                        ? locale.language[0].about!
                        : 'About'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
