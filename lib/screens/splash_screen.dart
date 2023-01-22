import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jumping_dot/jumping_dot.dart';

//Providers
import '../languages/app_language.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splash-screen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final String defaultLocale = Platform.localeName;
  var _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    //Set the language in the begining according the phone locale
    if (_isInit) {
      Provider.of<LanguageProvider>(context).setLanguage(defaultLocale);
    }

    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    //Translates UI text to Portuguese or English
    //According with the phone defaul language
    final locale = Provider.of<LanguageProvider>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                locale.language[0].loading!.isNotEmpty
                    ? locale.language[0].loading!
                    : 'Loading',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(width: 4),
              JumpingDots(
                color: Colors.white,
                radius: 4,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
