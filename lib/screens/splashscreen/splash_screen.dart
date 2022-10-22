import 'dart:async';

import 'package:flutter/material.dart';
import 'package:music_app/screens/bottomnavigation/bottom_navigation_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    goToBottomNavigation(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/km0f2lw5-unscreen.gif'),
          const SizedBox(
            height: 150,
          ),
          const Text(
            'Muzic Player',
            style: TextStyle(fontSize: 25, color: Colors.indigo),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

Future<void> goToBottomNavigation(context) async {
  Timer(const Duration(seconds: 4), (() {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) =>  const BottomNavigationScreen()));
    }));
}
