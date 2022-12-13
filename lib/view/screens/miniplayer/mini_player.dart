import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_app/controller/get_all_song_controller.dart';
import 'package:music_app/controller/mini_player.dart';
import 'package:music_app/view/screens/musicplayingscreen/music_playing_screen.dart';
import 'package:music_app/view/style/text_animation.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MiniPlayer extends StatelessWidget {
  MiniPlayer({super.key});

  MiniPlayerController miniPlayerController = Get.put(MiniPlayerController());

  @override
  Widget build(BuildContext context) {
    miniPlayerController.miniPlayer();
    return ListTile(
      tileColor: const Color.fromARGB(255, 151, 195, 249),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MusicPlayingScreen(
              songModelList: GetAllSongController.playingSong,
            ),
          ),
        );
      },
      leading: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: QueryArtworkWidget(
          id: GetAllSongController
              .playingSong[GetAllSongController.audioPlayer.currentIndex!].id,
          type: ArtworkType.AUDIO,
          nullArtworkWidget: const Padding(
            padding: EdgeInsets.fromLTRB(15, 5, 5, 5),
            child: Icon(Icons.music_note),
          ),
        ),
      ),
      title: AnimatedText(
        text: GetAllSongController
            .playingSong[GetAllSongController.audioPlayer.currentIndex!]
            .displayNameWOExt,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
      subtitle: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Text(
          "${GetAllSongController.playingSong[GetAllSongController.audioPlayer.currentIndex!].artist}",
          maxLines: 1,
          style: const TextStyle(fontSize: 11, overflow: TextOverflow.ellipsis),
        ),
      ),
      trailing: FittedBox(
        fit: BoxFit.fill,
        child: Row(
          children: [
            IconButton(
                onPressed: () async {
                  if (GetAllSongController.audioPlayer.hasPrevious) {
                    await GetAllSongController.audioPlayer.seekToPrevious();
                    await GetAllSongController.audioPlayer.play();
                  } else {
                    await GetAllSongController.audioPlayer.play();
                  }
                },
                icon: const Icon(
                  Icons.skip_previous,
                  size: 35,
                  color: Colors.black,
                )),
            GetBuilder<MiniPlayerController>(builder: (controller) {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600,
                    shape: const CircleBorder()),
                onPressed: () async {
                  miniPlayerController.updateFuctions();
                },
                child: StreamBuilder<bool>(
                  stream: GetAllSongController.audioPlayer.playingStream,
                  builder: (context, snapshot) {
                    bool? playingStage = snapshot.data;
                    if (playingStage != null && playingStage) {
                      return const Icon(
                        Icons.pause,
                        color: Colors.white,
                        size: 35,
                      );
                    } else {
                      return const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 35,
                      );
                    }
                  },
                ),
              );
            }),
            IconButton(
                onPressed: (() async {
                  if (GetAllSongController.audioPlayer.hasNext) {
                    await GetAllSongController.audioPlayer.seekToNext();
                    await GetAllSongController.audioPlayer.play();
                  } else {
                    await GetAllSongController.audioPlayer.play();
                  }
                }),
                icon: const Icon(
                  Icons.skip_next,
                  size: 35,
                  color: Colors.black,
                )),
          ],
        ),
      ),
    );
  }
}
