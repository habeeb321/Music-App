import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_app/model/model/muzic_model.dart';
import 'package:music_app/view/homescreen/view/library/playlist/view/playlist_added_song_screen.dart';

class PlaylistListListView extends StatelessWidget {
  Box<MuzicModel> musicList;
  PlaylistListListView({
    Key? key,
    required this.musicList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: musicList.length,
      itemBuilder: (context, index) {
        final data = musicList.values.toList()[index];

        return ValueListenableBuilder(
          valueListenable: Hive.box<MuzicModel>('playlistDb').listenable(),
          builder:
              (BuildContext context, Box<MuzicModel> musicList, Widget? child) {
            return ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              tileColor: const Color.fromARGB(255, 212, 233, 244),
              leading: const Icon(Icons.playlist_play),
              title: Text(data.name),
              trailing: IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Delete Playlist'),
                          content: const Text(
                              'Are you sure you want to delete this playlist?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                musicList.deleteAt(index);
                                Get.back();
                                Get.snackbar('Playlist', 'Playlist Is Deleted',
                                    colorText: Colors.white,
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.red.shade400);
                              },
                              child: const Text('Yes'),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: const Text('No'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  )),
              onTap: () {
                Get.to(ListOfPlayList(playlist: data, findex: index));
              },
            );
          },
        );
      },
      separatorBuilder: (context, index) {
        return const Divider(
          height: 10,
        );
      },
    );
  }
}
