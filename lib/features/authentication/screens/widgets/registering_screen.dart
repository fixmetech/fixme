import 'package:fixme/features/authentication/controller/signup_controller.dart';
import 'package:fixme/features/authentication/screens/login.dart';
import 'package:fixme/utils/constants/colors.dart';
import 'package:fixme/utils/constants/size.dart';
import 'package:fixme/utils/device/device_utils.dart';
import 'package:fixme/utils/helper/helper_functions.dart';
import 'package:fixme/widgets/form_divider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class RegisteringScreen extends StatefulWidget {
  const RegisteringScreen({super.key});

  @override
  State<RegisteringScreen> createState() => _RegisteringScreenState();
}

class _RegisteringScreenState extends State<RegisteringScreen> {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final darK = FixMeDeviceUtils.isDarkMode(context);
    final controller = Get.find<SignupController>();
    return Padding(
      padding: const EdgeInsets.all(FixMeSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            "Let's create your account",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: FixMeSizes.spaceBtwSections),

          // Form
          Form(
            key: _formKey,
            child: Column(
              children: [
                // First & Last Name
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: controller.firstNameController,
                        validator: (value) =>
                            FixMeHelperFunctions.validateRequired(
                              value,
                              'First Name',
                            ),
                        expands: false,
                        decoration: const InputDecoration(
                          labelText: 'First Name',
                          prefixIcon: Icon(Iconsax.user),
                        ),
                      ),
                    ),
                    const SizedBox(width: FixMeSizes.spaceBtwInputFields),
                    Expanded(
                      child: TextFormField(
                        controller: controller.lastNameController,
                        validator: (value) =>
                            FixMeHelperFunctions.validateRequired(
                              value,
                              'Last Name',
                            ),
                        expands: false,
                        decoration: const InputDecoration(
                          labelText: 'Last Name',
                          prefixIcon: Icon(Iconsax.user),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: FixMeSizes.spaceBtwInputFields),

                // Email
                TextFormField(
                  controller: controller.emailController,
                  validator: (value) =>
                      FixMeHelperFunctions.validateEmail(value),
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Iconsax.direct),
                  ),
                ),
                const SizedBox(height: FixMeSizes.spaceBtwInputFields),

                // Phone Number
                TextFormField(
                  controller: controller.phoneNumberController,
                  validator: (value) =>
                      FixMeHelperFunctions.validatePhoneNumber(value),
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    prefixIcon: Icon(Iconsax.call),
                  ),
                ),
                const SizedBox(height: FixMeSizes.spaceBtwInputFields),

                // Password
                Obx(
                  () => TextFormField(
                    controller: controller.passwordController,
                    validator: (value) =>
                        FixMeHelperFunctions.validatePassword(value),
                    obscureText: controller.hidePassword.value,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Iconsax.password_check),
                      suffixIcon: IconButton(
                        onPressed: () => controller.hidePassword.value =
                            !controller.hidePassword.value,
                        icon: Icon(
                          controller.hidePassword.value
                              ? Iconsax.eye_slash
                              : Iconsax.eye,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: FixMeSizes.spaceBtwInputFields),

                // Terms & Conditions Checkbox
                Row(
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Obx(
                        () => Checkbox(
                          value: controller.privacyPolicy.value,
                          onChanged: (value) {
                            controller.privacyPolicy.value = value ?? false;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: FixMeSizes.spaceBtwButtons),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'I agree to ',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: Theme.of(context).textTheme.bodyMedium!
                                .apply(
                                  color: darK
                                      ? FixMeColors.light
                                      : FixMeColors.primary,
                                  decoration: TextDecoration.underline,
                                  decorationColor: FixMeColors.primary,
                                ),
                          ),
                          TextSpan(
                            text: ' and ',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          TextSpan(
                            text: 'Terms of Use',
                            style: Theme.of(context).textTheme.bodyMedium!
                                .apply(
                                  color: darK
                                      ? FixMeColors.light
                                      : FixMeColors.primary,
                                  decoration: TextDecoration.underline,
                                  decorationColor: FixMeColors.primary,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: FixMeSizes.spaceBtwSections),
                // Register Button
                IntrinsicWidth(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        controller.signup(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: darK
                          ? FixMeColors.iconTertiary
                          : FixMeColors.dark,
                      side: BorderSide.none,
                      padding: const EdgeInsets.symmetric(
                        vertical: FixMeSizes.buttonPaddingVertical,
                        horizontal: FixMeSizes.buttonPaddingHorizontal,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min, // This is key!
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Create Account',
                          style: Theme.of(context).textTheme.bodyMedium!.apply(
                            color: darK ? FixMeColors.dark : FixMeColors.light,
                            fontWeightDelta: 3,
                          ),
                        ),
                        SizedBox(width: FixMeSizes.spaceBtwItems),
                        const Icon(Iconsax.arrow_right_3_copy),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: FixMeSizes.spaceBtwSections),
                FormDivider(text: 'Already have an account?'),
                const SizedBox(height: FixMeSizes.spaceBtwInputFields),

                // Link to Login
                TextButton(
                  onPressed: () {
                    Get.to(LoginScreen());
                  },
                  child: Text(
                    'LOGIN',
                    style: Theme.of(context).textTheme.bodyMedium!.apply(
                      color: darK ? FixMeColors.light : FixMeColors.primary,
                      fontWeightDelta: 3, // This makes it bold
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
