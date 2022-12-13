import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:music_app/controller/get_all_song_controller.dart';
import 'package:music_app/model/functions/playlist_db.dart';
import 'package:music_app/model/model/muzic_model.dart';
import 'package:music_app/view/favoritescreen/view/favorite_button.dart';
import 'package:music_app/view/homescreen/view/library/playlist/view/playlist_add_song_screen.dart';
import 'package:music_app/view/musicplayingscreen/view/music_playing_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ListOfPlayList extends StatelessWidget {
  ListOfPlayList({super.key, required this.playlist, required this.findex});
  final MuzicModel playlist;
  final int findex;

  late List<SongModel> songPlaylist;
  @override
  Widget build(BuildContext context) {
    PlaylistDb.getAllPlaylist();
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
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text(playlist.name),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  ValueListenableBuilder(
                    valueListenable:
                        Hive.box<MuzicModel>('playlistDb').listenable(),
                    builder: (BuildContext context, Box<MuzicModel> music,
                        Widget? child) {
                      songPlaylist =
                          listPlaylist(music.values.toList()[findex].songId);
                      return songPlaylist.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 250, horizontal: 90),
                              child: Text(
                                'Add Some Songs',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            )
                          : ListView.separated(
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
                                      id: songPlaylist[index].id,
                                      type: ArtworkType.AUDIO,
                                      nullArtworkWidget: const Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(15, 5, 5, 5),
                                        child: Icon(Icons.music_note),
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    songPlaylist[index].title,
                                    maxLines: 1,
                                  ),
                                  subtitle: Text(
                                    songPlaylist[index].artist!,
                                    maxLines: 1,
                                  ),
                                  trailing: Wrap(
                                    children: [
                                      FavoriteButton(
                                        songFavorite: songPlaylist[index],
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          playlist.deleteData(
                                              songPlaylist[index].id);
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    List<SongModel> newMusicList = [
                                      ...songPlaylist
                                    ];
                                    GetAllSongController.audioPlayer.stop();
                                    GetAllSongController.audioPlayer
                                        .setAudioSource(
                                            GetAllSongController.createSongList(
                                                newMusicList),
                                            initialIndex: index);
                                    GetAllSongController.audioPlayer.play();
                                    Get.to(MusicPlayingScreen(
                                        songModelList: songPlaylist));
                                  },
                                );
                              },
                              itemCount: songPlaylist.length,
                              separatorBuilder: (context, index) {
                                return const Divider(
                                  height: 10.0,
                                );
                              },
                            );
                    },
                  )
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Get.to(SongListPage(playlist: playlist));
          },
          label: const Text('Add Songs'),
        ),
      ),
    );
  }

  List<SongModel> listPlaylist(List<int> data) {
    List<SongModel> plsongs = [];
    for (int i = 0; i < GetAllSongController.songscopy.length; i++) {
      for (int j = 0; j < data.length; j++) {
        if (GetAllSongController.songscopy[i].id == data[j]) {
          plsongs.add(GetAllSongController.songscopy[i]);
        }
      }
    }
    return plsongs;
  }
}
