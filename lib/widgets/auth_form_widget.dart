import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Providers
import '../languages/auth_form_locale.dart';

class AuthFormWidget extends StatefulWidget {
  bool isLoading;

  final void Function(
    String email,
    String password,
    bool isLogin,
    BuildContext ctx,
  ) submitAuthForm;

  AuthFormWidget(this.submitAuthForm, this.isLoading);
  @override
  State<AuthFormWidget> createState() => _AuthFormWidgetState();
}

class _AuthFormWidgetState extends State<AuthFormWidget> {
  final String defaultLocale = Platform.localeName;
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _isInit = true;
  var _showPassword = true;
  //Login or Signup
  String _userEmail = '';
  String _userPassword = '';

  //UI translation
  String _invalidEmail = '';
  String _weakPassword = '';
  String _login = '';
  String _signup = '';
  String _newAccount = '';
  String _alreadHaveAccount = '';
  String _emailHint = '';
  String _passwordHint = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInit) {
      //Translates UI text to Portuguese or English
      //According with the phone defaul language
      Provider.of<FormLocaleProvider>(context).setLanguage(defaultLocale);
      final locale = Provider.of<FormLocaleProvider>(context);
      _invalidEmail = locale.language[0].invalidEmail.toString();
      _weakPassword = locale.language[0].weakPassword.toString();
      _login = locale.language[0].login.toString();
      _signup = locale.language[0].signup.toString();
      _newAccount = locale.language[0].newAccount.toString();
      _alreadHaveAccount = locale.language[0].alreadHaveAccount.toString();
      _emailHint = locale.language[0].emailHint.toString();
      _passwordHint = locale.language[0].passwordHint.toString();
    }

    _isInit = false;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      _formKey.currentState!.save();
      widget.submitAuthForm(
        _userEmail.trim(),
        _userPassword.trim(),
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //Take the screen size to adjust on Tablet and Smartphone
    double deviceHeight = MediaQuery.of(context).size.height;
    final isKeybordOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    const sizedBox = SizedBox(height: 15);
    return Column(
      children: [
        SizedBox(
          height: (isKeybordOpen && !_isLogin)
              ? MediaQuery.of(context).size.height -
                  (deviceHeight > 816.0 ? 800 : 620)
              : (_isLogin && !isKeybordOpen)
                  ? MediaQuery.of(context).size.height -
                      (deviceHeight > 816.0 ? 800 : 550)
                  : isKeybordOpen
                      ? MediaQuery.of(context).size.height -
                          (deviceHeight > 816.0 ? 800 : 620)
                      : MediaQuery.of(context).size.height -
                          (deviceHeight > 816.0 ? 800 : 550),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/cd.png', scale: deviceHeight > 816.0 ? 5 : 7),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Musics',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: deviceHeight > 816.0 ? 62 : 44,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: Row(
                    children: [
                      Image.asset('assets/git.png',
                          scale: deviceHeight > 816.0 ? 22 : 28),
                      const SizedBox(width: 3),
                      Text(
                        'sbrunolima',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: deviceHeight > 816.0 ? 14 : 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    key: const ValueKey('email'),
                    cursorColor: Colors.purple.shade800,
                    validator: (value) {
                      if (value.toString().isEmpty ||
                          !value.toString().contains('@')) {
                        return _invalidEmail;
                      }

                      return null;
                    },
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      fillColor: Colors.white54,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: BorderSide(color: Colors.grey.shade500),
                      ),
                      hintText: _isLogin ? 'E-mail' : _emailHint,
                    ),
                    onSaved: (value) {
                      _userEmail = value.toString();
                    },
                  ),
                  sizedBox,
                  TextFormField(
                    key: const ValueKey('password'),
                    cursorColor: Colors.purple.shade800,
                    validator: (value) {
                      if (value.toString().isEmpty ||
                          value.toString().length < 7) {
                        return _weakPassword;
                      }

                      return null;
                    },
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      suffixIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: IconButton(
                          icon: Icon(
                            _showPassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Colors.purple.shade800,
                          ),
                          onPressed: () {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          },
                        ),
                      ),
                      fillColor: Colors.white54,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: BorderSide(color: Colors.grey.shade500),
                      ),
                      hintText: _passwordHint,
                    ),
                    obscureText: _showPassword ? true : false,
                    onSaved: (value) {
                      _userPassword = value.toString();
                    },
                  ),
                  const SizedBox(height: 12),
                  if (widget.isLoading)
                    CircularProgressIndicator(
                      color: Colors.purple.shade800,
                    ),
                  if (!widget.isLoading)
                    SizedBox(
                      height: 55,
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: _trySubmit,
                        child: Text(
                          _isLogin ? _login : _signup,
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    fontSize: deviceHeight > 816.0 ? 20 : 16,
                                    color: Colors.white,
                                  ),
                        ),
                        style: OutlinedButton.styleFrom(
                          backgroundColor:
                              _isLogin ? Colors.purple.shade800 : Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          side: const BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 15),
                  OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                    child: Text(
                      _isLogin ? _newAccount : _alreadHaveAccount,
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            fontSize: deviceHeight > 816.0 ? 20 : 16,
                            color: Colors.white,
                          ),
                    ),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      side: const BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
