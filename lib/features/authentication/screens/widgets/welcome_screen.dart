import 'package:fixme/features/authentication/screens/widgets/next_button.dart';
import 'package:fixme/utils/device/device_utils.dart';
import 'package:fixme/utils/constants/size.dart';
import 'package:flutter/material.dart';

class welcome_screen extends StatelessWidget {
  const welcome_screen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(FixMeSizes.defaultSpace),
      child: Column(
        children: [
          SizedBox(height: FixMeDeviceUtils.getAppBarHeight() + 50),
          Image(
            width: FixMeDeviceUtils.getScreenWidth(context) * 0.5,
            height: FixMeDeviceUtils.getScreenWidth(context) * 0.5,
            image: AssetImage('assets/images/logo1.png')),
          const SizedBox(height: 20),
          Text(
            'Welcome to FixMe',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 10),
          Text(
            'All services at your fingertips—from home repairs to tech support, we’ve got you covered.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          // next button
          nextButton(),
        ],
      ),
    );
  }
}
