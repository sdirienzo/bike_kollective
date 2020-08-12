import 'package:bike_kollective/screens/terms_screen.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import '../components/size_calculator.dart';
import '../services/authentication_manager.dart';
import '../services/database_manager.dart';
import '../app/app_styles.dart';
import '../app/app_strings.dart';
import 'package:flutter/gestures.dart';
import 'package:checkbox_formfield/checkbox_formfield.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = 'register';
  static const appLogoPath = 'lib/assets/images/app_logo.png';

  final AuthenticationManager _auth = new AuthenticationManager();
  final DatabaseManager _db = new DatabaseManager();

  RegisterScreen({Key key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  var _scaffoldContext, _email, _password, _userId, _error;
  var checkboxValue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.primaryScaffoldBackgroundColor,
      body: Builder(builder: (BuildContext context) {
        _scaffoldContext = context;
        return SafeArea(
          child: _registerForm(),
        );
      }),
    );
  }

  Widget _registerForm() {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(
            sizeCalculator(context, AppStyles.registerFormPadding)),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              _appLogo(),
              _termsCheckField(),
              _emailField(),
              _passwordField(),
              _registerButton(),
              _loginButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _appLogo() {
    return Padding(
      padding: EdgeInsets.only(
          top: sizeCalculator(context, AppStyles.appLogoPadding)),
      child: Image(
        image: AssetImage(RegisterScreen.appLogoPath),
        height: sizeCalculator(context, AppStyles.appLogoHeight),
      ),
    );
  }

  Widget _termsCheckField() {
    return Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: CheckboxListTileFormField(
        title: new RichText(
          text: new TextSpan(
              style: TextStyle(color: Colors.grey, fontSize: 17.0),
              text: 'By checking you agree to Bike Kollective\'s ',
              children: [
                TextSpan(
                    text: 'Terms of Service',
                    style: TextStyle(color: Colors.blue),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pushNamed(context, TermsScreen.routeName);
                      }),
              ]),
        ),
        onSaved: (bool value) {},
        validator: (bool value) {
          if (value) {
            return null;
          } else {
            return 'You are required to agree to the terms of service';
          }
        },
        controlAffinity: ListTileControlAffinity.leading,
        activeColor: Colors.green,
      ),
    );
  }

  Widget _emailField() {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: TextFormField(
        autofocus: false,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: '${AppStrings.emailFieldLabel}',
        ),
        validator: (value) {
          return _validateEmail(value);
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
        return _validatePassword(value);
      },
      onSaved: (value) {
        _password = value.trim();
      },
    );
  }

  Widget _registerButton() {
    return Padding(
      padding: EdgeInsets.only(
          top: sizeCalculator(context, AppStyles.registerButtonPadding)),
      child: SizedBox(
        child: RaisedButton(
          color: AppStyles.primaryButtonColor,
          textColor: AppStyles.primaryButtonTextColor,
          child: Text('${AppStrings.registerButtonLabel}'),
          onPressed: () async {
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              _submitRegistration().then((value) {
                _proceedWithRegistrationResults();
              });
            }
          },
        ),
      ),
    );
  }

  Widget _loginButton() {
    return SizedBox(
      child: FlatButton(
        child: Text('${AppStrings.loginButtonLabel}'),
        onPressed: () {
          _pushLogin();
        },
      ),
    );
  }

  Widget _registerErrorSnackBar(String errorMessage) {
    return SnackBar(
      content:
          Text(errorMessage, textAlign: AppStyles.registerErrorTextAlignment),
      backgroundColor: AppStyles.registerErrorBackgroundColor,
    );
  }

  String _validateEmail(String value) {
    return value.isEmpty ? '${AppStrings.emailFieldHint}' : null;
  }

  String _validatePassword(String value) {
    return value.isEmpty ? '${AppStrings.passwordFieldHint}' : null;
  }

  Future<void> _submitRegistration() async {
    // todo: revisit to determine if this is best way to implement
    try {
      _userId = await widget._auth.register(_email, _password);
    } catch (e) {
      _error = e.code;
    }
  }

  Future<void> _addUserToDB() async {
    return await widget._db.addUser(_userId, _email);
  }

  void _proceedWithRegistrationResults() {
    if (_userId == null) {
      switch (_error) {
        case AppStrings.invalidEmailErrorCode:
          Scaffold.of(_scaffoldContext).showSnackBar(
              _registerErrorSnackBar(AppStrings.invalidEmailErrorMessage));
          break;
        case AppStrings.weakPasswordErrorCode:
          Scaffold.of(_scaffoldContext).showSnackBar(
              _registerErrorSnackBar(AppStrings.weakPasswordErrorMessage));
          break;
        case AppStrings.emailInUseErrorCode:
          Scaffold.of(_scaffoldContext).showSnackBar(
              _registerErrorSnackBar(AppStrings.emailInUseErrorMessage));
          break;
        case AppStrings.invalidCredentialErrorCode:
          Scaffold.of(_scaffoldContext).showSnackBar(
              _registerErrorSnackBar(AppStrings.invalidEmailErrorMessage));
          break;
        case AppStrings.operationNotAllowedErrorCode:
          Scaffold.of(_scaffoldContext).showSnackBar(
              _registerErrorSnackBar(AppStrings.operationNotAllowedErrorCode));
          break;
        default:
          Scaffold.of(_scaffoldContext).showSnackBar(
              _registerErrorSnackBar(AppStrings.unexpectedErrorMessage));
      }
    } else {
      _addUserToDB().then((result) {
        _pushLogin();
      });
    }
  }

  void _pushLogin() {
    Navigator.pushNamed(context, LoginScreen.routeName);
  }
}
