import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_app/model/functions/favorite_db.dart';
import 'package:on_audio_query/on_audio_query.dart';

class FavButMusicPlaying extends StatelessWidget {
  const FavButMusicPlaying({super.key, required this.songFavoriteMusicPlaying});
  final SongModel songFavoriteMusicPlaying;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: FavoriteDb.favoriteSongs,
        builder:
            (BuildContext ctx, List<SongModel> favoriteData, Widget? child) {
          return IconButton(
            onPressed: () {
              if (FavoriteDb.isFavor(songFavoriteMusicPlaying)) {
                FavoriteDb.delete(songFavoriteMusicPlaying.id);
                Get.snackbar('Favorites', 'Removed From Favorites',
                    colorText: Colors.white,
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red.shade400);
              } else {
                FavoriteDb.add(songFavoriteMusicPlaying);
                Get.snackbar('Favorites', 'Song Added To Favorites',
                    colorText: Colors.white,
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red.shade400);
              }
              FavoriteDb.favoriteSongs.notifyListeners();
            },
            icon: FavoriteDb.isFavor(songFavoriteMusicPlaying)
                ? Icon(
                    Icons.favorite,
                    color: Colors.red[600],
                  )
                : const Icon(
                    Icons.favorite,
                    color: Colors.white,
                  ),
          );
        });
  }
}
