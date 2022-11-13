import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:music_app/controller/get_all_song_controller.dart';
import 'package:music_app/controller/get_recent_song_controller.dart';
import 'package:music_app/screens/musicplayingscreen/music_playing_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

late List<SongModel> allSong;
List<SongModel> foundSongs = [];
final audioPlayer = AudioPlayer();
final audiQuery = OnAudioQuery();

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    super.initState();
    songsLoading();
  }

  @override
  Widget build(BuildContext context) {
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
            child: Column(
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
                  onChanged: (value) => search(value),
                ),
                const SizedBox(
                  height: 10,
                ),
                foundSongs.isNotEmpty
                    ? ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            minVerticalPadding: 10.0,
                            tileColor: const Color.fromARGB(255, 212, 231, 255),
                            contentPadding: const EdgeInsets.all(0),
                            leading: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: QueryArtworkWidget(
                                id: foundSongs[index].id,
                                type: ArtworkType.AUDIO,
                                nullArtworkWidget: const Padding(
                                  padding: EdgeInsets.fromLTRB(15, 5, 5, 5),
                                  child: Icon(Icons.music_note),
                                ),
                              ),
                            ),
                            title: Text(
                              foundSongs[index].displayNameWOExt,
                              maxLines: 1,
                            ),
                            subtitle: Text(
                              '${foundSongs[index].artist == "<unknown>" ? "Unknown Artist" : foundSongs[index].artist}',
                              maxLines: 1,
                            ),
                            onTap: () {
                              GetAllSongController.audioPlayer.setAudioSource(
                                  GetAllSongController.createSongList(
                                    foundSongs,
                                  ),
                                  initialIndex: index);
                              GetAllSongController.audioPlayer.play();
                              GetRecentSongController.addRecentlyPlayed(
                                  foundSongs[index].id);
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return MusicPlayingScreen(
                                  songModelList: foundSongs,
                                );
                              }));
                            },
                          );
                        },
                        itemCount: foundSongs.length,
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
            ),
          ),
        ),
      ),
    );
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
    setState(() {
      foundSongs = results;
    });
  }
}
