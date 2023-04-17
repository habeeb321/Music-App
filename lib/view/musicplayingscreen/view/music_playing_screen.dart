import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:music_app/controller/get_all_song.dart';
import 'package:music_app/model/functions/favorite_db.dart';
import 'package:music_app/model/functions/playlist_db.dart';
import 'package:music_app/model/model/muzic_model.dart';
import 'package:music_app/view/favoritescreen/view/favbut_musicplaying.dart';
import 'package:music_app/view/homescreen/view/library/playlist/view/playlist_create_screen.dart';
import 'package:music_app/view/musicplayingscreen/controller/music_play_controller.dart';
import 'package:music_app/view/musicplayingscreen/view/widgets/text_animation.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MusicPlayingScreen extends StatelessWidget {
  MusicPlayingScreen({super.key, required this.songModelList});
  List<SongModel> songModelList;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController playlistController = TextEditingController();
  MusicPlayController musicPlayController = Get.put(MusicPlayController());

  bool isShuffle = false;
  int currentIndex = 0;
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    musicPlayController.playSong();
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
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: GetBuilder<MusicPlayController>(builder: (controller) {
                return Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        onPressed: () {
                          musicPlayController.setState();
                          Get.back();
                          FavoriteDb.favoriteSongs.notifyListeners();
                        },
                        icon: const Icon(Icons.keyboard_arrow_down),
                        color: Colors.white,
                      ),
                    ),
                    Center(
                      child: GetAllSongController.audioPlayer.playing
                          ? Lottie.asset(
                              'assets/81966-girl-listening-to-music.json',
                              animate: true)
                          : Lottie.asset(
                              'assets/81966-girl-listening-to-music.json',
                              animate: false),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.04,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedText(
                          text: GetAllSongController
                              .playingSong[GetAllSongController
                                  .audioPlayer.currentIndex!]
                              .displayNameWOExt,
                          style: const TextStyle(
                              fontSize: 20, color: Colors.white),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              GetAllSongController
                                          .playingSong[GetAllSongController
                                              .audioPlayer.currentIndex!]
                                          .artist
                                          .toString() ==
                                      "<unknown>"
                                  ? "Unknown Artist"
                                  : GetAllSongController
                                      .playingSong[GetAllSongController
                                          .audioPlayer.currentIndex!]
                                      .artist
                                      .toString(),
                              style: const TextStyle(color: Colors.white),
                              maxLines: 1,
                            ),
                            Row(
                              children: [
                                FavButMusicPlaying(
                                    songFavoriteMusicPlaying:
                                        songModelList[currentIndex]),
                                IconButton(
                                  onPressed: () {
                                    addPlaylistBottomSheet(context);
                                  },
                                  icon: const Icon(
                                    Icons.playlist_add,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text(
                              musicPlayController.position
                                  .toString()
                                  .split(".")[0],
                              style: const TextStyle(color: Colors.white),
                            ),
                            Expanded(
                              child: Slider(
                                activeColor:
                                    const Color.fromARGB(240, 102, 21, 208),
                                inactiveColor: Colors.grey,
                                min: const Duration(microseconds: 0)
                                    .inSeconds
                                    .toDouble(),
                                value: musicPlayController.position.inSeconds
                                    .toDouble(),
                                max: musicPlayController.duration.inSeconds
                                    .toDouble(),
                                onChanged: (value) {
                                  musicPlayController
                                      .changeToSeconds(value.toInt());
                                },
                              ),
                            ),
                            Text(
                              musicPlayController.duration
                                  .toString()
                                  .split(".")[0],
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {
                                isShuffle == false
                                    ? GetAllSongController.audioPlayer
                                        .setShuffleModeEnabled(true)
                                    : GetAllSongController.audioPlayer
                                        .setShuffleModeEnabled(false);
                              },
                              icon: StreamBuilder<bool>(
                                stream: GetAllSongController
                                    .audioPlayer.shuffleModeEnabledStream,
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  isShuffle = snapshot.data;
                                  if (isShuffle) {
                                    return Icon(
                                      Icons.shuffle,
                                      color: Colors.red[600],
                                      size: 40,
                                    );
                                  } else {
                                    return const Icon(
                                      Icons.shuffle,
                                      size: 30,
                                      color: Colors.white,
                                    );
                                  }
                                },
                              ),
                            ),
                            IconButton(
                                onPressed: () async {
                                  if (GetAllSongController
                                      .audioPlayer.hasPrevious) {
                                    await GetAllSongController.audioPlayer
                                        .seekToPrevious();
                                    await GetAllSongController.audioPlayer
                                        .play();
                                  } else {
                                    await GetAllSongController.audioPlayer
                                        .play();
                                  }
                                },
                                icon: const Icon(
                                  Icons.skip_previous,
                                  size: 40,
                                  color: Colors.white,
                                )),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red.shade600,
                                  shape: const CircleBorder()),
                              onPressed: () async {
                                if (GetAllSongController.audioPlayer.playing) {
                                  musicPlayController.playButton(songModelList);
                                  await GetAllSongController.audioPlayer
                                      .pause();
                                } else {
                                  await GetAllSongController.audioPlayer.play();
                                  musicPlayController.setState();
                                }
                              },
                              child: StreamBuilder<bool>(
                                stream: GetAllSongController
                                    .audioPlayer.playingStream,
                                builder: (context, snapshot) {
                                  bool? playingStage = snapshot.data;
                                  if (playingStage != null && playingStage) {
                                    return const Padding(
                                      padding: EdgeInsets.all(6.0),
                                      child: Icon(
                                        Icons.pause,
                                        color: Colors.white,
                                        size: 60,
                                      ),
                                    );
                                  } else {
                                    return const Padding(
                                      padding: EdgeInsets.all(6.0),
                                      child: Icon(
                                        Icons.play_arrow,
                                        color: Colors.white,
                                        size: 60,
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                            IconButton(
                                onPressed: () async {
                                  if (GetAllSongController
                                      .audioPlayer.hasNext) {
                                    await GetAllSongController.audioPlayer
                                        .seekToNext();
                                    await GetAllSongController.audioPlayer
                                        .play();
                                  } else {
                                    await GetAllSongController.audioPlayer
                                        .play();
                                  }
                                },
                                icon: const Icon(
                                  Icons.skip_next,
                                  size: 40,
                                  color: Colors.white,
                                )),
                            IconButton(
                              onPressed: () {
                                GetAllSongController.audioPlayer.loopMode ==
                                        LoopMode.one
                                    ? GetAllSongController.audioPlayer
                                        .setLoopMode(LoopMode.all)
                                    : GetAllSongController.audioPlayer
                                        .setLoopMode(LoopMode.one);
                              },
                              icon: StreamBuilder<LoopMode>(
                                stream: GetAllSongController
                                    .audioPlayer.loopModeStream,
                                builder: (context, snapshot) {
                                  final loopMode = snapshot.data;
                                  if (LoopMode.one == loopMode) {
                                    return Icon(
                                      Icons.repeat_one,
                                      color: Colors.red[600],
                                      size: 40,
                                    );
                                  } else {
                                    return const Icon(
                                      Icons.repeat,
                                      color: Colors.white,
                                      size: 30,
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> addPlaylistBottomSheet(context) async {
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
    Get.off(() => PlaylistScreen());
  }
}
