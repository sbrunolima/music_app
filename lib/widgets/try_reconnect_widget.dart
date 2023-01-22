import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

//Screens
import '../screens/start_screen.dart';
import '../screens/splash_screen.dart';

//Providers
import '../providers/tracks_provider.dart';
import '../languages/app_language.dart';

class TryReconnect extends StatefulWidget {
  @override
  State<TryReconnect> createState() => _TryReconnectState();
}

class _TryReconnectState extends State<TryReconnect> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool _isLoading = false;
  bool _isInit = true;
  var _userId;

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

  //Responsible for refreshing the UI
  Future<void> _refreshSongs(BuildContext context) async {
    final User? user = auth.currentUser;
    _userId = user!.uid;

    Provider.of<TracksProvider>(context, listen: false)
        .loadTracks(_userId.toString());
  }

  @override
  Widget build(BuildContext context) {
    final trackData = Provider.of<TracksProvider>(context, listen: false);
    //Take locale of Tablet and Smartphone
    final locale = Provider.of<LanguageProvider>(context);
    return Center(
      child: (trackData.tracks.isEmpty && !_isLoading)
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/cd.png', scale: 10),
                    const SizedBox(height: 8),
                    const Text(
                      'Musics',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/git.png', scale: 28),
                          const SizedBox(width: 3),
                          const Text(
                            'sbrunolima',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  (locale.language[0].locale!.isNotEmpty &&
                          locale.language[0].locale! == 'pt_BR')
                      ? 'Sem conexão com a Internet'
                      : 'No Internet Connection',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 4),
                Container(
                  width: 300,
                  child: Text(
                    (locale.language[0].locale!.isNotEmpty &&
                            locale.language[0].locale! == 'pt_BR')
                        ? 'Verifique sua conexão com a Internet e tente novamente.'
                        : 'Check your internet connection and try again.',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 17),
                SizedBox(
                  height: 50,
                  width: 200,
                  child: OutlinedButton(
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                      });

                      //Call _refreshSongs to try load the DATA
                      _refreshSongs(context);

                      //Await 5 seconds before try to load the page again
                      Future.delayed(const Duration(seconds: 5)).then((_) {
                        setState(() {
                          _isLoading = false;
                        });

                        Navigator.of(context)
                            .popAndPushNamed(StartScreen.routeName);
                      });
                    },
                    child: Text(
                      (locale.language[0].locale!.isNotEmpty &&
                              locale.language[0].locale! == 'pt_BR')
                          ? 'RECARREGAR'
                          : 'TRY AGAIN',
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                    ),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.grey.shade700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      side: const BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                ),
              ],
            )
          : SplashScreen(),
    );
  }
}
