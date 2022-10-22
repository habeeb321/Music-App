import 'package:flutter/material.dart';

class MusicPlayingScreen extends StatelessWidget {
  const MusicPlayingScreen({super.key});

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
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 100),
                    child: CircleAvatar(
                      radius: 130,
                      backgroundImage: AssetImage(
                          'assets/images/music-playing-screen-unscreen.gif'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 190),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('On My Way'),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.playlist_add),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: const [
                    Text('Alan Walker - On My Way'),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(
                  color: Colors.black,
                  thickness: 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('1:68'),
                    Text('5:20'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.shuffle, size: 40)),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.skip_previous, size: 50)),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.play_circle_outline,
                            size: 50, color: Colors.red)),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.skip_next, size: 50)),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.shuffle, size: 40)),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
