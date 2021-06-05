import 'package:flower_app/screens/add_screen.dart';
import 'package:flower_app/screens/home_screen.dart';
import 'package:flower_app/screens/list_screen.dart';
import 'package:flower_app/screens/my_flowers.dart';
import 'package:flower_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreen createState() => _MainScreen();
}

class _MainScreen extends State<MainScreen> {

  int _currentIndex = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(16))
      ), child:SalomonBottomBar(

        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          SalomonBottomBarItem(
            icon: Icon(Icons.home),
            title: Text("Home"),
            selectedColor: darkGreen,
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.list),
            title: Text("All Flowers"),
            selectedColor: darkGreen,
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.add_circle_outline),
            title: Text("Add"),
            selectedColor: darkGreen,
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.person),
            title: Text("My Flowers"),
            selectedColor: darkGreen,
          ),
        ],
      )),
      body: _getBody(_currentIndex),
    );
  }

  _getBody(int index){
    switch(index){
      case 0: return HomeScreen();
      case 1: return ListScreen(goBack: backToHome,);
      case 2: return AddScreen(goBack: backToHome,);
      case 3: return MyFlowers(goBack: backToHome,);
    }
  }

  backToHome(){
    setState(() {
      _currentIndex = 0;
    });
  }


}
