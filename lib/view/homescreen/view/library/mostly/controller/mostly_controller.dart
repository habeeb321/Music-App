import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_app/model/functions/mostly_song_db.dart';
import 'package:music_app/view/homescreen/view/allsongs.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MostlyController extends GetxController {
  List<SongModel> mostlyPlayedNotifier = [];
  List<dynamic> mostlyPlayed = [];
  List<SongModel> mostlyPlayedSong = [];
  @override
  void onInit() {
    super.onInit();
    init();
    update();
  }

  Future init() async {
    await MostlySongDb.getMostlyPlayedSongs();
    update();
  }

  Future<void> addMostlyPlayed(item) async {
    final mostPlayedDb = await Hive.openBox('mostlyPlayedNotifier');
    await mostPlayedDb.add(item);
    getMostlyPlayedSongs();
    update();
  }

  Future<void> getMostlyPlayedSongs() async {
    final mostPlayedDb = await Hive.openBox('mostlyPlayedNotifier');
    mostlyPlayed = mostPlayedDb.values.toList();
    displayMostlyPlayed();
    update();
  }

  Future<void> displayMostlyPlayed() async {
    final mostPlayedDb = await Hive.openBox('mostlyPlayedNotifier');
    final mostlyPlayedSongItems = mostPlayedDb.values.toList();
    mostlyPlayedNotifier.clear();
    mostlyPlayed.clear();
    for (int i = 0; i < mostlyPlayedSongItems.length; i++) {
      for (int j = 0; j < startSong.length; j++) {
        if (mostlyPlayedSongItems[i] == startSong[j].id) {
          mostlyPlayedNotifier.add(startSong[j]);
          mostlyPlayed.add(startSong[j]);
        }
      }
    }
    update();
  }
}
