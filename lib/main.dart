import 'package:firebase_core/firebase_core.dart';
import 'package:flower_app/flowerApp.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(FlowerApp());
}



