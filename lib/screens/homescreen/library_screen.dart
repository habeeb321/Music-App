import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:music_app/screens/homescreen/recently_played.dart';
import 'package:music_app/screens/playlistscreen/playlist_screen.dart';

class LibrarySection extends StatelessWidget {
  const LibrarySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Align(
          alignment: Alignment.topLeft,
          child: Text(
            'Library',
            style: TextStyle(
                fontWeight: FontWeight.w500, color: Colors.white, fontSize: 15),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const RecentlyPlayed())),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                        image: NetworkImage(
                            "https://m.media-amazon.com/images/M/MV5BMTU1MjcyMGUtODI3ZS00NTc4LWExNjgtY2ZjZGJlZmUyMmFhXkEyXkFqcGdeQXVyMjkxNzQ1NDI@._V1_FMjpg_UX1000_.jpg"),
                        fit: BoxFit.cover,
                      )),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                        child: Container(
                          color: Colors.black.withOpacity(0.1),
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 18, top: 30),
                    child: Text(
                      'Recently \n Played',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                    ),
                  ),
                ],
              ),
            ),
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                      image: NetworkImage(
                          "https://www.billboard.com/wp-content/uploads/media/marshmello-2017-june-live-billboard-1548.jpg?w=875&h=583&crop=1"),
                      fit: BoxFit.cover,
                    )),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                      child: Container(
                        color: Colors.black.withOpacity(0.1),
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 24, top: 30),
                  child: Text(
                    'Mostly \nPlayed',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const PlaylistScreen(),
              )),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                        image: NetworkImage(
                            "https://thumbs.dreamstime.com/b/music-frame-background-9193486.jpg"),
                        fit: BoxFit.cover,
                      )),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                        child: Container(
                          color: Colors.black.withOpacity(0.1),
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 24, top: 40),
                    child: Text(
                      'Playlist',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
