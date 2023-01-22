import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

//Widgets
import '../widgets/auth_form_widget.dart';
import '../http/error_dialog.dart';

//Providers
import '../languages/auth_screen_locale.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth-screen';
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _authState = FirebaseAuth.instance;
  final String defaultLocale = Platform.localeName;
  var _isLoading = false;
  var _isInit = true;
  String _title = '';
  String _emailInUse = '';
  String _invalidEmail = '';
  String _weakPassword = '';
  String _noUserEmail = '';
  String _incorrectPassword = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInit) {
      //Translates UI text to Portuguese or English
      //According with the phone defaul language
      Provider.of<AuthLocaleProvider>(context).setLanguage(defaultLocale);
      final locale = Provider.of<AuthLocaleProvider>(context);
      _title = locale.language[0].title.toString();
      _emailInUse = locale.language[0].emailInUse.toString();
      _invalidEmail = locale.language[0].invalidEmail.toString();
      _weakPassword = locale.language[0].weakPassword.toString();
      _noUserEmail = locale.language[0].noUserEmail.toString();
      _incorrectPassword = locale.language[0].incorrectPassword.toString();
    }

    _isInit = false;
  }

  void _submitForm(
    String email,
    String password,
    bool isLogin,
    BuildContext ctx,
  ) async {
    UserCredential credential;

    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        credential = await _authState.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        credential = await _authState.createUserWithEmailAndPassword(
            email: email, password: password);
      }
    } catch (error) {
      //Take all the erros and return to the user UI

      String errorMessage = error.toString();
      if (error.toString().contains('email-already-in-use')) {
        errorMessage = _emailInUse;
      }
      if (error.toString().contains('invalid-email')) {
        errorMessage = _invalidEmail;
      }
      if (error.toString().contains('weak-password')) {
        errorMessage = _weakPassword;
      }
      if (error.toString().contains('user-not-found')) {
        errorMessage = _noUserEmail;
      }
      if (error.toString().contains('wrong-password')) {
        errorMessage = _incorrectPassword;
      }
      if (error.toString().contains('operation-not-allowed')) {
        errorMessage = error.toString();
      }

      errorDialog(_title, errorMessage, context);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/14.jpg',
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          AuthFormWidget(_submitForm, _isLoading),
        ],
      ),
    );
  }
}
