import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginController {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  //log in
  Future<UserCredential> logInWithEmail(String email, String password) async {
    try{
      UserCredential userCredential=await _auth.signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch(e){
      throw Exception(e);
    }
  }

  //log out
  Future<void> logOut() async{
    return await _auth.signOut();
  }

}