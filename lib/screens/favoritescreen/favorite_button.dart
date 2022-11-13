import 'package:flutter/material.dart';
import 'package:music_app/db/functions/favorite_db.dart';
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
                const snackBar = SnackBar(
                  content: Text(
                    'Removed From Favorite',
                    style: TextStyle(color: Colors.white),
                  ),
                  duration: Duration(milliseconds: 1500),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } else {
                FavoriteDb.add(widget.songFavorite);
                const snackbar = SnackBar(
                  backgroundColor: Colors.black,
                  content: Text(
                    'Song Added to Favorite',
                    style: TextStyle(color: Colors.white),
                  ),
                  duration: Duration(milliseconds: 350),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackbar);
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
