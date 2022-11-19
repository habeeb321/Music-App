import 'package:flutter/material.dart';
import 'package:music_app/controller/get_all_song_controller.dart';
import 'package:music_app/db/functions/favorite_db.dart';
import 'package:music_app/screens/favoritescreen/favorite_screen.dart';
import 'package:music_app/screens/homescreen/allsongs/allsongs.dart';
import 'package:music_app/screens/miniplayer/mini_player.dart';
import 'package:music_app/screens/searchscreen/search_screen.dart';
import 'package:music_app/screens/settings/settings_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({super.key});

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int currentIndex = 0;

  List pages = [
    const HomeScreen(),
    const FavoriteScreen(),
    const SearchScreen(),
    const SettingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF01C3CC),
            Color(0xFF2A89DA),
            Color(0xFF7D2AE7),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: pages[currentIndex],
        bottomNavigationBar: ValueListenableBuilder(
          valueListenable: FavoriteDb.favoriteSongs,
          builder:
              (BuildContext context, List<SongModel> music, Widget? child) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  if (GetAllSongController.audioPlayer.currentIndex != null)
                    Column(
                      children: const [
                        MiniPlayer(),
                        SizedBox(height: 10),
                      ],
                    )
                  else
                    const SizedBox(),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.08,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30),
                          topLeft: Radius.circular(30)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black38,
                            spreadRadius: 5,
                            blurRadius: 10),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                      child: BottomNavigationBar(
                        items: const [
                          BottomNavigationBarItem(
                              icon: Icon(Icons.home, size: 25), label: 'Home'),
                          BottomNavigationBarItem(
                              icon: Icon(Icons.favorite, size: 25),
                              label: 'Favorite'),
                          BottomNavigationBarItem(
                              icon: Icon(Icons.search, size: 25),
                              label: 'Search'),
                          BottomNavigationBarItem(
                              icon: Icon(Icons.settings, size: 25),
                              label: 'Settings'),
                        ],
                        backgroundColor:
                            const Color.fromARGB(255, 76, 104, 244),
                        selectedItemColor: Colors.white,
                        unselectedItemColor: Colors.white70,
                        showUnselectedLabels: true,
                        type: BottomNavigationBarType.fixed,
                        currentIndex: currentIndex,
                        onTap: (index) {
                          setState(() {
                            currentIndex = index;
                            FavoriteDb.favoriteSongs.notifyListeners();
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
