import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/controller/get_all_song_controller.dart';
import 'package:music_app/screens/musicplayingscreen/music_playing_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class AllSongsListView extends StatefulWidget {
  const AllSongsListView({super.key});
  static List<SongModel> song = [];

  @override
  State<AllSongsListView> createState() => _AllSongsListViewState();
}

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

        return ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            allSongs.addAll(item.data!);
            return ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              minVerticalPadding: 10.0,
              tileColor: const Color.fromARGB(255, 231, 232, 238),
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
              title: Text(item.data![index].displayNameWOExt),
              subtitle: Text('${item.data![index].artist}'),
              trailing: Wrap(
                children: [
                  IconButton(
                      onPressed: () {}, icon: const Icon(Icons.playlist_add,)),
                  IconButton(
                      onPressed: () {}, icon: const Icon(Icons.favorite,)),
                ],
              ),
              onTap: () {
                GetAllSongController.audioPlayer.setAudioSource(
                      GetAllSongController.createSongList(
                        item.data!,
                      ),
                      initialIndex: index);
                  GetAllSongController.audioPlayer.play();
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return MusicPlayingScreen(
                    songModelList: item.data!,
                  );
                }));
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
}
