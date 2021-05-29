import 'package:flower_app/screens/home_screen.dart';
import 'package:flower_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreen createState() => _MainScreen();
}

class _MainScreen extends State<MainScreen> {

  int _currentIndex = 0;
  final titleList = ['FlowerApp','Flower','My Flowers','Add Flower'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(16))
      ), child:SalomonBottomBar(

        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          /// Home
          SalomonBottomBarItem(
            icon: Icon(Icons.home),
            title: Text("Home"),
            selectedColor: Colors.purple,
          ),

          /// Likes
          SalomonBottomBarItem(
            icon: Icon(Icons.favorite_border),
            title: Text("Likes"),
            selectedColor: Colors.pink,
          ),

          /// Search
          SalomonBottomBarItem(
            icon: Icon(Icons.search),
            title: Text("Search"),
            selectedColor: Colors.orange,
          ),

          /// Profile
          SalomonBottomBarItem(
            icon: Icon(Icons.person),
            title: Text("Profile"),
            selectedColor: Colors.teal,
          ),
        ],
      )),
      body: _getBody(_currentIndex),
    );
  }

  _getBody(int index){
    switch(index){
      case 0: return HomeScreen();
      case 1: return null;
      case 2: return null;
      case 3: return null;
    }
  }


}
