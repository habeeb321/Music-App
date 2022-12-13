import 'package:get/get.dart';
import 'package:music_app/model/functions/mostly_song_db.dart';

class MostlyController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    init();
    update();
  }

  Future init() async {
    await MostlySongDb.getMostlyPlayedSongs();
    update();
  }
}
