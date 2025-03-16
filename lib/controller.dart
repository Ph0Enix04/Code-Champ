import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  // TextField Controllers
  var email = TextEditingController();
  var password = TextEditingController();
  var firstName = TextEditingController();
  var lastName = TextEditingController();
  var userName = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _loadUserData(); // Load user data when controller initializes
  }

  // Check if username exists
  Future<bool> checkName(String userName) async {
    DatabaseReference ref = _dbRef.child("users").child(userName);
    DataSnapshot snapshot = await ref.get();
    return snapshot.exists;
  }

  // Register user
  Future<bool> registerUser() async {
    try {
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

      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      String uid = userCredential.user!.uid;
      DatabaseReference ref = _dbRef.child("users").child(uid);

      await ref.set({
        "email": email.text.trim(),
        "first_name": firstName.text.trim(),
        "last_name": lastName.text.trim(),
        "username": userName.text.trim(),
      });

      Get.snackbar(
        "Success",
        "User registered successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      print("✅ User registered successfully with UID: $uid");

      return true;
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

  // Login user
  Future<bool> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      await _loadUserData(); // Load username after login
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

  // Load user data from Realtime Database
  Future<void> _loadUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        DatabaseReference ref = _dbRef.child("users").child(user.uid);
        DataSnapshot snapshot = await ref.get();
        if (snapshot.exists) {
          Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
          userName.text = data['username'] ?? 'Anonymous';
        } else {
          userName.text = 'Anonymous'; // Default if no data exists
        }
        update(); // Notify GetBuilder to rebuild
      } catch (e) {
        Get.snackbar(
          "Error",
          "Failed to load user data: $e",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        userName.text = 'Anonymous'; // Fallback on error
        update();
      }
    } else {
      userName.text = 'Guest'; // Fallback if not logged in
      update();
    }
  }
}