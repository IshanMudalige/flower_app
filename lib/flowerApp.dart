import 'package:flower_app/screens/login_screen.dart';

import 'package:flower_app/utils/colors.dart';
import 'package:flutter/material.dart';

class FlowerApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flower App',
      theme: ThemeData(
        accentColor:lightPink,
        primaryColor: lightPink
      ),
      home: LoginScreen(),
    );
  }
}