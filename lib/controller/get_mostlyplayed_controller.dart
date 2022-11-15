import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_app/screens/homescreen/all_songs_listview.dart';
import 'package:on_audio_query/on_audio_query.dart';

class GetMostlyPlayedController {
  static ValueNotifier<List<SongModel>> mostlyPlayedNotifier =
      ValueNotifier([]);
  static List<dynamic> mostlyPlayed = [];
  static List<SongModel> mostlyPlayedSong = [];

  static Future<void> addMostlyPlayed(item) async {
    final mostPlayedDb = await Hive.openBox('mostlyPlayedNotifier');
    await mostPlayedDb.add(item);
    getMostlyPlayedSongs();
    mostlyPlayedNotifier.notifyListeners();
  }

  static Future<void> getMostlyPlayedSongs() async {
    final mostPlayedDb = await Hive.openBox('mostlyPlayedNotifier');
    mostlyPlayed = mostPlayedDb.values.toList();
    displayMostlyPlayed();
    mostlyPlayedNotifier.notifyListeners();
  }

  static Future<void> displayMostlyPlayed() async {
    final mostPlayedDb = await Hive.openBox('mostlyPlayedNotifier');
    final MostlyPlayedSongItems = mostPlayedDb.values.toList();
    mostlyPlayedNotifier.value.clear();
    mostlyPlayed.clear();
    for (int i = 0; i < MostlyPlayedSongItems.length; i++) {
      for (int j = 0; j < AllSongsListView.startSong.length; j++) {
        if (MostlyPlayedSongItems[i] == AllSongsListView.startSong[j].id) {
          mostlyPlayedNotifier.value.add(AllSongsListView.startSong[j]);
          mostlyPlayed.add(AllSongsListView.startSong[j]);
        }
      }
    }
    mostlyPlayedNotifier.notifyListeners();
  }
}
