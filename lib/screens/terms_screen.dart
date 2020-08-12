import 'dart:io';
import 'package:flutter/material.dart';
import '../app/app_styles.dart';

class TermsScreen extends StatefulWidget {
  static const routeName = 'terms';

  TermsScreen({
    Key key,
  }) : super(key: key);

  @override
  _TermsScreenState createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.primaryScaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _terms(),
              _submitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _terms() {
    return Text(
        'TERMS OF USE - You agree not to steal any bikes or sue us if you get injured');
  }

  Widget _submitButton() {
    return RaisedButton(
        child: Text("Continue"),
        onPressed: () {
          Navigator.pop(context);
        });
  }
}
