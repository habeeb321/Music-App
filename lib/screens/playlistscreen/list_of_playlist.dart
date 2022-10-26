import 'package:flutter/material.dart';

class ListOfPlayList extends StatelessWidget {
  const ListOfPlayList({super.key});

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Playlists',style: TextStyle(color: Colors.white)),
                  const SizedBox(height: 20,),
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 5,
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
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                )),
                          ],
                        ),
                        onTap: () {},
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
        ),
      ),
    );
  }
}
