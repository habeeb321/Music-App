import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_app/screens/settings/settings_screen.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Search'),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CupertinoSearchTextField(
                itemSize: 20,
                backgroundColor: const Color(0xFFF0EFFF),
                onChanged: (value) {
                  //Search function 
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
