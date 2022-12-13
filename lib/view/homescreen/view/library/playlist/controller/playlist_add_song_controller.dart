import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_app/model/functions/playlist_db.dart';
import 'package:music_app/model/model/muzic_model.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlaylistAddController extends GetxController {
  void songAddToPlaylist(SongModel data, MuzicModel playlist) {
    if (!playlist.isValueIn(data.id)) {
      playlist.add(data.id);
      Get.snackbar('Playlist', 'Song Added To Playlist',
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade400);
      update();
    }
    PlaylistDb.playlistNotifier;
    update();
  }

  void deletePlaylist(MuzicModel playlist, int item) {
    playlist.deleteData(item);
  }
}
