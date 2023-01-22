import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

//Providers
import './providers/tracks_provider.dart';
import './providers/track.dart';
import 'languages/app_language.dart';
import 'languages/auth_screen_locale.dart';
import 'languages/auth_form_locale.dart';

//Screens
import './screens/home_screen.dart';
import './screens/start_screen.dart';
import './screens/auth_screen.dart';
import './screens/splash_screen.dart';
import './screens/settings_screen.dart';

Future<void> main() async {
  //MiniPlayer notification
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    notificationColor: Colors.transparent,
    androidNotificationOngoing: true,
  );
  //Initialize the Splash Screen
  WidgetsFlutterBinding.ensureInitialized();

  //Keep the Splash Screen until initialization is not completed
  FlutterNativeSplash.removeAfter(initialization);

  runApp(MusicPlayer());
}

//Load resources
Future initialization(BuildContext? context) async {
  await Future.delayed(const Duration(seconds: 2));
}

class MusicPlayer extends StatefulWidget {
  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  @override
  void initState() {
    super.initState();

    Firebase.initializeApp().whenComplete(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => TracksProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Track(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => LanguageProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => AuthLocaleProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => FormLocaleProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Music Player',
        theme: ThemeData(primarySwatch: Colors.grey),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return SplashScreen();
            }
            if (userSnapshot.hasData) {
              return StartScreen();
            }

            return AuthScreen();
          },
        ),
        routes: {
          AuthScreen.routeName: (ctx) => AuthScreen(),
          StartScreen.routeName: (ctx) => StartScreen(),
          HomeScreen.routeName: (ctx) => HomeScreen(),
          SplashScreen.routeName: (ctx) => SplashScreen(),
          SettingsScreen.routeName: (ctx) => SettingsScreen(),
        },
      ),
    );
  }
}
