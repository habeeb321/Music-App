import 'dart:async';

import 'package:get/get.dart';
import 'package:music_app/viewwer/screens/screens/bottomnavigation/view/bottom_navigation_screen.dart';

class SplashController extends GetxController {
  Future<void> goToBottomNavigation(context) async {
    //await GetRecentSongController.displayRecents();
    Timer(const Duration(seconds: 2), (() {
      Get.off(BottomNavigationScreen());
    }));
  }
}
