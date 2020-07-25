import 'package:flutter/material.dart';
import 'package:bike_kollective/components/screen_arguments.dart';
import 'register_screen.dart';
import 'home_screen.dart';
import '../components/size_calculator.dart';
import '../services/authentication_manager.dart';
import '../app/app_styles.dart';
import '../app/app_strings.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = 'login';
  static const appLogoPath = 'lib/assets/images/app_logo.png';

  final AuthenticationManager _auth = AuthenticationManager();

  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  var _scaffoldContext, _email, _password, _userId, _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.primaryScaffoldBackgroundColor,
      body: Builder(builder: (BuildContext context) {
        _scaffoldContext = context;
        return SafeArea(
          child: _loginForm(),
        );
      }),
    );
  }

  Widget _loginForm() {
    return Container(
      child: Padding(
        padding:
            EdgeInsets.all(sizeCalculator(context, AppStyles.loginFormPadding)),
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
      padding: EdgeInsets.only(
          top: sizeCalculator(context, AppStyles.appLogoPadding)),
      child: Image(
        image: AssetImage(LoginScreen.appLogoPath),
        height: sizeCalculator(context, AppStyles.appLogoHeight),
      ),
    );
  }

  Widget _legalMessage() {
    return Padding(
      padding: EdgeInsets.only(
          top: sizeCalculator(context, AppStyles.legalMessagePadding)),
      child: Text('${AppStrings.legalMessage}'),
    );
  }

  Widget _emailField() {
    return Padding(
      padding: EdgeInsets.only(
          top: sizeCalculator(context, AppStyles.loginEmailFieldPadding)),
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
      padding: EdgeInsets.only(
          top: sizeCalculator(context, AppStyles.loginButtonPadding)),
      child: SizedBox(
        child: RaisedButton(
          color: AppStyles.primaryButtonColor,
          textColor: AppStyles.primaryButtonTextColor,
          child: Text('${AppStrings.loginButtonLabel}'),
          onPressed: () async {
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              submitCredentials().then((result) {
                proceedWithLoginResult();
              });
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
          pushRegister();
        },
      ),
    );
  }

  Widget _loginErrorSnackBar(String errorMessage) {
    return SnackBar(
      content: Text(errorMessage, textAlign: AppStyles.loginErrorTextAlignment),
      backgroundColor: AppStyles.loginErrorBackgroundColor,
    );
  }

  String validateEmail(String value) {
    return value.isEmpty ? '${AppStrings.emailFieldHint}' : null;
  }

  String validatePassword(String value) {
    return value.isEmpty ? '${AppStrings.passwordFieldHint}' : null;
  }

  Future<void> submitCredentials() async {
    // todo: revisit to determine if this is best way to implement
    try {
      _userId = await widget._auth.signIn(_email, _password);
    } catch (e) {
      _error = e.code;
    }
  }

  void proceedWithLoginResult() {
    if (_userId == null) {
      switch (_error) {
        case AppStrings.invalidEmailErrorCode:
        case AppStrings.wrongPasswordErrorCode:
        case AppStrings.noUserErrorCode:
        case AppStrings.disabledUserErrorCode:
        case AppStrings.tooManyRequestErrorCode:
        case AppStrings.operationNotAllowedErrorCode:
          Scaffold.of(_scaffoldContext)
              .showSnackBar(_loginErrorSnackBar(AppStrings.loginErrorMessage));
          break;
        default:
          Scaffold.of(_scaffoldContext).showSnackBar(
              _loginErrorSnackBar(AppStrings.unexpectedErrorMessage));
      }
    } else {
      pushHome();
    }
  }

  void pushRegister() {
    Navigator.pushNamed(context, RegisterScreen.routeName);
  }

  void pushHome() {
    Navigator.pushNamedAndRemoveUntil(
        context, HomeScreen.routeName, (route) => false,
        arguments: ScreenArguments(userEmail: _email));
  }
}
