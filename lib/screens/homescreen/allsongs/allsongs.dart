import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:music_app/screens/homescreen/allsongs/drawers.dart';
import 'package:music_app/screens/homescreen/library/library.dart';
import 'package:music_app/screens/homescreen/library/playlist/playlist_create_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../controller/get_all_song_controller.dart';
import '../../../controller/get_mostlyplayed_controller.dart';
import '../../../controller/get_recent_song_controller.dart';
import '../../../db/functions/favorite_db.dart';
import '../../../db/functions/playlist_db.dart';
import '../../../db/model/muzic_model.dart';
import '../../favoritescreen/favorite_button.dart';
import '../../musicplayingscreen/music_playing_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
TextEditingController playlistController = TextEditingController();
List<SongModel> startSong = [];

class _HomeScreenState extends State<HomeScreen> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  List<SongModel> allSongs = [];

  @override
  void initState() {
    requestPermission();
    super.initState();
  }

  void requestPermission() async {
    if (!kIsWeb) {
      bool permissionStatus = await _audioQuery.permissionsStatus();
      if (!permissionStatus) {
        await _audioQuery.permissionsRequest();
      }
      setState(() {});
    }
    Permission.storage.request();
  }

  @override
  Widget build(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    return Scaffold(
      backgroundColor: Colors.transparent,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: const [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromRGBO(74, 107, 228, 1),
                image: DecorationImage(
                  image: AssetImage('assets/images/logo.jpg'),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 115, left: 90),
                child: Text(
                  'Muzic App',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
            ),
            HomescreenDrawers(),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const LibrarySection(),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'All Songs',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              FutureBuilder<List<SongModel>>(
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
                  } else if (item.data!.isEmpty) {
                    return const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 200, horizontal: 100),
                      child: Text(
                        'No Songs Available',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    );
                  }

                  startSong = item.data!;
                  if (!FavoriteDb.isInitialized) {
                    FavoriteDb.intialize(item.data!);
                  }

                  GetAllSongController.songscopy = item.data!;

                  return ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      allSongs.addAll(item.data!);
                      return ValueListenableBuilder(
                        valueListenable:
                            GetRecentSongController.recentSongNotifier,
                        builder: (BuildContext context, List<SongModel> value,
                            Widget? child) {
                          return ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            minVerticalPadding: 10.0,
                            tileColor: const Color.fromARGB(255, 212, 231, 255),
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
                            title: Text(
                              item.data![index].displayNameWOExt,
                              maxLines: 1,
                            ),
                            subtitle: Text(
                              '${item.data![index].artist == "<unknown>" ? "Unknown Artist" : item.data![index].artist}',
                              maxLines: 1,
                            ),
                            trailing: Wrap(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    addPlaylistBottomSheet();
                                  },
                                  icon: const Icon(Icons.playlist_add),
                                ),
                                FavoriteButton(songFavorite: startSong[index]),
                              ],
                            ),
                            onTap: () {
                              GetAllSongController.audioPlayer.setAudioSource(
                                  GetAllSongController.createSongList(
                                    item.data!,
                                  ),
                                  initialIndex: index);

                              GetAllSongController.audioPlayer.play();
                              //recent song function
                              GetRecentSongController.addRecentlyPlayed(
                                  item.data![index].id);
                              //mostly played function
                              GetMostlyPlayedController.addMostlyPlayed(
                                  item.data![index].id);
                              //for navigating to nowplay
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return MusicPlayingScreen(
                                  songModelList: item.data!,
                                );
                              }));
                            },
                          );
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
              ),
            ],
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
}
