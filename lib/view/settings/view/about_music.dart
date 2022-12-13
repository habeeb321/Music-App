import 'package:flutter/material.dart';

class AboutMusicScreen extends StatelessWidget {
  const AboutMusicScreen({super.key});

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
            child: SingleChildScrollView(
              child: Column(
                children: const [
                  Text(
                    'About Muzic',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                      '''
Welcome to Muzic App, your number one source for music . We're dedicated to providing you the very best quality of sound and the music varient, with an emphasis on new features,playlists and favourites, and a rich user experience.


Founded in 2022 by Habeebu Rahman KT, Muzic App is our first major project with a basic performance of music hub and creates a better version in future. Muzic gives you the best music experience that you never had. It includes attractive mode of UI’s and good practices.


It gives good quality and had increased the settings to power up the system as well as  to provide better  music rythms.


We hope you enjoy our music as much as we enjoy offering them to you. If you have any questions or comments, please don't hesitate to contact us.


Sincerely,


Habeebu Rahman KT

 ''',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
