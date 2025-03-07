import 'package:code_champ/authentication/controller/signup_controller.dart';
import 'package:code_champ/utils/helpers/helper_functions.dart';
import 'package:code_champ/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../utils/constants/colors.dart';
import '../utils/constants/sizes.dart';
import '../utils/constants/text_strings.dart';
import '../utils/validators/validation.dart';
class TSignupForm extends StatelessWidget {
  const TSignupForm({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
  final dark = THelperFunctions.isDarkMode(context);
  final controller = Get.put(SignupController());
    return Form(
      key: controller.signupFormKey,
      child: Column(
          children: [
            //firstname && lastname
            Row(
                children: [
                  Expanded(
                    child:TextFormField(
                      controller: controller.firstName,
                      validator: (value) => TValidator.validateEmptyText('first name', value),
                      expands: false,
                      decoration : const InputDecoration(labelText:  TTexts.firstName, prefixIcon: Icon(Iconsax.user)),
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwInputFields),
                  Expanded(
                    child:TextFormField(
                      controller: controller.lastName,
                      validator: (value) => TValidator.validateEmptyText('last name', value),
                      expands: false,
                      decoration : const InputDecoration(labelText:  TTexts.firstName, prefixIcon: Icon(Iconsax.user)),
                    ),
                  ),
                ]
            ),
            const SizedBox(width: TSizes.spaceBtwInputFields),
            ///username
            TextFormField(
              controller: controller.userName,
              validator: (value) => TValidator.validateEmptyText('user name', value),
              expands: false,
              decoration: const InputDecoration(labelText: TTexts.username, prefixIcon: Icon(Iconsax.user_edit)),
            ),
            const SizedBox(width: TSizes.spaceBtwInputFields),
            ///Email
            TextFormField(
              validator: (value) => TValidator.validateEmail(value),
              controller: controller.email,
              decoration: const InputDecoration(labelText: TTexts.email, prefixIcon: Icon(Iconsax.direct)),
            ),
            const SizedBox(width: TSizes.spaceBtwInputFields),
            ///Phone Number
            TextFormField(
              validator: (value) => TValidator.validatePhoneNumber(value),
              controller: controller.phoneNumber,
              decoration: const InputDecoration(labelText: TTexts.phoneNo, prefixIcon: Icon(Iconsax.call)),
            ),
            const SizedBox(width: TSizes.spaceBtwInputFields),
            ///Password
            TextFormField(
              validator: (value) => TValidator.validatePassword(value),
              controller: controller.password,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: TTexts.password,
                prefixIcon: Icon(Iconsax.password_check),
                suffixIcon: Icon(Iconsax.eye_slash),
              ),

            ),
            const SizedBox(width: TSizes.spaceBtwInputFields),
            /// Terms and Conditions CheckBox
            Row(
              children: [
                SizedBox(width: 24, height: 24, child: Checkbox(value: true, onChanged: (value){})),
                const SizedBox(width: TSizes.spaceBtwItems),
                Text.rich(TextSpan(
                    children: [
                      TextSpan(text: '${TTexts.iAgreeTo}', style: Theme.of(context).textTheme.bodySmall),
                      TextSpan(text: '${TTexts.privacyPolicy} ', style: Theme.of(context).textTheme.bodyMedium!.apply(
                        color: dark ?TColors.white : TColors.primary,
                        decoration: TextDecoration.underline,
                        decorationColor: dark ? TColors.white : TColors.primary,
                      )),
                      TextSpan(text: '${TTexts.and}', style: Theme.of(context).textTheme.bodySmall),
                      TextSpan(text: '${TTexts.termsOfUse}', style: Theme.of(context).textTheme.bodyMedium!.apply(
                        color: dark ?TColors.white : TColors.primary,
                        decoration: TextDecoration.underline,
                        decorationColor: dark ? TColors.white : TColors.primary,
                      )),
                    ]),
                )
              ],
            ),
            ///signup button
            const SizedBox(height: TSizes.spaceBtwItems),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: ()=> controller.signup(),
                  child: const Text(TTexts.createAccount)),)
          ]
      ),
    );
  }
}