import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home.dart';
import 'login.dart';

class AuthGate extends StatelessWidget{
  const AuthGate({super.key});

  Future<void> logOut() async{
    //await FirebaseAuth.instance.signOut();
    return;
  }

  @override
  Widget build (BuildContext context){
    return Scaffold(
        body: FutureBuilder(
          future: logOut(),
          builder: (context, snapshot) {
            return StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return HomePage();
                } else {
                  return const LoginPage();
                }
              },
            );
          },
        ),
    );
  }
}
