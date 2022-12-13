import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:music_app/view/splashscreen/controller/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  SplashController splashController = Get.put(SplashController());
  SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    splashController.goToBottomNavigation(context);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/52679-music-loader.json'),
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
}
