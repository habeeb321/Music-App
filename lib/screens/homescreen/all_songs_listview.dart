import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/controller/get_all_song_controller.dart';
import 'package:music_app/controller/get_recent_song_controller.dart';
import 'package:music_app/db/functions/favorite_db.dart';
import 'package:music_app/db/functions/playlist_db.dart';
import 'package:music_app/db/model/muzic_model.dart';
import 'package:music_app/screens/favoritescreen/favorite_button.dart';
import 'package:music_app/screens/musicplayingscreen/music_playing_screen.dart';
import 'package:music_app/screens/playlistscreen/playlist_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class AllSongsListView extends StatefulWidget {
  const AllSongsListView({super.key});
  static List<SongModel> startSong = [];

  @override
  State<AllSongsListView> createState() => _AllSongsListViewState();
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
TextEditingController playlistController = TextEditingController();

class _AllSongsListViewState extends State<AllSongsListView> {
  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  void requestPermission() {
    Permission.storage.request();
  }

  final OnAudioQuery _audioQuery = OnAudioQuery();
  final AudioPlayer _audioPlayer = AudioPlayer();

  List<SongModel> allSongs = [];

  playsong(String? uri) {
    try {
      _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
      _audioPlayer.play();
    } on Exception {
      log('Error Parsing Song');
    }
  }

  @override
  Widget build(BuildContext context) {
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
        AllSongsListView.startSong = item.data!;
        if (!FavoriteDb.isInitialized) {
          FavoriteDb.intialize(item.data!);
        }

        GetAllSongController.songscopy = item.data!;

        return ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            allSongs.addAll(item.data!);
            return ValueListenableBuilder(
              valueListenable: GetRecentSongController.recentSongNotifier,
              builder:
                  (BuildContext context, List<SongModel> value, Widget? child) {
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
                      id: item.data![index].id,
                      type: ArtworkType.AUDIO,
                      nullArtworkWidget: const Padding(
                        padding: EdgeInsets.fromLTRB(15, 5, 5, 5),
                        child: Icon(Icons.music_note),
                      ),
                    ),
                  ),
                  title: Text(
                    item.data![index].displayNameWOExt,
                    maxLines: 1,
                  ),
                  subtitle: Text(
                    '${item.data![index].artist == "<unknown>" ? "Unknown Artist" : item.data![index].artist}',
                    maxLines: 1,
                  ),
                  trailing: Wrap(
                    children: [
                      IconButton(
                        onPressed: () {
                          addPlaylistBottomSheet();
                        },
                        icon: const Icon(Icons.playlist_add),
                      ),
                      FavoriteButton(
                          songFavorite: AllSongsListView.startSong[index]),
                    ],
                  ),
                  onTap: () {
                    GetAllSongController.audioPlayer.setAudioSource(
                        GetAllSongController.createSongList(
                          item.data!,
                        ),
                        initialIndex: index);
                    GetAllSongController.audioPlayer.play();
                    //recent song function
                    GetRecentSongController.addRecentlyPlayed(
                        item.data![index].id);
                    //mostly played function

                    //for navigating to nowplay
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return MusicPlayingScreen(
                        songModelList: item.data!,
                      );
                    }));
                  },
                );
              },
            );
          },
          itemCount: item.data!.length,
          separatorBuilder: (context, index) {
            return const Divider(
              height: 10.0,
            );
          },
        );
      },
    );
  }

  Future<void> addPlaylistBottomSheet() async {
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: SizedBox(
              height: 192,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Add To Playlist',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )),
                  const SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: playlistController,
                      autofocus: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 94, 172, 235)),
                            borderRadius: BorderRadius.circular(15)),
                        hintText: 'Enter your playlist name',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter your playlist name";
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton.icon(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            saveButtonPressed();
                          }
                        },
                        icon: const Icon(Icons.check),
                        label: const Text('Add')),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> saveButtonPressed() async {
    final name = playlistController.text.trim();
    if (name.isEmpty) {
      return;
    } else {
      final music = MuzicModel(name: name, songId: []);
      PlaylistDb.addPlaylist(music);
      playlistController.clear();
    }
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const PlaylistScreen()));
  }
}
