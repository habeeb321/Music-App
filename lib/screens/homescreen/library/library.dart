import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:music_app/screens/homescreen/library/mostly/mostly_played.dart';
import 'package:music_app/screens/homescreen/library/recently/recently_played.dart';
import 'package:music_app/screens/homescreen/library/playlist/playlist_create_screen.dart';

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
        const SizedBox(height: 10),
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
                        image: AssetImage('assets/images/recent image.jpg'),
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
            InkWell(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const MostlyPlayed())),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                        image:
                            AssetImage('assets/images/mostlyplayed image.webp'),
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
                        image: AssetImage('assets/images/playlist image.jpg'),
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
