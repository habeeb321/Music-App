import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_app/db/model/muzic_model.dart';
import 'package:music_app/screens/homescreen/library/playlist/playlist_added_song_screen.dart';

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
                                Navigator.pop(context);
                                const snackBar = SnackBar(
                                  backgroundColor: Colors.black,
                                  content: Text(
                                    'Playlist is deleted',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  duration: Duration(milliseconds: 350),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              },
                              child: const Text('Yes'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
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
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ListOfPlayList(
                    findex: index,
                    playlist: data,
                  );
                }));
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
