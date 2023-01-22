import 'package:flutter/foundation.dart';

//Forms language selecor
//Select between en_US or pt_BR
class FormLocale {
  final String? invalidEmail;
  final String? weakPassword;
  final String? login;
  final String? signup;
  final String? newAccount;
  final String? alreadHaveAccount;
  final String? emailHint;
  final String? passwordHint;

  FormLocale({
    required this.invalidEmail,
    required this.weakPassword,
    required this.login,
    required this.signup,
    required this.newAccount,
    required this.alreadHaveAccount,
    required this.emailHint,
    required this.passwordHint,
  });
}

class FormLocaleProvider with ChangeNotifier {
  List<FormLocale> _language = [];

  List<FormLocale> get language {
    return [..._language];
  }

  List<String> localePT_BR = [
    'Por favor insira um endereço de e-mail válido.',
    'Senha fraca, digite uma senha de com mais de 7 caracteres.',
    'Conectar',
    'Inscrever-se',
    'Criar nova conta',
    'Já possuo uma conta',
    'Inscreva-se com novo e-mail',
    'Senha',
  ];

  List<String> localeEN_US = [
    'Please enter a valid email address.',
    'Weak password, enter a password with more than 7 characters.',
    'Login',
    'Signup',
    'Create new account',
    'I already have an account',
    'Sign up with new email',
    'Password',
  ];

  Future<void> setLanguage(String selectedLang) async {
    final List<FormLocale> loadedLanguage = [];
    if (selectedLang == 'pt_BR') {
      loadedLanguage.add(
        FormLocale(
          invalidEmail: localePT_BR[0],
          weakPassword: localePT_BR[1],
          login: localePT_BR[2],
          signup: localePT_BR[3],
          newAccount: localePT_BR[4],
          alreadHaveAccount: localePT_BR[5],
          emailHint: localePT_BR[6],
          passwordHint: localePT_BR[7],
        ),
      );
    } else {
      loadedLanguage.add(
        FormLocale(
          invalidEmail: localeEN_US[0],
          weakPassword: localeEN_US[1],
          login: localeEN_US[2],
          signup: localeEN_US[3],
          newAccount: localeEN_US[4],
          alreadHaveAccount: localeEN_US[5],
          emailHint: localeEN_US[6],
          passwordHint: localeEN_US[7],
        ),
      );
    }

    _language = loadedLanguage.toList();
    notifyListeners();
  }
}
