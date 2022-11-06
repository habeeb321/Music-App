import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:music_app/db/functions/playlist_db.dart';
import 'package:music_app/db/model/muzic_model.dart';
import 'package:music_app/screens/playlistscreen/list_of_playlist.dart';
import 'package:music_app/screens/settings/settings_screen.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({
    super.key,
  });

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

final nameController = TextEditingController();
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _PlaylistScreenState extends State<PlaylistScreen> {
  final nameController = TextEditingController();
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
      child: ValueListenableBuilder(
        valueListenable: Hive.box<MuzicModel>('playlistDb').listenable(),
        builder:
            (BuildContext context, Box<MuzicModel> musicList, Widget? child) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: const Text('Playlist'),
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const SettingScreen();
                    }));
                  },
                  icon: const Icon(Icons.settings),
                ),
              ],
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Playlist',
                      style: TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.white),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      tileColor: const Color.fromARGB(255, 212, 233, 244),
                      leading: const Icon(Icons.add),
                      title: const Text('Add New Playlist'),
                      onTap: () {
                        addToPlaylist(context);
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Hive.box<MuzicModel>('playlistDb').isEmpty
                        ? const Center(
                            child: Text(
                              'Add Some Playlist',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: musicList.length,
                            itemBuilder: (context, index) {
                              final data = musicList.values.toList()[index];
                              return ValueListenableBuilder(
                                valueListenable:
                                    Hive.box<MuzicModel>('playlistDb')
                                        .listenable(),
                                builder: (BuildContext context,
                                    Box<MuzicModel> musicList, Widget? child) {
                                  return ListTile(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    tileColor: const Color.fromARGB(
                                        255, 212, 233, 244),
                                    leading: const Icon(Icons.playlist_play),
                                    title: Text(data.name),
                                    trailing: Wrap(children: [
                                      IconButton(
                                          onPressed: () {},
                                          icon: const Icon(
                                            Icons.edit,
                                          )),
                                      IconButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      'Delete Playlist'),
                                                  content: const Text(
                                                      'Are you sure you want to delete this playlist?'),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          musicList
                                                              .deleteAt(index);
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child:
                                                            const Text('Yes')),
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child:
                                                            const Text('No')),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          )),
                                    ]),
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
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
                          ),
                  ],
                ),
              ),
            ),
          );
        },
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
                Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.playlist_add),
                      hintText: 'Playlist Name',
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
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  saveButtonPressed();
                  Navigator.pop(context);
                }
              },
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

  Future<void> saveButtonPressed() async {
    final name = nameController.text.trim();
    if (name.isEmpty) {
      return;
    } else {
      final music = MuzicModel(name: name, songId: []);
      PlaylistDb.addPlaylist(music);
      nameController.clear();
    }
  }
}
