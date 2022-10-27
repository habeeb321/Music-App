import 'package:flutter/material.dart';
import 'package:music_app/screens/favoritescreen/favorite_screen.dart';
import 'package:music_app/screens/homescreen/home_screen.dart';
import 'package:music_app/screens/playlistscreen/playlist_screen.dart';
import 'package:music_app/screens/searchscreen/search_screen.dart';

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
    const PlaylistScreen(),
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
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(30), topLeft: Radius.circular(30)),
            boxShadow: [
              BoxShadow(color: Colors.black38, spreadRadius: 5, blurRadius: 10),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
            child: BottomNavigationBar(
              items:  const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.home, size: 25), label: 'Home'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.favorite, size: 25),
                    label: 'Favorite'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.search, size: 25), label: 'Search'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.playlist_play, size: 25),
                    label: 'Playlist'),
              ],
              backgroundColor: const Color.fromARGB(255, 76, 104, 244),
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white70,
              showUnselectedLabels: true,
              type: BottomNavigationBarType.fixed,
              currentIndex: currentIndex,
              onTap: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
