import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:music_app/controller/get_all_song_controller.dart';
import 'package:music_app/controller/get_mostlyplayed_controller.dart';
import 'package:music_app/db/functions/favorite_db.dart';
import 'package:music_app/db/functions/playlist_db.dart';
import 'package:music_app/db/model/muzic_model.dart';
import 'package:music_app/screens/favoritescreen/favbut_musicplaying.dart';
import 'package:music_app/screens/homescreen/library/playlist/playlist_create_screen.dart';
import 'package:music_app/style/text_animation.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MusicPlayingScreen extends StatefulWidget {
  const MusicPlayingScreen({
    super.key,
    required this.songModelList,
  });
  final List<SongModel> songModelList;
  @override
  State<MusicPlayingScreen> createState() => _MusicPlayingScreenState();
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
TextEditingController playlistController = TextEditingController();

class _MusicPlayingScreenState extends State<MusicPlayingScreen> {
  Duration _duration = const Duration();
  Duration _position = const Duration();

  bool _isShuffle = false;
  int currentIndex = 0;
  int counter = 0;

  @override
  void initState() {
    GetAllSongController.audioPlayer.currentIndexStream.listen((index) {
      if (index != null) {
        setState(() {
          currentIndex = index;
        });
        GetAllSongController.currentIndexes = index;
      }
    });
    super.initState();
    playSong();
  }

  @override
  Widget build(BuildContext context) {
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
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      onPressed: () {
                        setState(() {});
                        Navigator.pop(context);
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
                        text:
                            widget.songModelList[currentIndex].displayNameWOExt,
                        style:
                            const TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.songModelList[currentIndex].artist
                                        .toString() ==
                                    "<unknown>"
                                ? "Unknown Artist"
                                : widget.songModelList[currentIndex].artist
                                    .toString(),
                            style: const TextStyle(color: Colors.white),
                            maxLines: 1,
                          ),
                          Row(
                            children: [
                              FavButMusicPlaying(
                                  songFavoriteMusicPlaying:
                                      widget.songModelList[currentIndex]),
                              IconButton(
                                onPressed: () {
                                  addPlaylistBottomSheet();
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
                            _position.toString().split(".")[0],
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
                              value: _position.inSeconds.toDouble(),
                              max: _duration.inSeconds.toDouble(),
                              onChanged: (value) {
                                setState(() {
                                  changeToSeconds(value.toInt());
                                  value = value;
                                });
                              },
                            ),
                          ),
                          Text(
                            _duration.toString().split(".")[0],
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
                              _isShuffle == false
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
                                _isShuffle = snapshot.data;
                                if (_isShuffle) {
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
                                  await GetAllSongController.audioPlayer.play();
                                } else {
                                  await GetAllSongController.audioPlayer.play();
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
                                setState(() {
                                  counter++;
                                  log(counter.toString());
                                  if (counter == 3) {
                                    GetMostlyPlayedController.mostlyPlayedSong
                                        .add(
                                            widget.songModelList[currentIndex]);
                                  }
                                });
                                await GetAllSongController.audioPlayer.pause();
                              } else {
                                await GetAllSongController.audioPlayer.play();
                                setState(() {});
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
                                if (GetAllSongController.audioPlayer.hasNext) {
                                  await GetAllSongController.audioPlayer
                                      .seekToNext();
                                  await GetAllSongController.audioPlayer.play();
                                } else {
                                  await GetAllSongController.audioPlayer.play();
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
              ),
            ),
          ),
        ),
      ),
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

  void changeToSeconds(int seconds) {
    Duration duration = Duration(seconds: seconds);
    GetAllSongController.audioPlayer.seek(duration);
  }

  void playSong() {
    GetAllSongController.audioPlayer.durationStream.listen((eventd) {
      setState(() {
        _duration = eventd!;
      });
    });
    GetAllSongController.audioPlayer.positionStream.listen((eventp) {
      setState(() {
        _position = eventp;
      });
    });
  }
}
