import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../app/app_styles.dart';
import '../app/app_strings.dart';
import '../components/app_scaffold.dart';
// import '../models/user.dart';

class LoginScreen extends StatefulWidget {

  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: null,
      backgroundColor: AppStyles.navBarColorDefault,
      body: SafeArea(
        child: Placeholder()
      )
    );
  }
}