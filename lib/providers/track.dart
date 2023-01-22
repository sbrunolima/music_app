import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

//Track
class Track with ChangeNotifier {
  final String? id;
  final String? musicTitle;
  final String? artistName;
  final String? studioName;
  final String? genre;
  final String? coverUrl;
  final String? trackUrl;
  bool isFavorite;
  bool lastPlayed;

  Track({
    @required this.id,
    @required this.musicTitle,
    @required this.artistName,
    @required this.studioName,
    @required this.genre,
    @required this.coverUrl,
    @required this.trackUrl,
    this.isFavorite = false,
    this.lastPlayed = false,
  });

//Set Favorite
  void _setFavoriteValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

//Set song on already played
  void _setLastPlayedValue(bool newValue) {
    lastPlayed = newValue;
    notifyListeners();
  }

  //Add on Back-end the FAVORITE STATUS with the PlayerID
  Future<void> toggleFavoriteStatus(String musicId, String userId) async {
    final oldStatus = isFavorite;

    notifyListeners();
    final url = Uri.parse(
        'put your BackEnd JSON link here');

    try {
      var response;
      final hasFav = await http.get(url);
      if (!hasFav.body.contains(musicId)) {
        response = await http.put(
          url,
          body: json.encode(
            true,
          ),
        );
      }
      if (hasFav.body.toString() == 'true') {
        response = await http.put(
          url,
          body: json.encode(
            false,
          ),
        );
      }

      if (response.statusCode >= 400) {
        _setFavoriteValue(oldStatus);
      }
    } catch (error) {
      _setFavoriteValue(oldStatus);
      print('FAVORITE ERROR: $error');
    }
  }

  //Add on Back-end the LASTPLAYED STATUS with the PlayerID
  Future<void> toggleLastPlayed(String musicId, String userId) async {
    final oldStatus = lastPlayed;

    lastPlayed = true;
    notifyListeners();
    final url = Uri.parse(
        'put your BackEnd JSON link here');

    try {
      final response = await http.put(
        url,
        body: json.encode(
          lastPlayed,
        ),
      );

      if (response.statusCode >= 400) {
        _setLastPlayedValue(oldStatus);
      }
    } catch (error) {
      _setLastPlayedValue(oldStatus);
      print('LASTPLAYED ERROR: $error');
    }
  }
}
