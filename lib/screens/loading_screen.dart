import 'package:flutter/material.dart';
import '../components/size_calculator.dart';
import '../app/app_styles.dart';

class LoadingScreen extends StatelessWidget {
  static const appLogoPath = 'lib/assets/images/app_logo.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.primaryScaffoldBackgroundColor,
      body: Center(
          child: Container(
        child: _appLogo(context),
      )),
    );
  }

  Widget _appLogo(BuildContext context) {
    return Image(
      image: AssetImage(appLogoPath),
      height: sizeCalculator(context, AppStyles.appLogoHeight),
    );
  }
}
