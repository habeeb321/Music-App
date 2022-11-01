import 'package:flutter/material.dart';
import 'package:music_app/db/model/muzic_model.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongListPage extends StatefulWidget {
  const SongListPage({super.key, required this.playlist});
  final MuzicModel playlist;

  @override
  State<SongListPage> createState() => _SongListPageState();
}

const colorw = Colors.white;

class _SongListPageState extends State<SongListPage> {
  final OnAudioQuery audioQuery = OnAudioQuery();
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
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Add Songs',
                      style: TextStyle(
                          color: colorw,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: colorw,
                        ))
                  ],
                ),
                const SizedBox(height: 10),
                FutureBuilder<List<SongModel>>(
                  future: audioQuery.querySongs(
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
                      return const Center(
                          child: Text(
                        'No Songs Available',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ));
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
                          trailing: IconButton(
                            onPressed: () {
                              songAddToPlaylist(item.data![index]);
                            },
                            icon: const Icon(Icons.add),
                          ),
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
        )),
      ),
    );
  }

  void songAddToPlaylist(SongModel data) {
    if (!widget.playlist.isValueIn(data.id)) {
      widget.playlist.add(data.id);
      const snackbar = SnackBar(
          backgroundColor: Colors.black,
          content: Text(
            'Added to Playlist',
            style: TextStyle(color: Colors.white),
          ));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }
}
