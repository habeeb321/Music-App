import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:music_app/controller/get_mostlyplayed_controller.dart';
import 'package:music_app/controller/get_recent_song_controller.dart';
import 'package:music_app/db/functions/favorite_db.dart';
import 'package:music_app/db/model/muzic_model.dart';
import 'package:music_app/screens/splashscreen/splash_screen.dart';

class PlaylistDb {
  static ValueNotifier<List<MuzicModel>> playlistNotifier = ValueNotifier([]);

  static Future<void> addPlaylist(MuzicModel value) async {
    final playlistDb = Hive.box<MuzicModel>('playlistDb');
    await playlistDb.add(value);
    playlistNotifier.value.add(value);
  }

  static Future<void> getAllPlaylist() async {
    final playlistDb = Hive.box<MuzicModel>('playlistDb');
    playlistNotifier.value.clear();
    playlistNotifier.value.addAll(playlistDb.values);
    playlistNotifier.notifyListeners();
  }

  static Future<void> deletePlaylist(int index) async {
    final playlistDb = Hive.box<MuzicModel>('playlistDb');
    await playlistDb.deleteAt(index);
    getAllPlaylist();
  }

  static Future<void> resetApp(context) async {
    final playlistDb = Hive.box<MuzicModel>('playlistDb');
    final musicDb = Hive.box<int>('FavoriteDB');
    final recentDb = await Hive.openBox('recentSongNotifier');
    final mostPlayedDb = await Hive.openBox('mostlyPlayedNotifier');
    await mostPlayedDb.clear();
    await musicDb.clear();
    await playlistDb.clear();
    await recentDb.clear();
    GetMostlyPlayedController.mostlyPlayedSong.clear();
    GetMostlyPlayedController.mostlyPlayed.clear();
    GetRecentSongController.recentlyPlayed.clear();
    FavoriteDb.favoriteSongs.value.clear();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const SplashScreen()),
        (route) => false);
  }

  static Future<void> editList(int id, MuzicModel value) async {
    final playlistDb = Hive.box<MuzicModel>('editPlaylistDb');
    await playlistDb.put(id, value);
    getAllPlaylist();
  }
}
