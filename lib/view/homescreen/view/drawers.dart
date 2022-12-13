import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_app/view/homescreen/view/library/playlist/view/playlist_create_screen.dart';
import 'package:music_app/view/homescreen/view/library/recently/view/recently_played.dart';
import 'package:music_app/view/settings/view/about_music.dart';

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
          onTap: () => {Get.back()},
        ),
        ListTile(
          leading: const Icon(Icons.playlist_add_check),
          title: const Text('Playlists'),
          onTap: () => {
            Get.back(),
            Get.to(PlaylistScreen()),
          },
        ),
        ListTile(
          leading: const Icon(Icons.schedule),
          title: const Text('Recents'),
          onTap: () => {
            Get.back(),
            Get.to(RecentlyPlayed()),
          },
        ),
        ListTile(
          leading: const Icon(Icons.info),
          title: const Text('About'),
          onTap: () => {
            Get.back(),
            Get.to(const AboutMusicScreen()),
          },
        ),
      ],
    );
  }
}
