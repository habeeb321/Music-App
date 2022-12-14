import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_app/controller/get_all_song.dart';
import 'package:music_app/view/homescreen/controller/home_request_permission_controller.dart';
import 'package:music_app/model/functions/favorite_db.dart';
import 'package:music_app/model/functions/playlist_db.dart';
import 'package:music_app/model/model/muzic_model.dart';
import 'package:music_app/view/homescreen/view/drawers.dart';
import 'package:music_app/view/homescreen/view/library/library.dart';
import 'package:music_app/view/homescreen/view/library/mostly/controller/mostly_controller.dart';
import 'package:music_app/view/homescreen/view/library/playlist/view/playlist_create_screen.dart';
import 'package:music_app/view/homescreen/view/library/recently/controller/recent_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../favoritescreen/view/favorite_button.dart';
import '../../musicplayingscreen/view/music_playing_screen.dart';

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
TextEditingController playlistController = TextEditingController();
List<SongModel> startSong = [];

class HomeScreen extends StatelessWidget {
  MostlyController mostlyController = Get.put(MostlyController());
  RecentController recentController = Get.put(RecentController());
  PermissionController permissionController = Get.put(PermissionController());
  final OnAudioQuery _audioQuery = OnAudioQuery();
  List<SongModel> allSongs = [];

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      permissionController.requestPermission();
    });
    return GetBuilder<PermissionController>(builder: (controller) {
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
                        padding: EdgeInsets.symmetric(
                            vertical: 200, horizontal: 100),
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
                        return GetBuilder<RecentController>(
                            builder: (controller) {
                          final recentValue =
                              recentController.recentSongNotifier;
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
                                    addPlaylistBottomSheet(context);
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
                              recentController
                                  .addRecentlyPlayed(item.data![index].id);
                              //mostly played function
                              mostlyController
                                  .addMostlyPlayed(item.data![index].id);
                              //for navigating to nowplay
                              Get.to(MusicPlayingScreen(
                                  songModelList: item.data!));
                            },
                          );
                        });
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
    });
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
    Get.off(PlaylistScreen());
  }
}
