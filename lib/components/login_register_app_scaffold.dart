import 'package:flutter/material.dart';

class LoginRegiseterAppScaffold extends StatelessWidget {
  final Widget body;
  final Color backgroundColor;

  LoginRegiseterAppScaffold({Key key, this.backgroundColor, this.body})
      : super(key: key);

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: body,
    );
  }
}
