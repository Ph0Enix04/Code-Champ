import 'package:code_champ/Club.dart';
import 'package:code_champ/controller.dart';
import 'package:code_champ/firebase_options.dart';
import 'package:code_champ/forgotpass.dart';
import 'package:code_champ/login.dart';
import 'package:code_champ/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:code_champ/home.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'name here',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(UserController());
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