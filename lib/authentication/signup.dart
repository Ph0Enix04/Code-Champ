import 'package:code_champ/utils/constants/colors.dart';
import 'package:code_champ/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../utils/constants/text_strings.dart';
import '../utils/constants/sizes.dart';
import '../utils/theme/theme.dart';
import 'form_divider.dart';
class  signUp extends StatelessWidget {
  const signUp({Key, key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //title
              Text(TTexts.signupTitle, style: Theme.of(context).textTheme.headlineMedium,),
              TSignupForm(dark: dark),
              //Divider
              TFormDivider(dividerText: TTexts.orSignUpWith.capitalize!),
              const SizedBox(height: TSizes.spaceBtwItems),
              const SizedBox(height: TSizes.spaceBtwItems),
            ],
          ),
        )
      ),
    );
  }
}

class TSignupForm extends StatelessWidget {
  const TSignupForm({
    super.key,
    required this.dark,
  });

  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
      children: [
        Row(
          children: [
            Expanded(
              child:TextFormField(
                expands: false,
                decoration : const InputDecoration(labelText:  TTexts.firstName, prefixIcon: Icon(Iconsax.user)),
              ),
            ),
            const SizedBox(width: TSizes.spaceBtwInputFields),
            Expanded(
              child:TextFormField(
                expands: false,
                decoration : const InputDecoration(labelText:  TTexts.firstName, prefixIcon: Icon(Iconsax.user)),
              ),
            ),
          ]
        ),
        const SizedBox(width: TSizes.spaceBtwInputFields),
        ///username
        TextFormField(
          expands: false,
          decoration: const InputDecoration(labelText: TTexts.username, prefixIcon: Icon(Iconsax.user_edit)),
        ),
        const SizedBox(width: TSizes.spaceBtwInputFields),
        ///Email
        TextFormField(
          decoration: const InputDecoration(labelText: TTexts.email, prefixIcon: Icon(Iconsax.direct)),
        ),
        const SizedBox(width: TSizes.spaceBtwInputFields),
        ///Phone Number
        TextFormField(
          decoration: const InputDecoration(labelText: TTexts.phoneNo, prefixIcon: Icon(Iconsax.call)),
        ),
        const SizedBox(width: TSizes.spaceBtwInputFields),
        ///Password
        TextFormField(
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
        SizedBox(width: double.infinity, child: ElevatedButton(onPressed: (){}, child: const Text(TTexts.createAccount)),)
      ]
    ),
    );
  }
}
