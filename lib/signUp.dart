import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code_champ/controller.dart';
import 'package:code_champ/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:icons_plus/icons_plus.dart';

import 'controller.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool isChecked = false;

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
              Text(
                'Create Your Account',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: Get.find<UserController>().userName,
                decoration: InputDecoration(
                  hintText: 'Username',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: Get.find<UserController>().firstName,
                decoration: InputDecoration(
                  hintText: 'First Name',
                  prefixIcon: Icon(Icons.account_circle),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: Get.find<UserController>().lastName,
                decoration: InputDecoration(

                  hintText: 'Last Name',
                  prefixIcon: Icon(Icons.account_circle),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: Get.find<UserController>().password,
                obscureText: true,
                decoration: InputDecoration(

                  hintText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: Get.find<UserController>().email,
                decoration: InputDecoration(
                  hintText: 'Email',

                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(height: 20),
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
              ElevatedButton(
                onPressed: () {
                  if (isChecked) {
                    // Handle registration action
                    CollectionReference collRef = FirebaseFirestore.instance.collection('user');
                    final userControlloer = Get.find<UserController>();
                    collRef.add(
                      {
                          'user name': userControlloer.userName.text,
                          'email': userControlloer.email.text,
                          'last name': userControlloer.firstName.text,
                          'first name': userControlloer.lastName.text,
                          'password' : userControlloer.password
                      }
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  } else {
                    // Show an error message or prompt
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please accept the terms and conditions.')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                    'Sign Up',
                style: TextStyle(
                  color: Colors.black,
                ),),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Already have an account?'),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );


                    },
                    child: Text(
                      'Log In',
                      style: TextStyle(
                        color: Colors.blueAccent,
                      ),
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
