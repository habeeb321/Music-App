import 'package:flutter/material.dart';
import 'package:music_app/controller/get_all_song_controller.dart';
import 'package:music_app/db/functions/playlist_db.dart';
import 'package:music_app/screens/settings/about_music.dart';
import 'package:music_app/screens/settings/terms_and_conditions.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

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
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Settings'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  tileColor: const Color.fromARGB(255, 212, 233, 244),
                  leading: const Icon(Icons.info),
                  title: const Text('About Muzic'),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const AboutMusicScreen();
                    }));
                  }),
              const SizedBox(
                height: 10,
              ),
              ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                tileColor: const Color.fromARGB(255, 212, 233, 244),
                leading: const Icon(Icons.lock_reset_sharp),
                title: const Text('Reset App'),
                onTap: () {
                  resetsApp(context);
                },
              ),
              const SizedBox(
                height: 10,
              ),
              ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                tileColor: const Color.fromARGB(255, 212, 233, 244),
                leading: const Icon(Icons.feed),
                title: const Text('Terms and conditions'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const TermsAndConditionScreen();
                  }));
                },
              ),
              const SizedBox(
                height: 10,
              ),
              ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                tileColor: const Color.fromARGB(255, 212, 233, 244),
                leading: const Icon(Icons.share),
                title: const Text('Share Muzic'),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> resetsApp(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reset App'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const [
                Text('Are you sure you want to reset this app?'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Reset'),
              onPressed: () {
                PlaylistDb.resetApp(context);
                GetAllSongController.audioPlayer.stop();
                Navigator.pop(context);
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
}
