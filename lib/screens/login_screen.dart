import 'dart:developer';

import 'package:flutter/material.dart';
// import 'register_screen.dart';
import 'home_screen.dart';
import '../services/authentication.dart';
import '../app/app_styles.dart';
import '../app/app_strings.dart';
import '../components/login_register_app_scaffold.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  static const appLogoPath = 'lib/assets/images/app_logo.png';
  final AuthenticationManager auth = new AuthenticationManager();

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  // var _loginSuccessful;
  var _email;
  var _password;
  var _userId;

  // @override
  // void initState() {
  //   super.initState();
  //   _isLoggedIn = false;
  // }

  @override
  Widget build(BuildContext context) {
    return LoginRegiseterAppScaffold(
      backgroundColor: AppStyles.primaryScaffoldBackgroundColor,
      body: SafeArea(
        child: _loginForm(),
      ),
    );
  }

  Widget _loginForm() {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(loginFormPadding()),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              _appLogo(),
              _legalMessage(),
              _emailField(),
              _passwordField(),
              _loginButton(),
              _registerButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _appLogo() {
    return Padding(
      padding: EdgeInsets.only(top: appLogoPadding()),
      child: Image(
        image: AssetImage(LoginScreen.appLogoPath),
        height: appLogoHeight(),
      ),
    );
  }

  Widget _legalMessage() {
    return Padding(
      padding: EdgeInsets.only(top: legalMessagePadding()),
      child: Text('${AppStrings.legalMessage}'),
    );
  }

  Widget _emailField() {
    return Padding(
      padding: EdgeInsets.only(top: emailFieldPadding()),
      child: TextFormField(
        autofocus: false,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: '${AppStrings.emailFieldLabel}',
        ),
        validator: (value) {
          return validateEmail(value);
        },
        onSaved: (value) {
          _email = value.trim();
        },
      ),
    );
  }

  Widget _passwordField() {
    return TextFormField(
      obscureText: true,
      autofocus: false,
      decoration: InputDecoration(
        labelText: '${AppStrings.passwordFieldLabel}',
      ),
      validator: (value) {
        return validatePassword(value);
      },
      onSaved: (value) {
        _password = value.trim();
      },
    );
  }

  Widget _loginButton() {
    return Padding(
      padding: EdgeInsets.only(top: loginButtonPadding()),
      child: SizedBox(
        child: RaisedButton(
          color: AppStyles.primaryButtonColor,
          textColor: AppStyles.primaryButtonTextColor,
          child: Text('${AppStrings.loginButtonLabel}'),
          onPressed: () async {
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              logIn();
              if (_userId == null) {
                // todo: Add logic to display error message when login fails
              } else {
                pushHome();
              }
              // if (_userId != null) {
              //   pushHome();
              // }
            }
          },
        ),
      ),
    );
  }

  Widget _registerButton() {
    return SizedBox(
      child: FlatButton(
        child: Text('${AppStrings.registerButtonLabel}'),
        onPressed: () {
          // pushRegister();
        },
      ),
    );
  }

  double loginFormPadding() {
    return MediaQuery.of(context).size.height * 0.04;
  }

  double appLogoHeight() {
    return MediaQuery.of(context).size.height * 0.2;
  }

  double appLogoPadding() {
    return MediaQuery.of(context).size.height * 0.11;
  }

  double legalMessagePadding() {
    return MediaQuery.of(context).size.height * 0.07;
  }

  double emailFieldPadding() {
    return MediaQuery.of(context).size.height * 0.01;
  }

  double loginButtonPadding() {
    return MediaQuery.of(context).size.height * 0.02;
  }

  String validateEmail(String value) {
    return value.isEmpty ? '${AppStrings.emailFieldHint}' : null;
  }

  String validatePassword(String value) {
    return value.isEmpty ? '${AppStrings.passwordFieldHint}' : null;
  }

  void logIn() async {
    // todo: revisit to determine if this is best way to implement
    try {
      _userId = await widget.auth.signIn(_email, _password);
    } catch (e) {
      _userId = null;
    }
  }

  // void pushRegister() {
  //   Navigator.push(
  //       context, MaterialPageRoute(builder: (context) => RegisterScreen()));
  // }

  void pushHome() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }
}
