import 'package:get/get.dart';
import 'package:music_app/view/screens/searchscreen/search_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SearchController extends GetxController {
  @override
  void onInit() {
    songsLoading();
    super.onInit();
  }

  void songsLoading() async {
    allSong = await audiQuery.querySongs(
      sortType: null,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
    foundSongs = allSong;
  }

  void search(String enteredKeyword) {
    List<SongModel> results = [];
    if (enteredKeyword.isEmpty) {
      results = allSong;
    } else {
      results = allSong
          .where((element) => element.displayNameWOExt
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    foundSongs = results;
    update();
  }
}
