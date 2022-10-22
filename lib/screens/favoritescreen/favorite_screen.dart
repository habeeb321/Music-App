import 'package:flutter/material.dart';
import 'package:music_app/screens/settings/settings_screen.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Favorite'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context){
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
                'Favorites',
                style: TextStyle(fontWeight: FontWeight.w500,color: Colors.white),
              ),
              const SizedBox(
                height: 10,
              ),
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 10,
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
                    title: Text('Song $index'),
                    subtitle: Text('Artist $index'),
                    trailing: Wrap(
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.playlist_add,color: Colors.black,)),
                        IconButton(
                            onPressed: () {}, icon: const Icon(Icons.favorite,color: Colors.red,)),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider(
                    height: 10.0,
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
