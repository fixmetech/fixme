import 'package:fixme/features/authentication/controller/signIn_controller.dart';
import 'package:fixme/features/authentication/screens/on_boarding.dart';
import 'package:fixme/utils/constants/colors.dart';
import 'package:fixme/utils/constants/size.dart';
import 'package:fixme/utils/device/device_utils.dart';
import 'package:fixme/utils/helper/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final darK = FixMeDeviceUtils.isDarkMode(context);
    final controller = Get.put(SignInController());


    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(FixMeSizes.defaultSpace),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // This aligns everything to the left
            children: [
              // Top spacing
              SizedBox(height: FixMeDeviceUtils.getAppBarHeight()),

              // Logo - aligned to the left
              Center(
                child: Image(
                  width: FixMeDeviceUtils.getScreenWidth(context) * 0.4,
                  height: FixMeDeviceUtils.getScreenWidth(context) * 0.4,
                  image: AssetImage('assets/images/logo1.png'),
                ),
              ),

              const SizedBox(height: FixMeSizes.spaceBtwSections),

              // Title
              Text(
                "Welcome back!",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: FixMeSizes.spaceBtwItems),

              // Subtitle
              Text(
                "Sign in to your account",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: darK
                      ? FixMeColors.textSecondary
                      : FixMeColors.textPrimary,
                ),
              ),
              const SizedBox(height: FixMeSizes.spaceBtwSections),

              // Form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Phone Number or Email
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Phone or Email',
                        prefixIcon: Icon(Iconsax.direct_right),
                      ),
                      controller: controller.identifierController,
                      validator: (value) =>
                          FixMeHelperFunctions.validateRequired(
                            value,
                            'Phone or Email',
                          ),
                    ),
                    const SizedBox(height: FixMeSizes.spaceBtwInputFields),

                    // Password
                    Obx(
                      () => TextFormField(
                        obscureText: controller.hidePassword.value,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Iconsax.password_check),
                          suffixIcon: IconButton(
                            onPressed: () {
                              controller.hidePassword.value =
                                  !controller.hidePassword.value;
                            },
                            icon: Icon(controller.hidePassword.value
                                ? Iconsax.eye_slash
                                : Iconsax.eye),
                          ),
                        ),
                        controller: controller.passwordController,
                        validator: (value) =>
                            FixMeHelperFunctions.validateRequired(
                              value,
                              'Password',
                            ),
                      ),
                    ),
                    const SizedBox(height: FixMeSizes.spaceBtwInputFields),

                    // Forgot Password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // Handle forgot password
                        },
                        child: Text(
                          'Forgot Password?',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: darK
                                    ? FixMeColors.primary
                                    : FixMeColors.primary,
                              ),
                        ),
                      ),
                    ),
                    const SizedBox(height: FixMeSizes.spaceBtwSections),

                    // Sign In Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            controller.signIn(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: darK
                              ? FixMeColors.primary
                              : FixMeColors.dark,
                          side: BorderSide.none,
                          padding: const EdgeInsets.symmetric(
                            vertical: FixMeSizes.buttonPaddingVertical,
                            horizontal: FixMeSizes.buttonPaddingHorizontal,
                          ),
                        ),
                        child: Text(
                          'Sign In',
                          style: Theme.of(context).textTheme.bodyMedium!.apply(
                            color: darK ? FixMeColors.dark : FixMeColors.light,
                            fontWeightDelta: 3,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: FixMeSizes.spaceBtwInputFields),

                    // Create Account Button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          Get.offAll(
                            () => const OnboardingScreen(initialPage: 1),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: darK
                                ? FixMeColors.primary
                                : FixMeColors.dark,
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: FixMeSizes.buttonPaddingVertical,
                            horizontal: FixMeSizes.buttonPaddingHorizontal,
                          ),
                        ),
                        child: Text(
                          'Create Account',
                          style: Theme.of(context).textTheme.bodyMedium!.apply(
                            color: darK
                                ? FixMeColors.primary
                                : FixMeColors.dark,
                            fontWeightDelta: 3,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
