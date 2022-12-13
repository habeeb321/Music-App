import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_app/model/functions/favorite_db.dart';
import 'package:on_audio_query/on_audio_query.dart';

class FavButMusicPlaying extends StatefulWidget {
  const FavButMusicPlaying({super.key, required this.songFavoriteMusicPlaying});
  final SongModel songFavoriteMusicPlaying;

  @override
  State<FavButMusicPlaying> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavButMusicPlaying> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: FavoriteDb.favoriteSongs,
        builder:
            (BuildContext ctx, List<SongModel> favoriteData, Widget? child) {
          return IconButton(
            onPressed: () {
              if (FavoriteDb.isFavor(widget.songFavoriteMusicPlaying)) {
                FavoriteDb.delete(widget.songFavoriteMusicPlaying.id);
                Get.snackbar('Favorites', 'Removed From Favorites',
                    colorText: Colors.white,
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red.shade400);
              } else {
                FavoriteDb.add(widget.songFavoriteMusicPlaying);
                Get.snackbar('Favorites', 'Song Added To Favorites',
                    colorText: Colors.white,
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red.shade400);
              }
              FavoriteDb.favoriteSongs.notifyListeners();
            },
            icon: FavoriteDb.isFavor(widget.songFavoriteMusicPlaying)
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
