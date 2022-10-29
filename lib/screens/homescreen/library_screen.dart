import 'package:flutter/material.dart';
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
            Container(
              height: 100,
              width: 100,
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 105, 195, 241),
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: const Center(
                child: Text('Recently \n Played'),
              ),
            ),
            Container(
              height: 100,
              width: 100,
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 105, 195, 241),
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: const Center(
                child: Text('Mostly \nPlayed'),
              ),
            ),
            InkWell(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder:(context) => PlaylistScreen(),)),
              child: Container(
                height: 100,
                width: 100,
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 105, 195, 241),
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: const Center(
                  child: Text('Playlist'),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
