import 'package:flutter/material.dart';
import 'package:music_app/screens/homescreen/library/playlist/playlist_create_screen.dart';
import 'package:music_app/screens/homescreen/library/recently/recently_played.dart';
import 'package:music_app/screens/settings/about_music.dart';

class HomescreenDrawers extends StatelessWidget {
  const HomescreenDrawers({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.home),
          title: const Text('Home'),
          selected: true,
          onTap: () => {Navigator.pop(context)},
        ),
        ListTile(
          leading: const Icon(Icons.playlist_add_check),
          title: const Text('Playlists'),
          onTap: () => {
            Navigator.pop(context),
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const PlaylistScreen()))
          },
        ),
        ListTile(
          leading: const Icon(Icons.schedule),
          title: const Text('Recents'),
          onTap: () => {
            Navigator.pop(context),
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const RecentlyPlayed()))
          },
        ),
        ListTile(
          leading: const Icon(Icons.info),
          title: const Text('About'),
          onTap: () => {
            Navigator.pop(context),
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const AboutMusicScreen()))
          },
        ),
      ],
    );
  }
}
