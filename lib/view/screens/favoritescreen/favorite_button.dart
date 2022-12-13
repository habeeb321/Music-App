import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_app/model/functions/favorite_db.dart';
import 'package:on_audio_query/on_audio_query.dart';

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({super.key, required this.songFavorite});
  final SongModel songFavorite;

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: FavoriteDb.favoriteSongs,
        builder:
            (BuildContext ctx, List<SongModel> favoriteData, Widget? child) {
          return IconButton(
            onPressed: () {
              if (FavoriteDb.isFavor(widget.songFavorite)) {
                FavoriteDb.delete(widget.songFavorite.id);
                Get.snackbar('Favorites', 'Remove From Favorites',
                    colorText: Colors.white,
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red.shade400);
              } else {
                FavoriteDb.add(widget.songFavorite);
                Get.snackbar('Favorites', 'Song Added To Favorite',
                    colorText: Colors.white,
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red.shade400);
              }

              FavoriteDb.favoriteSongs.notifyListeners();
            },
            icon: FavoriteDb.isFavor(widget.songFavorite)
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
