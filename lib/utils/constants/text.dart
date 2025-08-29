import 'package:flutter/material.dart';

class FixMeTexts {
  FixMeTexts._();
  
  static Widget fixmeTitle(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Fix',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: const Color(0xFF2563EB), // Blue color
              fontSize: Theme.of(context).textTheme.headlineLarge?.fontSize != null
                  ? Theme.of(context).textTheme.headlineLarge!.fontSize! * 1.2
                  : 32, // 20% larger
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: 'Me',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}