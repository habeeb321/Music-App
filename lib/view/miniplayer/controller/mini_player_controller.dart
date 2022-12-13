import 'package:get/get.dart';
import 'package:music_app/controller/get_all_song.dart';

class MiniPlayerController extends GetxController {
  void miniPlayer() {
    GetAllSongController.audioPlayer.currentIndexStream.listen((index) {
      if (index != null) {
        update();
      }
    });
  }

  Future<void> updateFuctions() async {
    if (GetAllSongController.audioPlayer.playing) {
      await GetAllSongController.audioPlayer.pause();
      update();
    } else {
      await GetAllSongController.audioPlayer.play();
      update();
    }
  }
}
