import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/controller/get_all_song_controller.dart';
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

class _MusicPlayingScreenState extends State<MusicPlayingScreen> {
  Duration _duration = const Duration();
  Duration _position = const Duration();

  bool _isShuffle = false;

  int currentIndex = 0;

  @override
  void initState() {
    GetAllSongController.audioPlayer.currentIndexStream.listen((index) {
      if (index != null && mounted) {
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
        appBar: AppBar(
          leading: IconButton(
            onPressed: (() => Navigator.pop(context)),
            icon: const Icon(Icons.arrow_back_ios),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: GetAllSongController.audioPlayer.playing
                          ? const CircleAvatar(
                              radius: 130,
                              backgroundImage: AssetImage(
                                  'assets/images/music-playing-screen-unscreen.gif'),
                            )
                          : const CircleAvatar(
                              radius: 130,
                              backgroundImage: AssetImage(
                                  'assets/images/output-onlineimagetools.png'),
                            ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            widget.songModelList[currentIndex].displayNameWOExt,
                            style: const TextStyle(
                                fontSize: 20, color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
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
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.playlist_add,
                                color: Colors.white,
                              ),
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
                            )),
                            Text(
                              _duration.toString().split(".")[0],
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
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
                                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    _isShuffle = snapshot.data;
                                    if (_isShuffle) {
                                      return Icon(
                                        Icons.shuffle,
                                        color: Colors.red[600],
                                        size: 35,
                                      );
                                    } else {
                                      return const Icon(
                                        Icons.shuffle,
                                        size: 30,
                                        color: Colors.white,
                                      );
                                    }
                                  },
                                )),
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
                                  foregroundColor: Colors.blue,
                                  backgroundColor: Colors.red.shade600,
                                  shape: const CircleBorder()),
                              onPressed: () async {
                                if (GetAllSongController.audioPlayer.playing) {
                                  await GetAllSongController.audioPlayer
                                      .pause();
                                  setState(() {});
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
                                    return const Icon(
                                      Icons.pause,
                                      color: Colors.white,
                                      size: 50,
                                    );
                                  } else {
                                    return const Icon(
                                      Icons.play_arrow,
                                      color: Colors.white,
                                      size: 50,
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
                                      size: 30,
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
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
