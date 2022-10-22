import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/screens/musicplayingscreen/music_playing_screen.dart';
import 'package:music_app/screens/settings/settings_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  void requestPermission() {
    Permission.storage.request();
  }

  final OnAudioQuery _audioQuery =  OnAudioQuery();
  final AudioPlayer _audioPlayer = AudioPlayer();

  playsong(String? uri){
    try{
      _audioPlayer.setAudioSource(
      AudioSource.uri(
        Uri.parse(uri!)
      )
    );
    _audioPlayer.play();
    } on Exception {
      log('Error Parsing Song');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Home'),
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Recently Played',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 15),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 150,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 130,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(255, 231, 232, 238),
                      ),
                    );
                  },
                  itemCount: 10,
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      width: 10,
                    );
                  },
                ),
              ),
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
                  }
                  if (item.data!.isEmpty) {
                    return const Text('No Songs Available');
                  }
                  return ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minVerticalPadding: 10.0,
                        tileColor: const Color.fromARGB(255, 105, 195, 241),
                        contentPadding: const EdgeInsets.all(0),
                        leading: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color.fromARGB(255, 231, 232, 238),
                            ),
                          ),
                        ),
                        title: Text(item.data![index].displayNameWOExt),
                        subtitle: Text('${item.data![index].artist}'),
                        trailing: Wrap(
                          children: [
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.playlist_add)),
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.favorite)),
                          ],
                        ),
                        onTap: () {
                          // Navigator.push(context,
                          //     MaterialPageRoute(builder: (context) {
                          //   return const MusicPlayingScreen();
                          // }));
                          playsong(item.data![index].uri);
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
}
