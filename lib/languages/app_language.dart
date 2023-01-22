import 'package:flutter/foundation.dart';

//App language selector
//Select between en_US or pt_BR
class Language {
  final String? locale;
  final String? home;
  final String? listenAgain;
  final String? allSongs;
  final String? favorites;
  final String? about;
  final String? loading;
  final String? aboutAuthor;
  final String? aboutSongs;
  final String? version;
  final String? exit;

  Language({
    required this.locale,
    required this.home,
    required this.listenAgain,
    required this.allSongs,
    required this.favorites,
    required this.about,
    required this.loading,
    required this.aboutAuthor,
    required this.aboutSongs,
    required this.version,
    required this.exit,
  });
}

class LanguageProvider with ChangeNotifier {
  List<Language> _language = [];

  List<Language> get language {
    return [..._language];
  }

  Future<void> setLanguage(String selectedLang) async {
    final List<Language> loadedLanguage = [];
    if (selectedLang == 'pt_BR') {
      loadedLanguage.add(
        Language(
          locale: "pt_BR",
          home: "Início",
          listenAgain: "Ouvir novamente",
          allSongs: "Todas as músicas",
          favorites: 'Favoritos',
          about: 'Sobre',
          loading: 'Carregando',
          aboutAuthor: 'Sobre o Autor',
          aboutSongs: 'Sobre Músicas/Política de Uso',
          version: 'Versão',
          exit: 'Sair',
        ),
      );
    } else {
      loadedLanguage.add(
        Language(
          locale: "en_US",
          home: "Home",
          listenAgain: "Listen again",
          allSongs: "All songs",
          favorites: 'Favorites',
          about: 'About',
          loading: 'Loading',
          aboutAuthor: 'About the Author',
          aboutSongs: 'About Songs/Usage Policy',
          version: 'Version',
          exit: 'Exit',
        ),
      );
    }

    _language = loadedLanguage.toList();
    notifyListeners();
  }
}
