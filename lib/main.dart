import 'package:code_champ/home.dart';
import 'package:code_champ/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:code_champ/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:code_champ/firebase_options.dart';

import 'Settings.dart';
import 'controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'name here',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(UserController());
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: const MyApp(), // Keeping MyApp as const
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // MyApp remains const

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home:  SplashScreen(), // Keeping SettingsPage const
    );
  }
}
