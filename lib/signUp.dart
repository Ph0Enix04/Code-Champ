import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Thankyou.dart';
import 'controller.dart';
import 'login.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool isChecked = false;

  // Initialize UserController Once
  final UserController userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 40),
              Text('Create Your Account',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
              SizedBox(height: 20),

              // Username Field
              TextField(
                controller: userController.userName,
                decoration: InputDecoration(
                  hintText: 'Username',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                ),
              ),
              SizedBox(height: 16),

              // First Name Field
              TextField(
                controller: userController.firstName,
                decoration: InputDecoration(
                  hintText: 'First Name',
                  prefixIcon: Icon(Icons.account_circle),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                ),
              ),
              SizedBox(height: 16),

              // Last Name Field
              TextField(
                controller: userController.lastName,
                decoration: InputDecoration(
                  hintText: 'Last Name',
                  prefixIcon: Icon(Icons.account_circle),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                ),
              ),
              SizedBox(height: 16),

              // Email Field
              TextField(
                controller: userController.email,
                decoration: InputDecoration(
                  hintText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                ),
              ),
              SizedBox(height: 16),

              // Password Field
              TextField(
                controller: userController.password,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                ),
              ),
              SizedBox(height: 20),

              // Terms and Conditions Checkbox
              Row(
                children: <Widget>[
                  Checkbox(
                    value: isChecked,
                    onChanged: (bool? newValue) {
                      setState(() {
                        isChecked = newValue!;
                      });
                    },
                  ),
                  Expanded(
                    child: Text(
                      'I accept the terms and conditions',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Sign Up Button
              ElevatedButton(
                onPressed: () {
                  print('Sign Up button pressed');
                  if (isChecked) {
                    if (userController.email.text.isNotEmpty &&
                        userController.password.text.isNotEmpty &&
                        userController.userName.text.isNotEmpty) {
                      userController.registerUser();
                    } else {
                      Get.snackbar("Error", "Please fill in all fields.",
                          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
                    }
                  } else {
                    Get.snackbar("Error", "Please accept the terms and conditions.",
                        snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
                  }
                },
                child: Text('Sign Up', style: TextStyle(color: Colors.black)),
              ),
              SizedBox(height: 20),

              // Navigate to Login Page
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Already have an account?'),
                  TextButton(
                    onPressed: () {
                      Get.to(() => LoginPage());
                    },
                    child: Text(
                      'Log In',
                      style: TextStyle(color: Colors.blueAccent),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
