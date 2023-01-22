import 'package:flutter/foundation.dart';

//Forms language selecor
//Select between en_US or pt_BR
class AuthLocale {
  final String? title;
  final String? emailInUse;
  final String? invalidEmail;
  final String? weakPassword;
  final String? noUserEmail;
  final String? incorrectPassword;

  AuthLocale({
    required this.title,
    required this.emailInUse,
    required this.invalidEmail,
    required this.weakPassword,
    required this.noUserEmail,
    required this.incorrectPassword,
  });
}

class AuthLocaleProvider with ChangeNotifier {
  List<AuthLocale> _language = [];

  List<AuthLocale> get language {
    return [..._language];
  }

  List<String> localePT_BR = [
    'Ops, algo deu errado!',
    'E-mail já em uso.',
    'Endereço de email inválido.',
    'Senha fraca.',
    'Sem usuários com esse e-mail.',
    'Senha incorreta.',
  ];

  List<String> localeEN_US = [
    'Oops, something went wrong!',
    'Email alread in use.',
    'Email address is invalid.',
    'Weak password.',
    'No users with this email.',
    'Incorrect password.',
  ];

  Future<void> setLanguage(String selectedLang) async {
    final List<AuthLocale> loadedLanguage = [];
    if (selectedLang == 'pt_BR') {
      loadedLanguage.add(
        AuthLocale(
          title: localePT_BR[0],
          emailInUse: localePT_BR[1],
          invalidEmail: localePT_BR[2],
          weakPassword: localePT_BR[3],
          noUserEmail: localePT_BR[4],
          incorrectPassword: localePT_BR[5],
        ),
      );
    } else {
      loadedLanguage.add(
        AuthLocale(
          title: localeEN_US[0],
          emailInUse: localeEN_US[1],
          invalidEmail: localeEN_US[2],
          weakPassword: localeEN_US[3],
          noUserEmail: localeEN_US[4],
          incorrectPassword: localeEN_US[5],
        ),
      );
    }

    _language = loadedLanguage.toList();
    notifyListeners();
  }
}
