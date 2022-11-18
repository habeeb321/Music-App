import 'package:flutter/material.dart';
import 'package:music_app/controller/get_all_song_controller.dart';
import 'package:music_app/controller/get_recent_song_controller.dart';
import 'package:music_app/db/functions/favorite_db.dart';
import 'package:music_app/screens/favoritescreen/favorite_button.dart';
import 'package:music_app/screens/musicplayingscreen/music_playing_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';

class RecentlyPlayed extends StatefulWidget {
  const RecentlyPlayed({super.key});

  @override
  State<RecentlyPlayed> createState() => _RecentlyPlayedState();
}

class _RecentlyPlayedState extends State<RecentlyPlayed> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  static List<SongModel> recentSong = [];
  @override
  void initState() {
    super.initState();
    init();
    setState(() {});
  }

  Future init() async {
    await GetRecentSongController.getRecentSongs();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    FavoriteDb.favoriteSongs;
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
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Recent Songs'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                FutureBuilder(
                  future: GetRecentSongController.getRecentSongs(),
                  builder: (BuildContext context, items) {
                    return ValueListenableBuilder(
                      valueListenable:
                          GetRecentSongController.recentSongNotifier,
                      builder: (BuildContext context, List<SongModel> value,
                          Widget? child) {
                        if (value.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 100),
                            child: Center(
                              child: Column(
                                children: [
                                  Image.asset('assets/images/no songs.png'),
                                  const Text(
                                    'No Song In Recents',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          final temp = value.reversed.toList();
                          recentSong = temp.toSet().toList();
                          return FutureBuilder<List<SongModel>>(
                            future: _audioQuery.querySongs(
                              sortType: null,
                              orderType: OrderType.ASC_OR_SMALLER,
                              uriType: UriType.EXTERNAL,
                              ignoreCase: true,
                            ),
                            builder: (context, item) {
                              if (item.data == null) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (item.data!.isEmpty) {
                                return const Center(
                                    child: Text(
                                  'No Songs Available',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ));
                              }
                              return ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  return ListTile(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    minVerticalPadding: 10.0,
                                    tileColor: const Color.fromARGB(
                                        255, 212, 231, 255),
                                    contentPadding: const EdgeInsets.all(0),
                                    leading: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: QueryArtworkWidget(
                                        id: recentSong[index].id,
                                        type: ArtworkType.AUDIO,
                                        nullArtworkWidget: const Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(15, 5, 5, 5),
                                          child: Icon(Icons.music_note),
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      recentSong[index].displayNameWOExt,
                                      maxLines: 1,
                                    ),
                                    subtitle: Text(
                                      '${recentSong[index].artist == "<unknown>" ? "Unknown Artist" : recentSong[index].artist}',
                                      maxLines: 1,
                                    ),
                                    trailing: FavoriteButton(
                                        songFavorite: recentSong[index]),
                                    onTap: () {
                                      GetAllSongController.audioPlayer
                                          .setAudioSource(
                                              GetAllSongController
                                                  .createSongList(recentSong),
                                              initialIndex: index);
                                      GetAllSongController.audioPlayer.play();
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return MusicPlayingScreen(
                                          songModelList:
                                              GetAllSongController.playingSong,
                                        );
                                      }));
                                    },
                                  );
                                },
                                itemCount: recentSong.length,
                                separatorBuilder: (context, index) {
                                  return const Divider(
                                    height: 10.0,
                                  );
                                },
                              );
                            },
                          );
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
