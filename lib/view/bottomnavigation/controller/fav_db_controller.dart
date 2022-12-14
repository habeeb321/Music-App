import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:on_audio_query/on_audio_query.dart';

class FavoriteDbController extends GetxController {
  bool isInitialized = false;
  final musicDb = Hive.box<int>('FavoriteDB');
  List<SongModel> favoriteSongs = [];

  intialize(List<SongModel> songs) {
    for (SongModel song in songs) {
      if (isFavor(song)) {
        favoriteSongs.add(song);
      }
    }
    isInitialized = true;
    update();
  }

  isFavor(SongModel song) {
    if (musicDb.values.contains(song.id)) {
      return true;
    }
    return false;
  }

  add(SongModel song) async {
    musicDb.add(song.id);
    favoriteSongs.add(song);
    update();
  }

  delete(int id) async {
    int deletekey = 0;
    if (!musicDb.values.contains(id)) {
      return;
    }
    final Map<dynamic, int> favorMap = musicDb.toMap();
    favorMap.forEach((key, value) {
      if (value == id) {
        deletekey = key;
      }
    });
    musicDb.delete(deletekey);
    favoriteSongs.removeWhere((song) => song.id == id);
    update();
  }

  clear() async {
    favoriteSongs.clear();
  }
}
