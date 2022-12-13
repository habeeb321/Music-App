import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_app/view/screens/homescreen/allsongs/allsongs.dart';
import 'package:on_audio_query/on_audio_query.dart';

class RecentController extends GetxController {
  RxList<SongModel> recentSongNotifier = RxList<SongModel>([]);
  List<dynamic> recentlyPlayed = [];

  @override
  void onInit() {
    init();
    getRecentSongs();
    super.onInit();
  }

  Future init() async {
    await getRecentSongs();
    update();
  }

  Future<void> addRecentlyPlayed(item) async {
    final recentDb = await Hive.openBox('recentSongNotifier');
    await recentDb.add(item);
    getRecentSongs();
    recentSongNotifier.obs;
  }

  Future<void> getRecentSongs() async {
    final recentDb = await Hive.openBox('recentSongNotifier');
    recentlyPlayed = recentDb.values.toList();
    displayRecents();
    recentSongNotifier.obs;
  }

  Future<void> displayRecents() async {
    final recentDb = await Hive.openBox('recentSongNotifier');
    final recentSongItems = recentDb.values.toList();
    recentSongNotifier.value.clear();
    recentlyPlayed.clear();
    for (int i = 0; i < recentSongItems.length; i++) {
      for (int j = 0; j < startSong.length; j++) {
        if (recentSongItems[i] == startSong[j].id) {
          recentSongNotifier.value.add(startSong[j]);
          recentlyPlayed.add(startSong[j]);
        }
      }
    }
    recentSongNotifier.obs;
  }
}
