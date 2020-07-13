import 'package:flutter/material.dart';
import 'login_screen.dart';
import '../components/size_calculator.dart';
import '../services/authentication_manager.dart';
import '../app/app_styles.dart';
import '../app/app_strings.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key key}) : super(key: key);

  static const appLogoPath = 'lib/assets/images/app_logo.png';
  final AuthenticationManager auth = new AuthenticationManager();

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  var _scaffoldContext;
  var _email;
  var _password;
  var _userId;
  var _error;

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

  Widget _emailField() {
    return Padding(
      padding: EdgeInsets.only(
          top: sizeCalculator(context, AppStyles.registerEmailFieldPadding)),
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
              submitRegistration().then((value) {
                proceedWithRegistrationResults();
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
          pushLogin();
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

  String validateEmail(String value) {
    return value.isEmpty ? '${AppStrings.emailFieldHint}' : null;
  }

  String validatePassword(String value) {
    return value.isEmpty ? '${AppStrings.passwordFieldHint}' : null;
  }

  Future<void> submitRegistration() async {
    // todo: revisit to determine if this is best way to implement
    try {
      _userId = await widget.auth.register(_email, _password);
    } catch (e) {
      _error = e.code;
    }
  }

  void proceedWithRegistrationResults() {
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
      pushLogin();
    }
  }

  void pushLogin() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
