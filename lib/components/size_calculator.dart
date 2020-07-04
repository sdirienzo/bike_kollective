import 'package:flutter/material.dart';

double sizeCalculator(BuildContext context, double portraitMultiplier) {
  return MediaQuery.of(context).size.height * portraitMultiplier;
}
