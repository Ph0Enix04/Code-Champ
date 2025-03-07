import 'package:code_champ/Club.dart';
import 'package:code_champ/authentication/signup.dart';
import 'package:code_champ/forgotpass.dart';
import 'package:code_champ/login.dart';
import 'package:code_champ/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:code_champ/home.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen()
    );
  }
}