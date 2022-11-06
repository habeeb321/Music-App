import 'package:flutter/material.dart';
import 'package:music_app/screens/homescreen/all_songs_listview.dart';
import 'package:music_app/screens/homescreen/library_screen.dart';
import 'package:music_app/screens/homescreen/recently_played.dart';
import 'package:music_app/screens/playlistscreen/playlist_screen.dart';
import 'package:music_app/screens/settings/about_music.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromRGBO(74, 107, 228, 1),
                image: DecorationImage(
                  image: AssetImage('assets/images/logo.jpg'),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 115,left: 90),
                child: Text(
                  'Muzic App',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
            ),
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
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const PlaylistScreen()))
              },
            ),
            ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text('Recents'),
              onTap: () => {
                Navigator.pop(context),
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const RecentlyPlayed()))
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
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () => {Navigator.pop(context)},
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              LibrarySection(),
              SizedBox(
                height: 10,
              ),
              Text(
                'All Songs',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              AllSongsListView(),
            ],
          ),
        ),
      ),
    );
  }
}
