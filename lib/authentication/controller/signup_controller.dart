import 'package:code_champ/utils/helpers/network_manager.dart';
import 'package:code_champ/utils/popups/full_screen_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../utils/constants/image_strings.dart';
import '../../utils/popups/loaders.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();
  ///variables
  final hidePassword = true.obs;
  final email = TextEditingController();
  final lastName = TextEditingController();
  final userName = TextEditingController();
  final password = TextEditingController();
  final firstName = TextEditingController();
  final phoneNumber = TextEditingController();
  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>(); //form key for form varification
  ///Signup
  Future<void> signup() async {
    try
    {
      // start loading
      TFullScreenLoader.openLoadingDialog('we are processing your information', TImages.docerAnimation);
      //check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if(!isConnected)
        {
          TFullScreenLoader.stopLoading();
          return;
        }
      //form validation
        if(signupFormKey.currentState!.validate())
          {
              TFullScreenLoader.stopLoading();
              return;
          }
      //privecy policy check

      //save authenticated user data in the firebase

      //show success message

      //move to verify email screen
    }
    catch(e) {
      //show some generic error to the user
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
    finally
    {
      TFullScreenLoader.stopLoading();
      //remove user
    }
  }
}