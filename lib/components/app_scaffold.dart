import 'package:flutter/material.dart';
import '../app/app_styles.dart';

class AppScaffold extends StatelessWidget {
  final Widget title;
  final Color backgroundColor;
  final Widget body;

  AppScaffold({Key key, this.title, this.backgroundColor, this.body})
      : super(key: key);

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: title,
        backgroundColor: backgroundColor,
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: AppStyles.navBarIconColor),
      ),
      body: body,
    );
  }
}
