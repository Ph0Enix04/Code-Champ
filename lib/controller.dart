import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // TextField Controllers
  var email = TextEditingController();
  var password = TextEditingController();
  var firstName = TextEditingController();
  var lastName = TextEditingController();
  var userName = TextEditingController();

  Future<bool> checkName(String userName) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("users/$userName");
    DataSnapshot snapshot = await ref.get();
    return snapshot.exists;
  }

  Future<bool> registerUser() async {
    try {
      // Check if the username already exists
      bool exists = await checkName(userName.text.trim());
      if (exists) {
        Get.snackbar(
          "Error",
          "Username already exists",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }

      // Register user in Firebase Authentication
      UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      // Use Firebase-generated UID
      String uid = userCredential.user!.uid;
      DatabaseReference ref = FirebaseDatabase.instance.ref("users/$uid");

      // Store user data in Firebase Realtime Database (excluding password)
      await ref.set({
        "email": email.text.trim(),
        "first_name": firstName.text.trim(),
        "last_name": lastName.text.trim(),
        "username": userName.text.trim(), // Store username separately
      });

      Get.snackbar(
        "Success",
        "User registered successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      print("✅ User registered successfully with UID: $uid");

      return true; // Registration successful
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = "This email is already registered.";
          break;
        case 'weak-password':
          errorMessage = "Password is too weak.";
          break;
        case 'invalid-email':
          errorMessage = "Invalid email format.";
          break;
        default:
          errorMessage = e.message ?? "An error occurred";
      }
      Get.snackbar(
        "Error",
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } catch (error) {
      Get.snackbar(
        "Error",
        "Failed to register user: $error",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }

  // Login method added to UserController for consistency
  Future<bool> loginUser(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      Get.snackbar(
        "Success",
        "Logged in successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = "No user found with this email.";
          break;
        case 'wrong-password':
          errorMessage = "Incorrect password.";
          break;
        case 'invalid-email':
          errorMessage = "Invalid email format.";
          break;
        default:
          errorMessage = e.message ?? "An error occurred";
      }
      Get.snackbar(
        "Error",
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }
}