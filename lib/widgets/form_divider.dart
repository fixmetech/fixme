import 'package:fixme/utils/constants/colors.dart';
import 'package:fixme/utils/device/device_utils.dart';
import 'package:flutter/material.dart';

class FormDivider extends StatelessWidget {
  final String text;

  const FormDivider({super.key, required this.text});
  @override
  Widget build(BuildContext context) {
    final dark = FixMeDeviceUtils.isDarkMode(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(child: Divider(color: dark ? FixMeColors.darkContainer : FixMeColors.dark, thickness: 0.5, indent: 60, endIndent: 5,)),
        Text( text, style: Theme.of(context).textTheme.labelMedium),
        Flexible(child: Divider(color: dark ? FixMeColors.darkContainer : FixMeColors.dark, thickness: 0.5, indent: 5, endIndent: 60,)),
      ],
    );
  }
}