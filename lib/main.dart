import 'package:flutter/material.dart';
import 'package:code_champ/home.dart';
import 'package:get/get.dart';
import 'package:code_champ/splash_screen.dart';
<<<<<<< HEAD

=======
>>>>>>> 5adf43b (Initial commit)
import 'login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginPage()
    );
  }
}