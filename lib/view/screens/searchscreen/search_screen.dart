import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:music_app/controller/get_all_song_controller.dart';
import 'package:music_app/controller/get_recent_song_controller.dart';
import 'package:music_app/controller/search_controller.dart';
import 'package:music_app/view/screens/musicplayingscreen/music_playing_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SearchScreen extends StatelessWidget {
  SearchController searchController = Get.put(SearchController());
  SearchScreen({super.key});

  TextEditingController searchEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    searchController.songsLoading();
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Search'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SafeArea(
            child: GetBuilder<SearchController>(builder: (controller) {
              return Column(
                children: [
                  CupertinoSearchTextField(
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Icon(
                        Icons.search,
                      ),
                    ),
                    itemSize: 20,
                    backgroundColor: const Color(0xFFF0EFFF),
                    controller: searchEditingController,
                    onChanged: (value) {
                      searchController.search(value);
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  searchController.foundSongs.isNotEmpty
                      ? ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return ListTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              minVerticalPadding: 10.0,
                              tileColor:
                                  const Color.fromARGB(255, 212, 231, 255),
                              contentPadding: const EdgeInsets.all(0),
                              leading: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: QueryArtworkWidget(
                                  id: searchController.foundSongs[index].id,
                                  type: ArtworkType.AUDIO,
                                  nullArtworkWidget: const Padding(
                                    padding: EdgeInsets.fromLTRB(15, 5, 5, 5),
                                    child: Icon(Icons.music_note),
                                  ),
                                ),
                              ),
                              title: Text(
                                searchController
                                    .foundSongs[index].displayNameWOExt,
                                maxLines: 1,
                              ),
                              subtitle: Text(
                                '${searchController.foundSongs[index].artist == "<unknown>" ? "Unknown Artist" : searchController.foundSongs[index].artist}',
                                maxLines: 1,
                              ),
                              onTap: () {
                                GetAllSongController.audioPlayer.setAudioSource(
                                    GetAllSongController.createSongList(
                                      searchController.foundSongs,
                                    ),
                                    initialIndex: index);
                                GetAllSongController.audioPlayer.play();
                                GetRecentSongController.addRecentlyPlayed(
                                    searchController.foundSongs[index].id);
                                Get.to(MusicPlayingScreen(
                                    songModelList:
                                        searchController.foundSongs));
                              },
                            );
                          },
                          itemCount: searchController.foundSongs.length,
                          separatorBuilder: (context, index) {
                            return const Divider(
                              height: 10.0,
                            );
                          },
                        )
                      : Center(
                          child: Lottie.asset(
                              'assets/108365-search-for-value.json')),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
