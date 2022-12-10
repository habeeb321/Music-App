import 'package:get/get.dart';

class BottomNavController extends GetxController {
  int ucurrentIndex = 0;
  get currentIndex => ucurrentIndex;
  set currentIndex(index) {
    ucurrentIndex = index;
    update();
  }
}
