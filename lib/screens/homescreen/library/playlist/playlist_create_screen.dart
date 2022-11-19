import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:music_app/db/functions/playlist_db.dart';
import 'package:music_app/db/model/muzic_model.dart';
import 'package:music_app/screens/homescreen/library/playlist/playlist_listview.dart';
import 'package:music_app/screens/settings/settings_screen.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({
    super.key,
  });

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

TextEditingController editPlaylistController = TextEditingController();
TextEditingController nameController = TextEditingController();
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _PlaylistScreenState extends State<PlaylistScreen> {
  @override
  void initState() {
    super.initState();
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
                    const SizedBox(height: 10),
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
                    const SizedBox(height: 20),
                    Hive.box<MuzicModel>('playlistDb').isEmpty
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 100, horizontal: 50),
                            child: Column(
                              children: [
                                Image.asset('assets/images/add playlist.png'),
                                const Text(
                                  'Add Some Playlist',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ],
                            ),
                          )
                        : PlaylistListListView(
                            musicList: musicList,
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
                  saveButtonPressed(context);
                  Navigator.pop(context);
                  const snackBar = SnackBar(
                    backgroundColor: Colors.black,
                    content: Text(
                      'Playlist is added',
                      style: TextStyle(color: Colors.white),
                    ),
                    duration: Duration(milliseconds: 450),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
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

  Future<void> saveButtonPressed(context) async {
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
