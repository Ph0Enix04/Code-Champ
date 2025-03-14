import 'package:code_champ/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Thankyou.dart';

class UserController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // TextField Controllers
  var email = TextEditingController();
  var password = TextEditingController();
  var firstName = TextEditingController();
  var lastName = TextEditingController();
  var userName = TextEditingController();


  Future<void> registerUser() async {
    try {
      // Firebase Authentication: Register User
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      // Use `userName` as the unique ID instead of Firebase UID
      String uid = userName.text.trim();

      // Firebase Realtime Database Reference
      DatabaseReference ref = FirebaseDatabase.instance.ref("user/$uid");

      // Store user data in Firebase Realtime Database
      await ref.set({
        "email": email.text.trim(),
        "first_name": firstName.text.trim(),
        "last_name": lastName.text.trim(),
        "password": password.text,
      });

      // Show Success Message
      Get.snackbar("Success", "User registered successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.primaryColor,
          colorText: Get.theme.cardColor);
      print("✅ User registered successfully");
      Get.to(() => LoginPage());

    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.message ?? "An error occurred",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Get.theme.cardColor);
    } catch (error) {
      Get.snackbar("Error", "Failed to register user",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Get.theme.cardColor);
    }
  }
}
