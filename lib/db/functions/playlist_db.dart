import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:music_app/db/functions/favorite_db.dart';
import 'package:music_app/db/model/muzic_model.dart';
import 'package:music_app/screens/splashscreen/splash_screen.dart';

ValueNotifier<List<MuzicModel>> playlistNotifier = ValueNotifier([]);

Future<void> addPlaylist(MuzicModel value) async {
  final playlistDb = Hive.box<MuzicModel>('playlistDb');
  await playlistDb.add(value);
  playlistNotifier.value.add(value);
}

Future<void> getAllPlaylist() async {
  final playlistDb = Hive.box<MuzicModel>('playlistDb');
  playlistNotifier.value.clear();
  playlistNotifier.value.addAll(playlistDb.values);
  playlistNotifier.notifyListeners();
}

Future<void> deletePlaylist(int index) async {
  final playlistDb = Hive.box<MuzicModel>('playlistDb');
  await playlistDb.deleteAt(index);
  getAllPlaylist();
}

Future<void> resetApp(context) async {
  final playlistDb = Hive.box<MuzicModel>('playlsitDb');
  final musicDb = Hive.box<int>('FavoriteDB');
  await musicDb.clear();
  await playlistDb.clear();
  FavoriteDb.favoriteSongs.value.clear();
  Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const SplashScreen()),
      (route) => false);
}
