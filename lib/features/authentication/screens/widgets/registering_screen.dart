import 'package:fixme/features/authentication/controller/signup_controller.dart';
import 'package:fixme/features/authentication/screens/login.dart';
import 'package:fixme/utils/constants/colors.dart';
import 'package:fixme/utils/constants/size.dart';
import 'package:fixme/utils/device/device_utils.dart';
import 'package:fixme/utils/helper/helper_functions.dart';
import 'package:fixme/widgets/form_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class RegisteringScreen extends StatefulWidget {
  const RegisteringScreen({super.key});

  @override
  State<RegisteringScreen> createState() => _RegisteringScreenState();
}

class _RegisteringScreenState extends State<RegisteringScreen> {
  final _formKey = GlobalKey<FormState>();

  void _showTermsAndConditionsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'FixMe Terms and Conditions',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: MediaQuery.of(context).size.height * 0.7,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'By accessing or using the FixMe mobile application (the "App"), you agree to be bound by these Terms and Conditions. Please read them carefully.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),

                  // Section 1
                  Text(
                    '1. Introduction to FixMe Services',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildBulletPoint('FixMe is a Flutter-based mobile application designed to connect users with nearby service providers in real-time.'),
                  _buildBulletPoint('The App offers two main categories of services: Vehicle Services and Home Services.'),
                  _buildBulletPoint('The "Find Now" option allows you to instantly locate and connect with available service providers in your vicinity for repair and maintenance services, similar to platforms like Uber and PickMe.'),
                  const SizedBox(height: 16),

                  // Section 2
                  Text(
                    '2. Understanding Service Provider Verification',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildBulletPoint('FixMe implements a verification process for all technicians registering on the platform.'),
                  _buildBulletPoint('Technicians are required to provide details to verify their identity and professional credibility, including uploading a clear photo of their NIC and capturing a real-time photo for facial verification.'),
                  _buildBulletPoint('To confirm their technical expertise, applicants must submit proof of their skills through professional certificates or evidence of past work.'),
                  const SizedBox(height: 8),
                  Text('Technician Badges:', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                  _buildBadgeInfo('🟢 "Verified Professional"', 'ID and professional certificate verified by FixMe'),
                  _buildBadgeInfo('🔵 "Verified by Experience"', 'ID verified with evidence of past work and references'),
                  _buildBadgeInfo('🟡 "On Probation"', 'Limited approval pending first customer reviews'),
                  const SizedBox(height: 16),

                  // Section 3
                  Text(
                    '3. Payment Terms and Process',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Compulsory Visiting Fee:', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                  _buildBulletPoint('0 – 5 km: LKR 200'),
                  _buildBulletPoint('5 – 10 km: LKR 500'),
                  _buildBulletPoint('10 km and above: LKR 1000'),
                  const SizedBox(height: 8),
                  _buildBulletPoint('Visiting fee is payable upon technician arrival, regardless of job acceptance.'),
                  _buildBulletPoint('You must explicitly approve estimated costs through the App before work begins.'),
                  _buildBulletPoint('If you reject the estimated cost, only the visiting fee will be charged.'),
                  _buildBulletPoint('Final payment can be processed through PayHere gateway or cash to technician.'),
                  const SizedBox(height: 16),

                  // Section 4
                  Text(
                    '4. Customer Feedback and Complaint Resolution',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildBulletPoint('Your feedback and ratings are crucial for the FixMe platform, particularly for technicians "On Probation."'),
                  _buildBulletPoint('Complaints are investigated by FixMe moderators who may provide refunds or apply technician penalties.'),
                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: FixMeColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Using the FixMe app is like hiring a contractor through a transparent, digital marketplace. You get to see their credentials (badges), understand the upfront costs (visiting fee), approve the final job price before work begins, and have a clear path for payment and dispute resolution.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [

            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Optionally auto-check the checkbox when they close after reading
                final controller = Get.find<SignupController>();
                controller.privacyPolicy.value = true;
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: FixMeColors.primary,
              ),
              child: const Text('Close', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 16)),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeInfo(String badge, String description) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$badge: ', style: const TextStyle(fontWeight: FontWeight.w600)),
          Expanded(
            child: Text(
              description,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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

                // Terms & Conditions Checkbox with Clickable Privacy Policy
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
                    Expanded(
                      child: RichText(
                        text: TextSpan(
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
                              recognizer: TapGestureRecognizer()
                                ..onTap = _showTermsAndConditionsDialog,
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
                              recognizer: TapGestureRecognizer()
                                ..onTap = _showTermsAndConditionsDialog,
                            ),
                          ],
                        ),
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