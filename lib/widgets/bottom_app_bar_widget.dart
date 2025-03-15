import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterprojet/screens/list_ville_screen.dart';

import '../screens/home_screen.dart';


class BottomAppBarWidget extends StatelessWidget {
  const BottomAppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {

    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return BottomAppBar(
      height: 50,
      shape: const CircularNotchedRectangle(),
      color: isDark ?  Colors.grey[800] : Colors.blue[800],
      notchMargin: 6,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.home, color: Colors.white, size: 35,),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomeScreen())
              );
            },
          ),
          const SizedBox(width: 40),
          IconButton(
            icon: const Icon(Icons.list, color: Colors.white, size: 35,),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ListVilleScreen())
              );
            },
          ),
        ],
      ),

    );
  }
}

class BottomPlus extends StatelessWidget {
  const BottomPlus({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60, // Diamètre du cercle
      height: 60,
      child: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.white,
        foregroundColor: Colors.blueAccent,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 40),
      ),
    );
  }
}

