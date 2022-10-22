import 'package:flutter/material.dart';
import 'package:music_app/screens/playlistscreen/list_of_playlist.dart';
import 'package:music_app/screens/settings/settings_screen.dart';

class PlaylistScreen extends StatelessWidget {
  const PlaylistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Playlist'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const SettingScreen();
              }));
            },
            icon: const Icon(Icons.settings),
          )
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Playlist',
              style:
                  TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
            ),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              tileColor: const Color.fromARGB(255, 212, 233, 244),
              leading:
                  IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
              title: const Text('Add New Playlist'),
              onTap: () {
                addToPlaylist(context);
              },
            ),
            const SizedBox(
              height: 20,
            ),
            ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  tileColor: const Color.fromARGB(255, 212, 233, 244),
                  leading: IconButton(
                      onPressed: () {}, icon: const Icon(Icons.playlist_play)),
                  title: const Text('Playlist 1'),
                  subtitle: const Text('10 songs'),
                  trailing: Wrap(children: [
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.edit,
                        )),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        )),
                  ]),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const ListOfPlayList();
                    }));
                  },
                );
              },
              itemCount: 1,
              separatorBuilder: (context, index) {
                return const Divider(
                  height: 10,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addToPlaylist(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create The Playlist'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    icon: Icon(Icons.playlist_add),
                    hintText: 'Enter Your Playlist Name',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Save'),
              onPressed: () {},
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
