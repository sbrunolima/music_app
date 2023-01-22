import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//Providers
import 'track.dart';

//Load the tracks on Backend
class TracksProvider with ChangeNotifier {
  List<Track> _tracks = [];
  List<Track> _findedTracks = [];

  List<Track> get tracks {
    return [..._tracks];
  }

  List<Track> get findedTracks {
    return [..._findedTracks];
  }

  //Load all tracks on Back-end
  Future<void> loadTracks([String? userId]) async {
    final url = Uri.parse(
        'put your BackEnd JSON link here');

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<dynamic, dynamic>;
      if (extractedData == null) {
        return;
      }

      final favoriteUrl = Uri.parse(
          'put your BackEnd JSON link here');
      final lastPlayedUrl = Uri.parse(
          'put your BackEnd JSON link here');

      final lastPlayedStatus = await http.get(lastPlayedUrl);
      final favoriteStatus = await http.get(favoriteUrl);
      final favoriteData = json.decode(favoriteStatus.body);
      final lastPlayData = json.decode(lastPlayedStatus.body);

      final List<Track> loadedTracks = [];
      extractedData.forEach((trackID, trackData) {
        loadedTracks.add(
          Track(
            id: trackID,
            musicTitle: trackData['musicTitle'],
            artistName: trackData['artistName'],
            studioName: trackData['studioName'],
            genre: trackData['genre'],
            coverUrl: trackData['coverUrl'],
            trackUrl: trackData['trackUrl'],
            isFavorite:
                favoriteData == null ? false : favoriteData[trackID] ?? false,
            lastPlayed:
                lastPlayData == null ? false : lastPlayData[trackID] ?? false,
          ),
        );
      });
      _tracks = loadedTracks.toList();
      notifyListeners();
    } catch (error) {
      print('ERROPPP: $error');
    }
  }

  //Verify if the song exists and return it
  Future<void> findTrack(String query) async {
    final url = Uri.parse(
        'put your BackEnd JSON link here');

    final response = await http.get(url);
    final extrectedData = json.decode(response.body) as Map<String, dynamic>;
    final List<Track> loadedTrack = [];

    extrectedData.forEach((trackID, trackData) {
      if (trackData['musicTitle']
          .toString()
          .toLowerCase()
          .contains(query.toLowerCase())) {
        loadedTrack.add(
          Track(
            id: trackID,
            musicTitle: trackData['musicTitle'],
            artistName: trackData['artistName'],
            studioName: trackData['studioName'],
            genre: trackData['genre'],
            coverUrl: trackData['coverUrl'],
            trackUrl: trackData['trackUrl'],
          ),
        );
      }
    });
    _findedTracks = loadedTrack.toList();
    notifyListeners();
  }
}
