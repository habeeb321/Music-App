import 'package:curved_navigation_bar/curved_navigation_bar.dart';
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

  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

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
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Colors.transparent,
          color: const Color(0xFFF0EFFF),
          height: 60,
          key: _bottomNavigationKey,
          items: const [
            Icon(Icons.home, size: 25),
            Icon(Icons.favorite, size: 25),
            Icon(Icons.search, size: 25),
            Icon(Icons.playlist_play, size: 25),
          ],
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
