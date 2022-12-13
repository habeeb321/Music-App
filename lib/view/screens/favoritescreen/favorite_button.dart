import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_app/model/functions/favorite_db.dart';
import 'package:on_audio_query/on_audio_query.dart';

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({super.key, required this.songFavorite});
  final SongModel songFavorite;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: FavoriteDb.favoriteSongs,
        builder:
            (BuildContext ctx, List<SongModel> favoriteData, Widget? child) {
          return IconButton(
            onPressed: () {
              if (FavoriteDb.isFavor(songFavorite)) {
                FavoriteDb.delete(songFavorite.id);
                Get.snackbar('Favorites', 'Remove From Favorites',
                    colorText: Colors.white,
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red.shade400);
              } else {
                FavoriteDb.add(songFavorite);
                Get.snackbar('Favorites', 'Song Added To Favorite',
                    colorText: Colors.white,
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red.shade400);
              }

              FavoriteDb.favoriteSongs.notifyListeners();
            },
            icon: FavoriteDb.isFavor(songFavorite)
                ? Icon(
                    Icons.favorite,
                    color: Colors.red[600],
                  )
                : const Icon(
                    Icons.favorite,
                  ),
          );
        });
  }
}
