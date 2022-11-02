import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_app/screens/homescreen/all_songs_listview.dart';
import 'package:on_audio_query/on_audio_query.dart';

class GetRecentSongController {
  static ValueNotifier<List<SongModel>> recentSongNotifier = ValueNotifier([]);
  static List<dynamic> recentlyPlayed = [];

  static Future<void> addRecentlyPlayed(item) async {
    final recentDb = await Hive.openBox('recentSongNotifier');
    await recentDb.add(item);
    getRecentSongs();
    recentSongNotifier.notifyListeners();
  }

  static Future<void> getRecentSongs() async {
    final recentDb = await Hive.openBox('recentSongNotifier');
    recentlyPlayed = recentDb.values.toList();
    displayRecents();
    recentSongNotifier.notifyListeners();
  }

  static Future<void> displayRecents() async {
    final recentDb = await Hive.openBox('recentSongNotifier');
    final recentSongItems = recentDb.values.toList();
    recentSongNotifier.value.clear();
    recentlyPlayed.clear();
    for (int i = 0; i < recentSongItems.length; i++) {
      for (int j = 0; j < AllSongsListView.startSong.length; j++) {
        if (recentSongItems[i] == AllSongsListView.startSong[j].id) {
          recentSongNotifier.value.add(AllSongsListView.startSong[j]);
          recentlyPlayed.add(AllSongsListView.startSong[j]);
        }
      }
    }
  }
}
