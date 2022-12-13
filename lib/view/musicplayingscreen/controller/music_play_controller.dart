import 'dart:developer';

import 'package:get/get.dart';
import 'package:music_app/controller/get_all_song.dart';
import 'package:music_app/view/homescreen/view/library/mostly/controller/get_mostlyplayed_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MusicPlayController extends GetxController {
  late final List<SongModel> songModelList;

  Duration duration = const Duration();
  Duration position = const Duration();

  final bool isShuffle = false;
  int currentIndex = 0;
  int counter = 0;

  @override
  void onInit() {
    GetAllSongController.audioPlayer.currentIndexStream.listen((index) {
      if (index != null) {
        currentIndex = index;
        update();
        GetAllSongController.currentIndexes = index;
      }
    });
    super.onInit();
    playSong();
  }

  void playSong() {
    GetAllSongController.audioPlayer.durationStream.listen((eventd) {
      duration = eventd!;
      update();
    });
    GetAllSongController.audioPlayer.positionStream.listen((eventp) {
      position = eventp;
      update();
    });
  }

  void setState() {
    update();
  }

  void changeToSeconds(int seconds) {
    Duration duration = Duration(seconds: seconds);
    GetAllSongController.audioPlayer.seek(duration);
    seconds = seconds;
    update();
  }

  void playButton(List<SongModel> songModelList) {
    counter++;
    log(counter.toString());
    if (counter == 3) {
      GetMostlyPlayedController.mostlyPlayedSong
          .add(songModelList[currentIndex]);
    }
  }
}
