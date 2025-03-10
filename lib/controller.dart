import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class UserController extends GetxController{
  TextEditingController email = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController userName = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController firstName = TextEditingController();
  void onInit(){
    super.onInit();
    getData();
  }
  void getData() async {
    final ref = FirebaseDatabase.instance.ref();
  }

}