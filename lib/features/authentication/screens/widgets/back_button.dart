import 'package:fixme/features/authentication/controller/onboarding_controller.dart';
import 'package:fixme/utils/constants/colors.dart';
import 'package:fixme/utils/constants/size.dart';
import 'package:flutter/material.dart';

class backButton extends StatelessWidget {
  const backButton({
    super.key,
    required this.dark,
  });

  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: FixMeSizes.defaultSpace,
      child: Row(
        children: [
          ElevatedButton(
            onPressed: () => OnboardingController.instance.previousPage(),
            style: ElevatedButton.styleFrom(
              side: BorderSide.none,
              shape: const CircleBorder(),
              backgroundColor: dark ? FixMeColors.light : FixMeColors.dark,
            ),
            child: Icon(
              Icons.arrow_back_ios_new,
              color: dark ? FixMeColors.dark : FixMeColors.light,
            ),
          ),
          const SizedBox(width: FixMeSizes.defaultSpace / 2),
          Text(
            'Back',
            style: Theme.of(context).textTheme.labelMedium
          ),
        ],
      ),
    );
  }
}
